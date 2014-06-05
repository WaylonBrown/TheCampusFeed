package com.appuccino.collegefeed.adapters;

import java.util.Calendar;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Html;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.ClickableSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.GetPostsTask;
import com.appuccino.collegefeed.utils.NetWorker.MakeVoteTask;
import com.appuccino.collegefeed.utils.NetWorker.PostSelector;
import com.appuccino.collegefeed.utils.TimeParser;

public class PostListAdapter extends ArrayAdapter<Post>{

	Context context; 
    int layoutResourceId;    
    List<Post> postList = null;
    int whichlist = -1;
    
    public PostListAdapter(Context context, int layoutResourceId, List<Post> list, int whichList) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        postList = list;
        this.whichlist = whichList;
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;	//this is listview_item_row
        PostHolder postHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	postHolder = new PostHolder();
        	postHolder.scoreText = (TextView)row.findViewById(R.id.scoreText);
        	postHolder.messageText = (TextView)row.findViewById(R.id.messageText);
        	postHolder.timeText = (TextView)row.findViewById(R.id.timeText);
        	postHolder.commentText = (TextView)row.findViewById(R.id.commentText);
        	postHolder.arrowUp = (ImageView)row.findViewById(R.id.arrowUp);
        	postHolder.arrowDown = (ImageView)row.findViewById(R.id.arrowDown);
        	//these two will return null if not showing posts with college names
        	postHolder.collegeName = (TextView)row.findViewById(R.id.collegeNameText);
        	postHolder.gpsImage = (ImageView)row.findViewById(R.id.gpsImage);
            
            postHolder.scoreText.setTypeface(FontManager.bold);
            postHolder.messageText.setTypeface(FontManager.light);
            postHolder.timeText.setTypeface(FontManager.medium);
            postHolder.commentText.setTypeface(FontManager.medium);
            if(postHolder.collegeName != null)
            	postHolder.collegeName.setTypeface(FontManager.italic);
            
            row.setTag(postHolder);
        }
        else
        	postHolder = (PostHolder)row.getTag();
        
        final Post thisPost = postList.get(position);
        postHolder.scoreText.setText(String.valueOf(thisPost.getScore()));
        if(postHolder.collegeName != null)
        	postHolder.collegeName.setText(thisPost.getCollegeName());
        if(postHolder.gpsImage != null)
        	setGPSImageVisibility(postHolder, thisPost);
        
        String commentString = thisPost.getCommentList().size() + " comment";
        if(thisPost.getCommentList().size() != 1)
        	commentString += "s";
        postHolder.commentText.setText(commentString);
        
        setMessageAndColorizeTags(thisPost.getMessage(), postHolder);
        setTime(thisPost.getTime(), postHolder.timeText);
        
        //arrow click listeners
        postHolder.arrowUp.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already upvoted, un-upvote
				if(thisPost.getVote() == -1)
				{
					thisPost.setVote(1);
					thisPost.score += 2;
				}
				else if(thisPost.getVote() == 0)
				{
					thisPost.setVote(1);
					thisPost.score++;
				}
				else 
				{
					thisPost.setVote(0);
					thisPost.score--;
				}
				TopPostFragment.updateList();
				NewPostFragment.updateList();
				TagListActivity.updateList();
				new MakeVoteTask().execute(new Vote(thisPost.getID(), true));
			}        	
        });
        postHolder.arrowDown.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) 
			{
				if(MainActivity.hasPermissions(thisPost.getCollegeID()))
				{
					//if already downvoted, un-downvote
					if(thisPost.getVote() == -1)
					{
						thisPost.setVote(0);
						thisPost.score++;
					}
					else if(thisPost.getVote() == 0)
					{
						thisPost.setVote(-1);
						thisPost.score--;
					}
					else 
					{
						thisPost.setVote(-1);
						thisPost.score -= 2;
					}
					TopPostFragment.updateList();
					NewPostFragment.updateList();
					TagListActivity.updateList();
				}
				else
				{
					Toast.makeText(context, "You need to be near the college to downvote", Toast.LENGTH_LONG).show();
				}
			}        	
        });
        
        int vote = thisPost.getVote();
        if(vote == -1)
        {
        	postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdownred));
        	postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
        }
        else if (vote == 1)
        {
        	postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowupblue));
        	postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }
        else	//no votes
        {
        	postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
        	postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }
        
        return row;
    }
        
    private void setTime(String time, TextView timeText) {
    	Calendar thisPostTime = TimeParser.toCalendar(time);
    	Calendar now = Calendar.getInstance();
    	
    	
	}

	private void setGPSImageVisibility(PostHolder holder, Post thisPost) 
    {
		if(MainActivity.permissions == null)
		{
			holder.gpsImage.setVisibility(View.GONE);
		}
		else if(!MainActivity.hasPermissions(thisPost.getCollegeID()))
		{
			holder.gpsImage.setVisibility(View.GONE);
		}
		else
		{
			holder.gpsImage.setVisibility(View.VISIBLE);
		}
	}

//    private void setMessageAndColorizeTags(String msg, PostHolder postHolder) 
//    {
//    	String tagColor = "#33B5E5";
//    	String message = msg;
//    	
//    	String[] wordArray = message.split(" ");
//    	//check for tags, colorize them
//    	for(int i = 0; i < wordArray.length; i++)
//    	{
//    		if(wordArray[i].length() > 0 && wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
//    		{
//    			wordArray[i] = "<font color='" + tagColor + "'>" + wordArray[i] + "</font>";
//    		}
//    	}
//    	
//    	message = "";
//    	//combine back to string
//    	for(int i = 0; i < wordArray.length; i++)
//    	{
//    		message += wordArray[i] + " ";
//    	}
//    	
//    	postHolder.messageText.setText(Html.fromHtml(message));
//    	
//		
//	}
    
    private void setMessageAndColorizeTags(String msg, PostHolder postHolder) 
    {
    	String tagColor = "#33B5E5";
    	String message = msg;
    	
    	String[] wordArray = message.split(" ");
    	//check for tags, colorize them
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		if(wordArray[i].length() > 0 && wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
    		{
    			wordArray[i] = "<font color='" + tagColor + "'>" + wordArray[i] + "</font>";
    		}
    	}
    	
    	message = "";
    	//combine back to string
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		message += wordArray[i] + " ";
    	}
    	
    	//TODO: implement clickable text in TextView
//    	ClickableSpan span1 = new ClickableSpan() {
//            @Override
//            public void onClick(View textView) 
//            {
//                Toast.makeText(context, "test", Toast.LENGTH_SHORT).show();
//            }
//        };
//    	SpannableString ss = new SpannableString(Html.fromHtml(message));
//		ss.setSpan(span1, 5, 10, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
//    	postHolder.messageText.setText(Html.fromHtml(message));
    	postHolder.messageText.setText(Html.fromHtml(message));
		
	}

	static class PostHolder
    {
    	TextView scoreText;
    	TextView messageText;
    	TextView timeText;
    	TextView commentText;
    	TextView collegeName;
    	ImageView arrowUp;
    	ImageView arrowDown;
    	ImageView gpsImage;
    }
}
