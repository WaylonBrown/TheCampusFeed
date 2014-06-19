package com.appuccino.collegefeed;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;

import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.CommentListAdapter;
import com.appuccino.collegefeed.dialogs.NewCommentDialog;
import com.appuccino.collegefeed.dialogs.NewPostDialog;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker;
import com.appuccino.collegefeed.utils.TimeManager;
import com.appuccino.collegefeed.utils.NetWorker.MakePostTask;
import com.appuccino.collegefeed.utils.NetWorker.MakeVoteTask;
import com.romainpiel.shimmer.Shimmer;

public class CommentsActivity extends Activity{

	static CommentListAdapter listAdapter;
	Post post;
	ImageView newCommentButton;
	final int minCommentLength = 3;
	ListView list;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_comment);
		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_comment);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
		newCommentButton = (ImageView)findViewById(R.id.newCommentButton);
		list = (ListView)findViewById(R.id.commentsList);
		
		int collegeID = getIntent().getIntExtra("COLLEGE_ID", 0);
		int sectionNumber = getIntent().getIntExtra("SECTION_NUMBER", 0);
		
		if(MainActivity.hasPermissions(collegeID))
			newCommentButton.setVisibility(View.VISIBLE);
		else
			newCommentButton.setVisibility(View.GONE);
		
		if(sectionNumber == 0)
			post = TopPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		else if(sectionNumber == 1)
			post = NewPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		else if(sectionNumber == 2)
			post = MyPostsFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		
        //set fonts
		final TextView scoreText = (TextView)findViewById(R.id.scoreText);
		TextView messageText = (TextView)findViewById(R.id.messageText);
		TextView timeText = (TextView)findViewById(R.id.timeText);
		TextView commentsText = (TextView)findViewById(R.id.commentsText);
		scoreText.setTypeface(FontManager.bold);
		messageText.setTypeface(FontManager.light);
		timeText.setTypeface(FontManager.italic);
		commentsText.setTypeface(FontManager.light);
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getScore()));
			try {
				setTime(post.getTime(), timeText);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			//change text if no comments from post
			if(post.getCommentList().size() == 0)
				commentsText.setText("No Comments");
				
			listAdapter = new CommentListAdapter(this, R.layout.list_row_post, post.getCommentList());
			
			//if doesnt havefooter, add it
			if(list.getFooterViewsCount() == 0)
			{
				//for card UI
				View headerFooter = new View(this);
				headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
				list.addFooterView(headerFooter, null, false);
			}
			list.setAdapter(listAdapter);
			
			setMessageAndColorizeTags(post.getMessage(), messageText);
			final ImageView arrowUp = (ImageView)findViewById(R.id.arrowUp);
			final ImageView arrowDown = (ImageView)findViewById(R.id.arrowDown);
	        //arrow click listeners
	        arrowUp.setOnClickListener(new OnClickListener(){

				@Override
				public void onClick(View v) {
					//if already upvoted, un-upvote
					if(post.getVote() == -1)
					{
						post.setVote(1);
						post.score += 2;
						scoreText.setText(String.valueOf(post.score));
					}
					else if(post.getVote() == 0)
					{
						post.setVote(1);
						post.score++;
						scoreText.setText(String.valueOf(post.score));
					}
					else 
					{
						post.setVote(0);
						post.score--;
						scoreText.setText(String.valueOf(post.score));
					}
					TopPostFragment.updateList();
					NewPostFragment.updateList();
					TagListActivity.updateList();
					updateArrows(arrowUp, arrowDown);
					new MakeVoteTask().execute(new Vote(post.getID(), true));
				}        	
	        });
	        arrowDown.setOnClickListener(new OnClickListener(){

				@Override
				public void onClick(View v) 
				{					
					if(MainActivity.hasPermissions(post.getCollegeID()))
					{
						//if already downvoted, un-downvote
						if(post.getVote() == -1)
						{
							post.setVote(0);
							post.score++;
							scoreText.setText(String.valueOf(post.score));
						}
						else if(post.getVote() == 0)
						{
							post.setVote(-1);
							post.score--;
							scoreText.setText(String.valueOf(post.score));
						}
						else 
						{
							post.setVote(-1);
							post.score -= 2;
							scoreText.setText(String.valueOf(post.score));
						}
						TopPostFragment.updateList();
						NewPostFragment.updateList();
						TagListActivity.updateList();
						updateArrows(arrowUp, arrowDown);
					}
					else
					{
						Toast.makeText(getApplicationContext(), "You need to be near the college to downvote", Toast.LENGTH_LONG).show();
					}
				}        	
	        });
	        
	        //I know it's redundent to check permissions this many times, but no one fcking post to the wrong college!
	        if(MainActivity.hasPermissions(collegeID))
				newCommentButton.setOnClickListener(new OnClickListener(){

					@Override
					public void onClick(View v) 
					{					
						if(MainActivity.hasPermissions(post.getCollegeID()))
						{
							LayoutInflater inflater = getLayoutInflater();
							View commentDialogLayout = inflater.inflate(R.layout.dialog_comment, null);
							new NewCommentDialog(CommentsActivity.this, commentDialogLayout, post);
						}
					}        	
		        });
	        
	        updateArrows(arrowUp, arrowDown);
		}
	}
	
	private void setTime(String time, TextView timeText) throws ParseException {
    	Calendar thisPostTime = TimeManager.toCalendar(time);
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

	protected void updateArrows(ImageView arrowUp, ImageView arrowDown) 
	{
		int vote = post.getVote();
        if(vote == -1)
        {
        	arrowDown.setImageDrawable(getResources().getDrawable(R.drawable.arrowdownred));
        	arrowUp.setImageDrawable(getResources().getDrawable(R.drawable.arrowup));
        }
        else if (vote == 1)
        {
        	arrowUp.setImageDrawable(getResources().getDrawable(R.drawable.arrowupblue));
        	arrowDown.setImageDrawable(getResources().getDrawable(R.drawable.arrowdown));
        }
        else	//no votes
        {
        	arrowUp.setImageDrawable(getResources().getDrawable(R.drawable.arrowup));
        	arrowDown.setImageDrawable(getResources().getDrawable(R.drawable.arrowdown));
        }
	}

	void setMessageAndColorizeTags(String msg, TextView messageText) 
    {
    	String tagColor = "#33B5E5";
    	String message = msg;
    	
    	String[] wordArray = message.split(" ");
    	//check for tags, colorize them
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		if(wordArray[i].length() > 0)	//in case empty, doesn't throw nullpointer
    		{
    			if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
        		{
        			wordArray[i] = "<font color='" + tagColor + "'>" + wordArray[i] + "</font>";
        		}
    		}    		
    	}
    	
    	message = "";
    	//combine back to string
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		message += wordArray[i] + " ";
    	}
    	
    	messageText.setText(Html.fromHtml(message));
		
	}
	
	public static void makeLoadingIndicator(boolean makeLoading) 
	{
		if(makeLoading)
		{
			list.setVisibility(View.INVISIBLE);
			loadingText.setVisibility(View.VISIBLE);
			
			shimmer = new Shimmer();
			shimmer.setDuration(600);
			shimmer.start(loadingText);
		}
		else
		{
			list.setVisibility(View.VISIBLE);
			loadingText.setVisibility(View.INVISIBLE);
			
			if (shimmer != null && shimmer.isAnimating()) 
	            shimmer.cancel();
			
			if(pullToRefresh != null)
			{
				// Notify PullToRefreshLayout that the refresh has finished
	            pullToRefresh.setRefreshComplete();
			}
		}
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
	}

	public static void updateList() {
		if(listAdapter != null)
			listAdapter.notifyDataSetChanged();		
	}

}
