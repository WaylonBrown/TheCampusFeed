package com.appuccino.postfeed;

import com.appuccino.postfeed.MainActivity.NewPostFragment;
import com.appuccino.postfeed.MainActivity.TopPostFragment;
import com.appuccino.postfeed.listadapters.CommentListAdapter;
import com.appuccino.postfeed.objects.Post;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.TextView;

public class PostCommentsActivity extends Activity{

	static CommentListAdapter listAdapter;
	
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
		Post post;
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
		commentsText.setTypeface(medium);
		
		ListView commentsListView = (ListView)findViewById(R.id.commentsList);
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getScore()));
			messageText.setText(post.getMessage());
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
