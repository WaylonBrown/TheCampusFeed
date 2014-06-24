package com.appuccino.collegefeed;

import java.util.ArrayList;

import com.appuccino.collegefeed.adapters.CommentListAdapter;
import com.appuccino.collegefeed.adapters.PostListAdapter;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.R;

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

public class TagListActivity extends Activity{
	static PostListAdapter listAdapter;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_tag);		
		
		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_tag_layout);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
				
		String tagText = getIntent().getStringExtra("TAG_ID");
        
        TextView topTagText = (TextView)findViewById(R.id.topTagText);
        topTagText.setText("Posts with " + tagText);
        topTagText.setTypeface(FontManager.light);
		
		ListView listView = (ListView)findViewById(R.id.fragmentListView);
		if(!tagText.equals("") && tagText != null)
		{			
			ArrayList<Post> postList = new ArrayList<Post>();
			postList.add(new Post(1, "Post with tag 1", 1, 1, ""));
			listAdapter = new PostListAdapter(this, R.layout.list_row_collegepost, postList, 0, MainActivity.ALL_COLLEGES);
			
			//if doesnt have footer, add it
			if(listView.getFooterViewsCount() == 0)
			{
				//for card UI
				View headerFooter = new View(this);
				headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
				listView.addFooterView(headerFooter, null, false);
			}
			listView.setAdapter(listAdapter);
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
