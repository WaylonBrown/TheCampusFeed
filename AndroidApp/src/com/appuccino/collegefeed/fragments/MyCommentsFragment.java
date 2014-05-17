package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

import uk.co.senab.actionbarpulltorefresh.library.ActionBarPullToRefresh;
import uk.co.senab.actionbarpulltorefresh.library.PullToRefreshLayout;
import uk.co.senab.actionbarpulltorefresh.library.listeners.OnRefreshListener;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.PostCommentsActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.extra.NetWorker.GetPostsTask;
import com.appuccino.collegefeed.extra.NetWorker.PostSelector;
import com.appuccino.collegefeed.listadapters.CommentListAdapter;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.romainpiel.shimmer.Shimmer;
import com.romainpiel.shimmer.ShimmerTextView;

public class MyCommentsFragment extends Fragment implements OnRefreshListener
{
	static MainActivity mainActivity;
	public static final String ARG_TAB_NUMBER = "section_number";
	public static final String ARG_SPINNER_NUMBER = "tab_number";
	public static ArrayList<Comment> commentList;
	static CommentListAdapter listAdapter;
	final int tabNumber = 2;
	int spinnerNumber = 0;
	static ListView list;
	//library objects
	static ShimmerTextView loadingText;
	static Shimmer shimmer;
	private static PullToRefreshLayout pullToRefresh;

	public MyCommentsFragment()
	{
	}
	
	public MyCommentsFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		list = (ListView)rootView.findViewById(R.id.fragmentListView);
		loadingText = (ShimmerTextView)rootView.findViewById(R.id.loadingText);
		
		Typeface customfont = Typeface.createFromAsset(mainActivity.getAssets(), "fonts/Roboto-Light.ttf");
		loadingText.setTypeface(customfont);
					
		// Now give the find the PullToRefreshLayout and set it up
        pullToRefresh = (PullToRefreshLayout) rootView.findViewById(R.id.pullToRefresh);
        ActionBarPullToRefresh.from(getActivity())
                .allChildrenArePullable()
                .listener(this)
                .setup(pullToRefresh);
		
		//if doesnt have header and footer, add them
		if(list.getHeaderViewsCount() == 0)
		{
			//for card UI
			View headerFooter = new View(getActivity());
			headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addFooterView(headerFooter, null, false);
			list.addHeaderView(headerFooter, null, false);
		}
		
		if(commentList == null)
		{
			pullListFromServer();
			//postList.add()
			/*postList.add(new Post(100, "Top message 1 test message 1 test message 1 test message 1 test message 1 #testtag", 5));
			postList.add(new Post(70, "Top message 2 test message 2 test message #onetag #twotag", 10));
			postList.add(new Post(15, "Top message 3 test message 3 #whoa test message 3 #lol test message 3 test message 3", 1));*/
		}		
		
		listAdapter = new CommentListAdapter(getActivity(), R.layout.list_row_post, commentList);
		list.setAdapter(listAdapter);
		
		

		list.setOnItemClickListener(new OnItemClickListener()
	    {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int position, long arg3) 
			{
				commentClicked(commentList.get(position - 1));
			}			
		});
	    
		return rootView;
	}

	private void pullListFromServer() 
	{
		commentList = new ArrayList<Comment>();
		ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
		if(cm.getActiveNetworkInfo() != null)
			new GetPostsTask(3).execute(new PostSelector());
		else
			Toast.makeText(getActivity(), "You have no internet connection. Pull down to refresh and try again.", Toast.LENGTH_LONG).show();
	}
	
	protected void commentClicked(Comment comment) 
	{
		Intent intent = new Intent(getActivity(), PostCommentsActivity.class);
		intent.putExtra("POST_ID", comment.getParentID());
		intent.putExtra("SECTION_NUMBER", tabNumber);

		startActivity(intent);
		getActivity().overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
	}
	
	//TODO: implement
	public static Post getPostByID(int id, int sectionNumber)
	{
		if(commentList != null)
		{
			for(int i = 0; i < commentList.size(); i++)
			{
				if(commentList.get(i).getParentID() == id)
				{
					//return commentList.get(i).getParentID();
				}
			}
		}
	
		return null;
	}

	public static void updateList() 
	{
		if(listAdapter != null)
		{
			listAdapter.notifyDataSetChanged();
		}			
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
	public void onRefreshStarted(View arg0) 
	{
		pullListFromServer();
	}
}
