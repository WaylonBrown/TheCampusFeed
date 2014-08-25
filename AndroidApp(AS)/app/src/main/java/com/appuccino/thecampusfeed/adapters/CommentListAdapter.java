package com.appuccino.thecampusfeed.adapters;

import android.app.Activity;
import android.content.Context;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.CommentsActivity;
import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.objects.Comment;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.objects.Vote;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.NetWorker;
import com.appuccino.thecampusfeed.utils.TimeManager;

import java.text.ParseException;
import java.util.Calendar;
import java.util.List;

public class CommentListAdapter extends ArrayAdapter<Comment>{

	Context context; 
    int layoutResourceId;    
    List<Comment> commentList = null;
    private Post post;
    
    public CommentListAdapter(Context context, int layoutResourceId, List<Comment> list, Post post) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        commentList = list;
        this.post = post;
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;	//this is listview_item_row
        CommentHolder commentHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	commentHolder = new CommentHolder();
        	commentHolder.scoreText = (TextView)row.findViewById(R.id.scoreText);
        	commentHolder.messageText = (TextView)row.findViewById(R.id.messageText);
        	commentHolder.timeText = (TextView)row.findViewById(R.id.timeText);
        	commentHolder.commentsText = (TextView)row.findViewById(R.id.commentText);
        	commentHolder.arrowUp = (ImageView)row.findViewById(R.id.arrowUp);
        	commentHolder.arrowDown = (ImageView)row.findViewById(R.id.arrowDown);
        	commentHolder.bottomPadding = row.findViewById(R.id.bottomPadding);
            
            commentHolder.scoreText.setTypeface(FontManager.bold);
            commentHolder.messageText.setTypeface(FontManager.light);
            commentHolder.timeText.setTypeface(FontManager.medium);
            
            row.setTag(commentHolder);
        }
        else
        	commentHolder = (CommentHolder)row.getTag();
        
        final Comment thisComment = commentList.get(position);
        commentHolder.scoreText.setText(String.valueOf(thisComment.getScore()));
        commentHolder.messageText.setText(thisComment.getMessage());
        commentHolder.commentsText.setVisibility(View.GONE);
        commentHolder.bottomPadding.setVisibility(View.VISIBLE);
        
        try {
			setTime(thisComment, commentHolder.timeText);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        
        setMessageAndColorizeTags(thisComment.getMessage(), commentHolder);
        
        //arrow click listeners
        final CommentHolder finalPostHolder = commentHolder;
        final View finalRow = row;
        commentHolder.arrowUp.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
                int currentVote = MainActivity.getVoteByCommentId(thisComment.getID());

				//if already upvoted, un-upvote
				if(currentVote == -1)
				{
					thisComment.setVote(1);
					thisComment.score += 2;
                    updateRowViews(finalRow, finalPostHolder, 1, thisComment);
                    new NetWorker.MakeCommentVoteDeleteTask(context).execute(MainActivity.voteObjectFromCommentID(thisComment.getID()));
                    new NetWorker.MakeCommentVoteTask(context, thisComment).execute(new Vote(0, post.getID(), thisComment.getID(), true));
				}
				else if(currentVote == 0)
				{
					thisComment.setVote(1);
					thisComment.score++;
                    updateRowViews(finalRow, finalPostHolder, 1, thisComment);
                    new NetWorker.MakeCommentVoteTask(context, thisComment).execute(new Vote(0, post.getID(), thisComment.getID(), true));
				}
				else 
				{
					thisComment.setVote(0);
					thisComment.score--;
                    updateRowViews(finalRow, finalPostHolder, 0, thisComment);
                    new NetWorker.MakeCommentVoteDeleteTask(context).execute(MainActivity.voteObjectFromCommentID(thisComment.getID()));
				}
			}        	
        });
        commentHolder.arrowDown.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				Log.i("cfeed","College id: " + thisComment.getCollegeID());
				//post is null if this comment list is received from the MyCommentsFragment and not a comments list to a post
				if(post != null && MainActivity.hasPermissions(post.getCollegeID()))
				{
                    int currentVote = MainActivity.getVoteByCommentId(thisComment.getID());

					//if already downvoted, un-downvote
					if(currentVote == -1)
					{
						thisComment.setVote(0);
						thisComment.score++;
                        updateRowViews(finalRow, finalPostHolder, 0, thisComment);
                        new NetWorker.MakeCommentVoteDeleteTask(context).execute(MainActivity.voteObjectFromCommentID(thisComment.getID()));
					}
					else if(currentVote == 0)
					{
						thisComment.setVote(-1);
						thisComment.score--;
                        updateRowViews(finalRow, finalPostHolder, -1, thisComment);
                        new NetWorker.MakeCommentVoteTask(context, thisComment).execute(new Vote(0, post.getID(), thisComment.getID(), false));
					}
					else 
					{
						thisComment.setVote(-1);
						thisComment.score -= 2;
                        updateRowViews(finalRow, finalPostHolder, -1, thisComment);
                        new NetWorker.MakeCommentVoteDeleteTask(context).execute(MainActivity.voteObjectFromCommentID(thisComment.getID()));
                        new NetWorker.MakeCommentVoteTask(context, thisComment).execute(new Vote(0, post.getID(), thisComment.getID(), false));
					}
					CommentsActivity.updateList();
				}
				else
				{
					Log.i("cfeed", "CollegeID of this comment: " + thisComment.getCollegeID());
					String message = "User permission IDs: ";
					for(int i: MainActivity.permissions){
						message += i + ", ";
					}
					Log.i("cfeed", message);
					
					Toast.makeText(context, "You need to be near the college to downvote", Toast.LENGTH_LONG).show();
				}
			}        	
        });
        
        thisComment.setVote(MainActivity.getVoteByCommentId(thisComment.getID()));
        int vote = thisComment.getVote();

        updateRowViews(finalRow, commentHolder, vote, thisComment);

        return row;
    }

    private void updateRowViews(View row, CommentHolder commentHolder, int vote, Comment comment) {
        int score = comment.score;

        Log.i("cfeed","Row is setting to " + vote);
        if(vote == -1)
        {
            commentHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
            commentHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdownred));
        }
        else if (vote == 1)
        {
            commentHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowupblue));
            commentHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }
        else	//no votes
        {
            commentHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
            commentHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }

        commentHolder.scoreText.setText(String.valueOf(score));

        row.invalidate();
    }

    private void setTime(Comment thisComment, TextView timeText) throws ParseException {
    	Calendar thisCommentTime = TimeManager.toCalendar(thisComment.getTime());
    	Calendar now = Calendar.getInstance();
    	
    	int yearsDiff;
    	int monthsDiff;
    	int weeksDiff;
    	int daysDiff;
    	int hoursDiff;
    	int minutesDiff;
    	int secondsDiff;
    	
    	yearsDiff = now.get(Calendar.YEAR) - thisCommentTime.get(Calendar.YEAR);
    	monthsDiff = now.get(Calendar.MONTH) - thisCommentTime.get(Calendar.MONTH);
    	weeksDiff = now.get(Calendar.WEEK_OF_YEAR) - thisCommentTime.get(Calendar.WEEK_OF_YEAR);
    	daysDiff = now.get(Calendar.DAY_OF_YEAR) - thisCommentTime.get(Calendar.DAY_OF_YEAR);
    	hoursDiff = now.get(Calendar.HOUR_OF_DAY) - thisCommentTime.get(Calendar.HOUR_OF_DAY);
    	minutesDiff = now.get(Calendar.MINUTE) - thisCommentTime.get(Calendar.MINUTE);
    	secondsDiff = now.get(Calendar.SECOND) - thisCommentTime.get(Calendar.SECOND);
    	
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
    
    private void setMessageAndColorizeTags(String msg, CommentHolder commentHolder) 
    {
    	String tagColor = "#33B5E5";
    	String message = msg;
    	
    	String[] wordArray = message.split(" ");
    	//check for tags, colorize them
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		if(wordArray[i].length() > 0 && wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1 && !MainActivity.containsSymbols(wordArray[i].substring(1, wordArray[i].length())))
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
    	
    	commentHolder.messageText.setText(Html.fromHtml(message));
		
	}
        
    static class CommentHolder
    {
    	TextView scoreText;
    	TextView messageText;
    	TextView timeText;
    	TextView commentsText;
    	ImageView arrowUp;
    	ImageView arrowDown;
    	View bottomPadding;
    }
}
