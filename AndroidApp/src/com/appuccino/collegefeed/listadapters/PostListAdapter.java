package com.appuccino.collegefeed.listadapters;

import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Html;
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
import com.appuccino.collegefeed.objects.NetWorker.GetPostsTask;
import com.appuccino.collegefeed.objects.NetWorker.MakeVoteTask;
import com.appuccino.collegefeed.objects.NetWorker.PostSelector;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;

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
        	if(MainActivity.spinner.getSelectedItemPosition() != 2)
        		postHolder.collegeName = (TextView)row.findViewById(R.id.collegeNameText);
            		
        	Typeface light = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-Light.ttf");
        	Typeface medium = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-Medium.ttf");
            Typeface lightItalic = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-LightItalic.ttf");
            Typeface bold = Typeface.createFromAsset(context.getAssets(), "fonts/mplus-2c-bold.ttf");
            
            postHolder.scoreText.setTypeface(bold);
            postHolder.messageText.setTypeface(light);
            postHolder.timeText.setTypeface(lightItalic);
            postHolder.commentText.setTypeface(lightItalic);
            if(postHolder.collegeName != null)
            	postHolder.collegeName.setTypeface(lightItalic);
            
            row.setTag(postHolder);
        }
        else
        	postHolder = (PostHolder)row.getTag();
        
        final Post thisPost = postList.get(position);
        postHolder.scoreText.setText(String.valueOf(thisPost.getScore()));
        postHolder.timeText.setText(String.valueOf(thisPost.getHoursAgo()) + " hours ago");
        if(postHolder.collegeName != null)
        	postHolder.collegeName.setText(thisPost.getCollegeName());
        
        String commentString = thisPost.getCommentList().size() + " comment";
        if(thisPost.getCommentList().size() != 1)
        	commentString += "s";
        postHolder.commentText.setText(commentString);
        setMessageAndColorizeTags(thisPost.getMessage(), postHolder);
        
        //arrow click listeners
        postHolder.arrowUp.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already upvoted, un-upvote
				if(thisPost.getVote() != 1)
					thisPost.setVote(1);
				else
					thisPost.setVote(0);
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
				if(MainActivity.permissions == thisPost.getCollegeID())
				{
					//if already downvoted, un-downvote
					if(thisPost.getVote() != -1)
						thisPost.setVote(-1);
					else
						thisPost.setVote(0);
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
    }
}
