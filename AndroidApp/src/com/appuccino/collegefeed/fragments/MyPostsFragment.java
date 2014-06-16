package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

import uk.co.senab.actionbarpulltorefresh.library.ActionBarPullToRefresh;
import uk.co.senab.actionbarpulltorefresh.library.PullToRefreshLayout;
import uk.co.senab.actionbarpulltorefresh.library.listeners.OnRefreshListener;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.PostCommentsActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.PostListAdapter;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.GetPostsTask;
import com.appuccino.collegefeed.utils.NetWorker.PostSelector;
import com.romainpiel.shimmer.Shimmer;
import com.romainpiel.shimmer.ShimmerTextView;

public class MyPostsFragment extends Fragment implements OnRefreshListener
{
	static MainActivity mainActivity;
	public static final String ARG_TAB_NUMBER = "section_number";
	public static final String ARG_SPINNER_NUMBER = "tab_number";
	public static ArrayList<Post> postList;
	static PostListAdapter listAdapter;
	static ListView list;
	//library objects
	static ShimmerTextView loadingText;
	static Shimmer shimmer;
	private static PullToRefreshLayout pullToRefresh;
	View rootView;

	public MyPostsFragment()
	{
	}
	
	public MyPostsFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		list = (ListView)rootView.findViewById(R.id.fragmentListView);
		loadingText = (ShimmerTextView)rootView.findViewById(R.id.loadingText);
		loadingText.setTypeface(FontManager.light);
		
		disableFooter(rootView);
					
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
		
		if(postList == null && mainActivity != null)
		{
			pullListFromServer();
		}		
		listAdapter = new PostListAdapter(getActivity(), R.layout.list_row_post, postList, 2);
		list.setAdapter(listAdapter);
		
		

		list.setOnItemClickListener(new OnItemClickListener()
	    {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int position, long arg3) 
			{
				postClicked(postList.get(position - 1));
			}			
		});
	    
		return rootView;
	}
	
	private void disableFooter(View root) {
		LinearLayout footer = (LinearLayout)root.findViewById(R.id.footer);
		footer.setVisibility(View.GONE);
	}

	private void pullListFromServer() 
	{
		postList = new ArrayList<Post>();
		ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
		if(cm.getActiveNetworkInfo() != null)
			new GetPostsTask(2, 0).execute(new PostSelector());
		else
			Toast.makeText(getActivity(), "You have no internet connection. Pull down to refresh and try again.", Toast.LENGTH_LONG).show();
	}

	protected void postClicked(Post post) 
	{
		Intent intent = new Intent(getActivity(), PostCommentsActivity.class);
		intent.putExtra("COLLEGE_ID", post.getCollegeID());
		intent.putExtra("POST_ID", post.getID());
		
		startActivity(intent);
		getActivity().overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
	}
	
	public static Post getPostByID(int id, int sectionNumber)
	{
		if(postList != null)
		{
			for(int i = 0; i < postList.size(); i++)
			{
				if(postList.get(i).getID() == id)
				{
					return postList.get(i);
				}
			}
		}
	
		return null;
	}

	public static void updateList() 
	{
		if(listAdapter != null)
		{
			listAdapter.clear();
			listAdapter.addAll(postList);
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
