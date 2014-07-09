package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.adapters.CommentListAdapter;
import com.appuccino.collegefeed.dialogs.FlagDialog;
import com.appuccino.collegefeed.dialogs.NewCommentDialog;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.GetCommentsTask;
import com.appuccino.collegefeed.utils.NetWorker.MakeVoteTask;
import com.appuccino.collegefeed.utils.NetWorker.PostSelector;
import com.appuccino.collegefeed.utils.PrefManager;
import com.appuccino.collegefeed.utils.TimeManager;
import com.romainpiel.shimmer.Shimmer;
import com.romainpiel.shimmer.ShimmerTextView;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CommentsActivity extends Activity{

	static CommentListAdapter listAdapter;
	ShimmerTextView loadingText;
	Shimmer shimmer;
	static Post post;
	static ImageView newCommentButton;
	static ImageView flagButton;
	static ProgressBar actionBarLoadingIcon;
	static TextView commentsText;
	final int minCommentLength = 3;
	ListView list;
	public static List<Comment> commentList;
	static boolean hasPermissions = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_ACTION_BAR);
		setContentView(R.layout.activity_comment);
		setupActionBar();
		
		newCommentButton = (ImageView)findViewById(R.id.newCommentButton);
		flagButton = (ImageView)findViewById(R.id.flagButton);
		actionBarLoadingIcon = (ProgressBar)findViewById(R.id.commentActionbarLoadingIcon);
		list = (ListView)findViewById(R.id.commentsList);
		loadingText = (ShimmerTextView)findViewById(R.id.commentsLoadingText);
		final TextView scoreText = (TextView)findViewById(R.id.scoreText);
		TextView messageText = (TextView)findViewById(R.id.messageText);
		TextView timeText = (TextView)findViewById(R.id.timeText);
		commentsText = (TextView)findViewById(R.id.commentsText);
		
		int collegeID = getIntent().getIntExtra("COLLEGE_ID", 0);
		int sectionNumber = getIntent().getIntExtra("SECTION_NUMBER", 0);

        Log.i("cfeed", "Section number: " + sectionNumber);

		if(sectionNumber == 0)
			post = TopPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1));
		else
			post = NewPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1));
		
		Log.i("cfeed", "Post: " + post + " list: " + MainActivity.flagList + " post id: "
                + getIntent().getIntExtra("POST_ID", -1));
		if(MainActivity.hasPermissions(collegeID) && post != null){
			newCommentButton.setVisibility(View.VISIBLE);
			if(!MainActivity.flagList.contains(post.getID())){	//dont show flag button if already flagged
				flagButton.setVisibility(View.VISIBLE);
			}
		}else{
			newCommentButton.setVisibility(View.GONE);
			flagButton.setVisibility(View.GONE);
		}
		
		Log.i("cfeed", "Clicked from section number " + sectionNumber);
		
        //set fonts		
		scoreText.setTypeface(FontManager.bold);
		messageText.setTypeface(FontManager.light);
		timeText.setTypeface(FontManager.medium);
		commentsText.setTypeface(FontManager.light);
		loadingText.setTypeface(FontManager.light);
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getScore()));
			try {
				setTime(post.getTime(), timeText);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			pullListFromServer();
			listAdapter = new CommentListAdapter(this, R.layout.list_row_collegepost, commentList, post);
			if(list != null && commentList != null)
				list.setAdapter(listAdapter);	
			else
				Log.e("cfeed", "TopPostFragment list adapter wasn't set.");
			
			//change text if no comments from post
			if(commentList.size() == 0)
				commentsText.setText("No Comments");
			
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
						MainActivity.postDownvoteList.remove(Integer.valueOf(post.getID()));
						MainActivity.postUpvoteList.add(post.getID());
						PrefManager.putPostDownvoteList(MainActivity.postDownvoteList);
						PrefManager.putPostUpvoteList(MainActivity.postUpvoteList);
					}
					else if(post.getVote() == 0)
					{
						post.setVote(1);
						post.score++;
						scoreText.setText(String.valueOf(post.score));
						MainActivity.postUpvoteList.add(post.getID());
						PrefManager.putPostUpvoteList(MainActivity.postUpvoteList);
					}
					else 
					{
						post.setVote(0);
						post.score--;
						scoreText.setText(String.valueOf(post.score));
						MainActivity.postUpvoteList.remove(Integer.valueOf(post.getID()));
						PrefManager.putPostUpvoteList(MainActivity.postUpvoteList);
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
							MainActivity.postDownvoteList.remove(Integer.valueOf(post.getID()));
							PrefManager.putPostDownvoteList(MainActivity.postDownvoteList);
						}
						else if(post.getVote() == 0)
						{
							post.setVote(-1);
							post.score--;
							scoreText.setText(String.valueOf(post.score));
							MainActivity.postDownvoteList.add(post.getID());
							PrefManager.putPostDownvoteList(MainActivity.postDownvoteList);
						}
						else 
						{
							post.setVote(-1);
							post.score -= 2;
							scoreText.setText(String.valueOf(post.score));
							MainActivity.postUpvoteList.remove(Integer.valueOf(post.getID()));
							MainActivity.postDownvoteList.add(post.getID());
							PrefManager.putPostDownvoteList(MainActivity.postDownvoteList);
							PrefManager.putPostUpvoteList(MainActivity.postUpvoteList);
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
	        
	        newCommentButton.setOnClickListener(new OnClickListener(){
				@Override
				public void onClick(View v) 
				{					
					if(MainActivity.hasPermissions(post.getCollegeID()) || hasPermissions)
					{
						LayoutInflater inflater = getLayoutInflater();
						View commentDialogLayout = inflater.inflate(R.layout.dialog_comment, null);
						new NewCommentDialog(CommentsActivity.this, commentDialogLayout, post);
					}
				}        	
	        });
	        
	        flagButton.setOnClickListener(new OnClickListener(){
				@Override
				public void onClick(View v) 
				{					
					if(MainActivity.hasPermissions(post.getCollegeID()) || hasPermissions){
						new FlagDialog(CommentsActivity.this, post);
					}
				}        	
	        });
	        
	        updateArrows(arrowUp, arrowDown);
		}
	}
	
	private void setupActionBar() {
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_comment);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
	}

	private void pullListFromServer() {
		commentList = new ArrayList<Comment>();
		ConnectivityManager cm = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);		
		if(cm.getActiveNetworkInfo() != null)
			new GetCommentsTask(this, post.getID()).execute(new PostSelector());
		else
			Toast.makeText(this, "You have no internet connection. Pull down to refresh and try again.", Toast.LENGTH_LONG).show();
		
		
		//if doesnt havefooter, add it
		if(list.getFooterViewsCount() == 0)
		{
			//for card UI
			View headerFooter = new View(this);
			headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addFooterView(headerFooter, null, false);
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
	
	public void makeLoadingIndicator(boolean makeLoading) 
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
			
			//TODO: for PTR
//			if(pullToRefresh != null)
//			{
//				// Notify PullToRefreshLayout that the refresh has finished
//	            pullToRefresh.setRefreshComplete();
//			}
		}
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
	}

	public static void updateList() {
		if(listAdapter != null){
			listAdapter.clear();
			listAdapter.addAll(commentList);
			listAdapter.notifyDataSetChanged();	
		}
		
		//change text if no comments from post
		if(commentList.size() == 0)
			commentsText.setText("No Comments");
		else
			commentsText.setText("Comments");
				
	}

	public static void setNewPermissionsIfAvailable() {
		if(newCommentButton != null && post != null && MainActivity.hasPermissions(post.getCollegeID())){
			newCommentButton.setVisibility(View.VISIBLE);
		}
		hasPermissions = true;	//necessary that way if permissions updated while not on MainActivity, still allow to comment
	}
	
	public static void removeFlagButtonAndLoadingIndicator(){
		if(flagButton != null){
			flagButton.setVisibility(View.GONE);
			actionBarLoadingIcon.setVisibility(View.GONE);
		}
	}

	public static void addActionBarLoadingIndicatorAndRemoveFlag() {
		if(flagButton != null && actionBarLoadingIcon != null){
			flagButton.setVisibility(View.GONE);
			actionBarLoadingIcon.setVisibility(View.VISIBLE);
		}
	}
	
	public static void removeActionBarLoadingIndicatorAndAddFlag(){
		if(flagButton != null && actionBarLoadingIcon != null){
			flagButton.setVisibility(View.VISIBLE);
			actionBarLoadingIcon.setVisibility(View.GONE);
		}
	}
}
