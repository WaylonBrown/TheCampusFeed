package com.appuccino.postfeed;

import com.appuccino.postfeed.MainActivity.SectionFragment;
import com.appuccino.postfeed.listadapters.CommentListAdapter;
import com.appuccino.postfeed.objects.Post;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.TextView;

public class PostCommentsActivity extends Activity{

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.comment_layout);
		Post post = SectionFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1));
		
		TextView scoreText = (TextView)findViewById(R.id.scoreText);
		TextView messageText = (TextView)findViewById(R.id.messageText);
		TextView timeText = (TextView)findViewById(R.id.timeText);
		ListView commentsListView = (ListView)findViewById(R.id.commentsList);
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getScore()));
			messageText.setText(post.getMessage());
			timeText.setText(String.valueOf(post.getHoursAgo()) + " hours ago");
			
			CommentListAdapter listAdapter = new CommentListAdapter(this, R.layout.list_row_card, post.getCommentList());
			
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
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

}
