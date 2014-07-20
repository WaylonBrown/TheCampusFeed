package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.adapters.PostListAdapter;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.GetTagActivityTask;
import com.appuccino.collegefeed.utils.NetWorker.PostSelector;

import java.util.ArrayList;
import java.util.List;

public class TagListActivity extends Activity{
	private static PostListAdapter listAdapter;
	private ListView list;
	public static List<Post> postList = new ArrayList<Post>();
	private static String tagText = "";
    private static TextView topTagText;
    private static TextView tagFeedName;
	private static ProgressBar progressSpinner;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_tag);		
		progressSpinner = (ProgressBar)findViewById(R.id.progressSpinner);
		
		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_tag_layout);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
				
		tagText = getIntent().getStringExtra("TAG_ID");
		tagText = tagText.replace("#", "");
        
        topTagText = (TextView)findViewById(R.id.topTagText);
        tagFeedName = (TextView)findViewById(R.id.tagFeedName);
        setTopTexts();

		list = (ListView)findViewById(R.id.fragmentListView);
		if(!tagText.isEmpty() && tagText != null)
		{			
			//if doesnt have footer, add it
			if(list.getFooterViewsCount() == 0)
			{
				//for card UI
				View headerFooter = new View(this);
				headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
				list.addFooterView(headerFooter, null, false);
			}
			
			ArrayList<Post> postList = new ArrayList<Post>();
			pullListFromServer();
			listAdapter = new PostListAdapter(this, R.layout.list_row_collegepost, postList, 0, MainActivity.currentFeedCollegeID);
			if(list != null)
				list.setAdapter(listAdapter);	
			else
				Log.e("cfeed", "TopPostFragment list adapter wasn't set.");
		}
	}

    private void setTopTexts() {
        topTagText.setTypeface(FontManager.light);
        tagFeedName.setTypeface(FontManager.light);

        if(postList.size() > 0){
            topTagText.setText("Posts with #" + tagText);
        }else{
            topTagText.setText("No posts with #" + tagText);
        }

        College currentFeed = MainActivity.getCollegeByID(MainActivity.currentFeedCollegeID);
        if(tagFeedName != null && currentFeed != null){
            tagFeedName.setText("in the feed " + currentFeed.getName());
        }
    }

    private void pullListFromServer() {
		postList = new ArrayList<Post>();
		tagText = tagText.replace(" ", "");	//whitespace causes crash
		ConnectivityManager cm = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);		
		if(cm.getActiveNetworkInfo() != null)
			new GetTagActivityTask(this, MainActivity.currentFeedCollegeID, tagText).execute(new PostSelector());
		else
			Toast.makeText(this, "You have no internet connection.", Toast.LENGTH_LONG).show();
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
	}

	public static void updateList() {
		if(listAdapter != null){
			listAdapter.clear();
			listAdapter.addAll(postList);
			listAdapter.notifyDataSetChanged();
			
			tagText = tagText.replace("#", "");
			if(postList.size() > 0){
				topTagText.setText("Posts with #" + tagText);
			}else{
				Log.i("cfeed", "Tagstext is " + tagText);
				topTagText.setText("No posts with #" + tagText);
			}
		}
	}

	public void makeLoadingIndicator(boolean b) {
		if(b){
			progressSpinner.setVisibility(View.VISIBLE);
		}else{
			progressSpinner.setVisibility(View.GONE);
		}
	}
}
