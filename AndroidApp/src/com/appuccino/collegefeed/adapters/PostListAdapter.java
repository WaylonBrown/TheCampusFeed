package com.appuccino.collegefeed.adapters;

import java.text.ParseException;
import java.util.Calendar;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Html;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.ClickableSpan;
import android.util.Log;
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
import com.appuccino.collegefeed.utils.TimeManager;

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
        	postHolder.gpsImageGap = (View)row.findViewById(R.id.gpsImageGapFiller);
            
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
        if(postHolder.gpsImage != null){
        	setGPSImageVisibility(postHolder, thisPost);
        }
        
        String commentString = thisPost.getCommentList().size() + " comment";
        if(thisPost.getCommentList().size() != 1)
        	commentString += "s";
        postHolder.commentText.setText(commentString);
        
        setMessageAndColorizeTags(thisPost.getMessage(), postHolder);
        try {
			setTime(thisPost, postHolder.timeText);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
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
        
    private void setTime(Post thisPost, TextView timeText) throws ParseException {
    	Calendar thisPostTime = TimeManager.toCalendar(thisPost.getTime());
    	Calendar now = Calendar.getInstance();
    	
    	int yearsDiff;
    	int monthsDiff;
    	int weeksDiff;
    	int daysDiff;
    	int hoursDiff;
    	int minutesDiff;
    	int secondsDiff;
    	
    	yearsDiff = now.get(Calendar.YEAR) - thisPostTime.get(Calendar.YEAR);
    	monthsDiff = now.get(Calendar.MONTH) - thisPostTime.get(Calendar.MONTH);
    	weeksDiff = now.get(Calendar.WEEK_OF_YEAR) - thisPostTime.get(Calendar.WEEK_OF_YEAR);
    	daysDiff = now.get(Calendar.DAY_OF_YEAR) - thisPostTime.get(Calendar.DAY_OF_YEAR);
    	hoursDiff = now.get(Calendar.HOUR_OF_DAY) - thisPostTime.get(Calendar.HOUR_OF_DAY);
    	minutesDiff = now.get(Calendar.MINUTE) - thisPostTime.get(Calendar.MINUTE);
    	secondsDiff = now.get(Calendar.SECOND) - thisPostTime.get(Calendar.SECOND);
    	
//    	Log.i("cfeed","Time difference for post " + thisPost.getMessage().substring(0, 10) + ": Years: " + yearsDiff + " Months: " + monthsDiff +
//    			" Weeks: " + weeksDiff + " Days: " + daysDiff + " Hours: " + hoursDiff + " Minutes: " + minutesDiff + " Seconds: " + secondsDiff);
    	
    	String timeOutputText = "";
    	if(yearsDiff > 0){
    		timeOutputText = yearsDiff + " year";
    		if(yearsDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(monthsDiff > 0){
    		timeOutputText = monthsDiff + " month";
    		if(monthsDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(weeksDiff > 0){
    		timeOutputText = weeksDiff + " week";
    		if(weeksDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(daysDiff > 0){
    		timeOutputText = daysDiff + " day";
    		if(daysDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(hoursDiff > 0){
    		timeOutputText = hoursDiff + " hour";
    		if(hoursDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(minutesDiff > 0){
    		timeOutputText = minutesDiff + " minute";
    		if(minutesDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(secondsDiff > 0){
    		timeOutputText = secondsDiff + " second";
    		if(secondsDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else{
    		timeOutputText = "Just now";
    	}
    	
    	timeText.setText(timeOutputText);
	}

	private void setGPSImageVisibility(PostHolder holder, Post thisPost) 
    {
		if(MainActivity.permissions == null)
		{
			holder.gpsImage.setVisibility(View.GONE);
			holder.gpsImageGap.setVisibility(View.GONE);
		}
		else if(!MainActivity.hasPermissions(thisPost.getCollegeID()))
		{
			holder.gpsImage.setVisibility(View.GONE);
			holder.gpsImageGap.setVisibility(View.GONE);
		}
		else
		{
			holder.gpsImage.setVisibility(View.VISIBLE);
			holder.gpsImageGap.setVisibility(View.VISIBLE);
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
    	View gpsImageGap;
    }
}
