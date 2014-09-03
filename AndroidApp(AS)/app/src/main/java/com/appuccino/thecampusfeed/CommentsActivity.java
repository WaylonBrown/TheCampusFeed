package com.appuccino.thecampusfeed;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
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

import com.appuccino.thecampusfeed.adapters.CommentListAdapter;
import com.appuccino.thecampusfeed.dialogs.FlagDialog;
import com.appuccino.thecampusfeed.dialogs.NewCommentDialog;
import com.appuccino.thecampusfeed.extra.CustomTextView;
import com.appuccino.thecampusfeed.fragments.MyCommentsFragment;
import com.appuccino.thecampusfeed.fragments.MyPostsFragment;
import com.appuccino.thecampusfeed.fragments.NewPostFragment;
import com.appuccino.thecampusfeed.fragments.TopPostFragment;
import com.appuccino.thecampusfeed.objects.Comment;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.objects.Vote;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.NetWorker;
import com.appuccino.thecampusfeed.utils.NetWorker.GetCommentsTask;
import com.appuccino.thecampusfeed.utils.NetWorker.PostSelector;
import com.appuccino.thecampusfeed.utils.TimeManager;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class CommentsActivity extends Activity{

	static CommentListAdapter listAdapter;
	ProgressBar loadingSpinner;
	static Post post;
	static ImageView newCommentButton;
    static ImageView flagButton;
    static ImageView shareButton;
    static ImageView backButton;
    static ImageView facebookButton;
    static ImageView twitterButton;
    static View divider;
	static ProgressBar actionBarLoadingIcon;
	static CustomTextView commentsText;
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
		getViews();

		final TextView scoreText = (TextView)findViewById(R.id.scoreText);
		TextView messageText = (TextView)findViewById(R.id.messageText);
		TextView timeText = (TextView)findViewById(R.id.timeText);
		commentsText = (CustomTextView)findViewById(R.id.commentsText);
		
		int collegeID = getIntent().getIntExtra("COLLEGE_ID", 0);
        int sectionNumber = getIntent().getIntExtra("SECTION_NUMBER", 0);
        int postIndex = getIntent().getIntExtra("POST_INDEX", 0);

        Log.i("cfeed", "Section number: " + sectionNumber + " (Optional)Post Index: " + postIndex);

        switch(sectionNumber){
            case 0:
                post = TopPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1));
                break;
            case 1:
                post = NewPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1));
                break;
            case 2:
                post = MyPostsFragment.postList.get(postIndex);
                break;
            case 3:
                post = MyCommentsFragment.parentPostList.get(postIndex);
                break;
            default:
                post = TagListActivity.postList.get(postIndex);
        }
		
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
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getDeltaScore()));
            if(scoreText.getText().toString().length() > 3){
                scoreText.setTextSize(14f);
            }
			try {
				setTime(post.getTime(), timeText);
			} catch (ParseException e) {
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
                        post.deltaScore += 2;
						scoreText.setText(String.valueOf(post.getDeltaScore()));
                        updateArrows(arrowUp, arrowDown, 1);
                        new NetWorker.MakePostVoteDeleteTask(CommentsActivity.this).execute(MainActivity.voteObjectFromPostID(post.getID()));
                        new NetWorker.MakePostVoteTask(CommentsActivity.this).execute(new Vote(0, post.getID(), true));
					}
					else if(post.getVote() == 0)
					{
						post.setVote(1);
						post.score++;
                        post.deltaScore++;
						scoreText.setText(String.valueOf(post.getDeltaScore()));
                        updateArrows(arrowUp, arrowDown, 1);
                        new NetWorker.MakePostVoteTask(CommentsActivity.this).execute(new Vote(0, post.getID(), true));
					}
					else 
					{
						post.setVote(0);
						post.score--;
                        post.deltaScore--;
						scoreText.setText(String.valueOf(post.getDeltaScore()));
                        updateArrows(arrowUp, arrowDown, 0);
                        new NetWorker.MakePostVoteDeleteTask(CommentsActivity.this).execute(MainActivity.voteObjectFromPostID(post.getID()));
					}
                    if(MainActivity.topPostFrag != null){
                        MainActivity.topPostFrag.updateList();
                    }
                    if(MainActivity.newPostFrag != null){
                        MainActivity.newPostFrag.updateList();
                    }
                    TagListActivity.updateList();
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
                            post.deltaScore++;
							scoreText.setText(String.valueOf(post.getDeltaScore()));
                            updateArrows(arrowUp, arrowDown, 0);
                            new NetWorker.MakePostVoteDeleteTask(CommentsActivity.this).execute(MainActivity.voteObjectFromPostID(post.getID()));
						}
						else if(post.getVote() == 0)
						{
							post.setVote(-1);
							post.score--;
                            post.deltaScore--;
							scoreText.setText(String.valueOf(post.getDeltaScore()));
                            updateArrows(arrowUp, arrowDown, -1);
                            new NetWorker.MakePostVoteTask(CommentsActivity.this).execute(new Vote(0, post.getID(), false));
						}
						else 
						{
							post.setVote(-1);
							post.score -= 2;
                            post.deltaScore -= 2;
                            scoreText.setText(String.valueOf(post.getDeltaScore()));
                            updateArrows(arrowUp, arrowDown, -1);
                            new NetWorker.MakePostVoteDeleteTask(CommentsActivity.this).execute(MainActivity.voteObjectFromPostID(post.getID()));
                            new NetWorker.MakePostVoteTask(CommentsActivity.this).execute(new Vote(0, post.getID(), false));
						}
                        if(MainActivity.topPostFrag != null){
                            MainActivity.topPostFrag.updateList();
                        }
                        if(MainActivity.newPostFrag != null){
                            MainActivity.newPostFrag.updateList();
                        }
                        TagListActivity.updateList();
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
                        if(haventCommentedInXMinutes()){
                            LayoutInflater inflater = getLayoutInflater();
                            View commentDialogLayout = inflater.inflate(R.layout.dialog_comment, null);
                            new NewCommentDialog(CommentsActivity.this, commentDialogLayout, post);
                        } else {
                            Toast.makeText(CommentsActivity.this, "Sorry, you can only comment once every minute.", Toast.LENGTH_LONG).show();
                        }
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

            shareButton.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    shareClicked();
                }
            });

            facebookButton.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    initShareIntent("com.facebook.katana");
                }
            });

            twitterButton.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    initShareIntent("com.twitter.android");
                }
            });

            post.setVote(MainActivity.getVoteByPostId(post.getID()));
	        updateArrows(arrowUp, arrowDown, post.getVote());
		}

        backButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });

        setActionBarDividerVisibility();
	}

    private boolean haventCommentedInXMinutes(){
        Calendar now = Calendar.getInstance();
        now.add(Calendar.MINUTE, -MainActivity.TIME_BETWEEN_COMMENTS);
        if(MainActivity.lastCommentTime != null && now.before(MainActivity.lastCommentTime)){
            return false;
        }
        return true;
    }

    private static void setActionBarDividerVisibility() {
        if(flagButton != null && newCommentButton != null &&
                (flagButton.getVisibility() == View.VISIBLE || newCommentButton.getVisibility() == View.VISIBLE)){
            divider.setVisibility(View.VISIBLE);
        } else {
            divider.setVisibility(View.GONE);
        }
    }

    private void getViews() {
        newCommentButton = (ImageView)findViewById(R.id.newCommentButton);
        flagButton = (ImageView)findViewById(R.id.flagButton);
        shareButton = (ImageView)findViewById(R.id.shareButton);
        backButton = (ImageView)findViewById(R.id.backButton);
        facebookButton = (ImageView)findViewById(R.id.facebookButton);
        twitterButton = (ImageView)findViewById(R.id.twitterButton);
        actionBarLoadingIcon = (ProgressBar)findViewById(R.id.commentActionbarLoadingIcon);
        //set progressbar as white
        //actionBarLoadingIcon.getIndeterminateDrawable().setColorFilter(new LightingColorFilter(getResources().getColor(R.color.white), getResources().getColor(R.color.white)));
        divider = (View)findViewById(R.id.actionBarDivider);
        list = (ListView)findViewById(R.id.commentsList);
        loadingSpinner = (ProgressBar)findViewById(R.id.commentsLoading);
    }

    private void shareClicked() {
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, "Check out this post on TheCampusFeed\n\n" + post.getWebURL());
        sendIntent.setType("text/plain");
        startActivity(Intent.createChooser(sendIntent, getResources().getText(R.string.sendTo)));
    }

    private void initShareIntent(String type) {
        boolean found = false;
        Intent share = new Intent(android.content.Intent.ACTION_SEND);
        share.setAction(Intent.ACTION_SEND);
        share.putExtra(Intent.EXTRA_TEXT, post.getWebURL());
        share.setType("text/plain");

        // gets the list of intents that can be loaded.
        List<ResolveInfo> resInfo = getPackageManager().queryIntentActivities(share, 0);
        if (!resInfo.isEmpty()){
            for (ResolveInfo info : resInfo) {
                if (info.activityInfo.packageName.toLowerCase().contains(type) ||
                        info.activityInfo.name.toLowerCase().contains(type) ) {
                    share.setPackage(info.activityInfo.packageName);
                    found = true;
                    break;
                }
            }
            if (!found){
                String toastMessage = "";
                if(type.equals("com.facebook.katana")){
                    toastMessage = "You need to have the Facebook app installed to share on Facebook.";
                } else if (type.equals("com.twitter.android")) {
                    toastMessage = "You need to have the Twitter app installed to tweet this post.";
                }
                Toast.makeText(this, toastMessage, Toast.LENGTH_LONG).show();
                return;
            }

            startActivity(Intent.createChooser(share, "Select"));
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
        actionBar.setDisplayShowHomeEnabled(false);
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

	protected void updateArrows(ImageView arrowUp, ImageView arrowDown, int vote)
	{
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
    			if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1 && !MainActivity.containsSymbols(wordArray[i].substring(1, wordArray[i].length())))
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
        if(loadingSpinner != null){
            if(makeLoading)
            {
                list.setVisibility(View.INVISIBLE);
                loadingSpinner.setVisibility(View.VISIBLE);
            }
            else
            {
                list.setVisibility(View.VISIBLE);
                loadingSpinner.setVisibility(View.INVISIBLE);
            }
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
            if(!MainActivity.flagList.contains(post.getID())){
                flagButton.setVisibility(View.VISIBLE);
            }
            setActionBarDividerVisibility();
		}
		hasPermissions = true;	//necessary that way if permissions updated while not on MainActivity, still allow to comment
	}
	
	public static void removeFlagButtonAndLoadingIndicator(){
		if(flagButton != null){
			flagButton.setVisibility(View.GONE);
			actionBarLoadingIcon.setVisibility(View.GONE);
		}
        setActionBarDividerVisibility();
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
        setActionBarDividerVisibility();
	}
}
