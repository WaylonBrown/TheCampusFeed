package com.appuccino.collegefeed;

import java.util.ArrayList;

import com.appuccino.collegefeed.listadapters.CommentListAdapter;
import com.appuccino.collegefeed.listadapters.PostListAdapter;
import com.appuccino.collegefeed.objects.Post;
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
		
		setContentView(R.layout.tag_activity_layout);		
		
		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_tag_layout);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
				
		String tagText = getIntent().getStringExtra("TAG_ID");
		
		Typeface light = Typeface.createFromAsset(getAssets(), "fonts/Roboto-Light.ttf");
        Typeface lightItalic = Typeface.createFromAsset(getAssets(), "fonts/Roboto-LightItalic.ttf");
        Typeface bold = Typeface.createFromAsset(getAssets(), "fonts/mplus-2c-bold.ttf");
        Typeface medium = Typeface.createFromAsset(getAssets(), "fonts/Roboto-Medium.ttf");
        
        TextView topTagText = (TextView)findViewById(R.id.topTagText);
        TextView tagSearchText = (TextView)findViewById(R.id.tagSearchText);
        topTagText.setText("Posts with " + tagText);
        topTagText.setTypeface(light);
        tagSearchText.setTypeface(light);
		
		ListView listView = (ListView)findViewById(R.id.fragmentListView);
		if(!tagText.equals("") && tagText != null)
		{			
			ArrayList<Post> postList = new ArrayList<Post>();
			postList.add(new Post("Post with tag 1"));
			postList.add(new Post("Post with tag 2"));
			postList.add(new Post("Post with tag 3"));
			postList.add(new Post("Post with tag 4"));
			postList.add(new Post("Post with tag 5"));
			postList.add(new Post("Post with tag 6"));
			postList.add(new Post("Post with tag 7"));
			postList.add(new Post("Post with tag 8"));
			listAdapter = new PostListAdapter(this, R.layout.list_row_card, postList, 0);
			
			//if doesnt havefooter, add it
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
