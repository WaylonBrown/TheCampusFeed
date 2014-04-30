package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.appuccino.collegefeed.MainActivity.NewPostFragment;
import com.appuccino.collegefeed.MainActivity.TopPostFragment;
import com.appuccino.collegefeed.listadapters.CommentListAdapter;
import com.appuccino.collegefeed.objects.NetWorker;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;
import com.appuccino.collegefeed.R;

public class PostCommentsActivity extends Activity{

	static CommentListAdapter listAdapter;
	Post post;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.comment_layout);
		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_comment_layout);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
		
		int sectionNumber = getIntent().getIntExtra("SECTION_NUMBER", 0);
		if(sectionNumber == 0)
			post = TopPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		else
			post = NewPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		
		Typeface light = Typeface.createFromAsset(getAssets(), "fonts/Roboto-Light.ttf");
        Typeface lightItalic = Typeface.createFromAsset(getAssets(), "fonts/Roboto-LightItalic.ttf");
        Typeface bold = Typeface.createFromAsset(getAssets(), "fonts/mplus-2c-bold.ttf");
        Typeface medium = Typeface.createFromAsset(getAssets(), "fonts/Roboto-Medium.ttf");
		
        //set fonts
		TextView scoreText = (TextView)findViewById(R.id.scoreText);
		TextView messageText = (TextView)findViewById(R.id.messageText);
		TextView timeText = (TextView)findViewById(R.id.timeText);
		TextView commentsText = (TextView)findViewById(R.id.commentsText);
		scoreText.setTypeface(bold);
		messageText.setTypeface(light);
		timeText.setTypeface(lightItalic);
		commentsText.setTypeface(light);
		
		ListView commentsListView = (ListView)findViewById(R.id.commentsList);
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getScore()));
			timeText.setText(String.valueOf(post.getHoursAgo()) + " hours ago");
			
			listAdapter = new CommentListAdapter(this, R.layout.list_row_card, post.getCommentList());
			
			//if doesnt havefooter, add it
			if(commentsListView.getFooterViewsCount() == 0)
			{
				//for card UI
				View headerFooter = new View(this);
				headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
				commentsListView.addFooterView(headerFooter, null, false);
			}
			commentsListView.setAdapter(listAdapter);
			
			setMessageAndColorizeTags(post.getMessage(), messageText);
			final ImageView arrowUp = (ImageView)findViewById(R.id.arrowUp);
			final ImageView arrowDown = (ImageView)findViewById(R.id.arrowDown);
	        //arrow click listeners
	        arrowUp.setOnClickListener(new OnClickListener(){

				@Override
				public void onClick(View v) {
					//if already upvoted, un-upvote
					if(post.getVote() != 1)
						post.setVote(1);
					else
						post.setVote(0);
					TopPostFragment.updateList();
					NewPostFragment.updateList();
					TagListActivity.updateList();
					updateArrows(arrowUp, arrowDown);
					new NetWorker.VoteTask().execute(new Vote(post.getID(), true));
				}        	
	        });
	        arrowDown.setOnClickListener(new OnClickListener(){

				@Override
				public void onClick(View v) {
					//if already downvoted, un-downvote
					if(post.getVote() != -1)
						post.setVote(-1);
					else
						post.setVote(0);
					TopPostFragment.updateList();
					NewPostFragment.updateList();
					TagListActivity.updateList();
					updateArrows(arrowUp, arrowDown);
				}        	
	        });
	        
	        updateArrows(arrowUp, arrowDown);
		}
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
    		if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
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
    	
    	messageText.setText(Html.fromHtml(message));
		
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
