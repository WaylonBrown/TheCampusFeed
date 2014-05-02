package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.PostCommentsActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.listadapters.PostListAdapter;
import com.appuccino.collegefeed.objects.Post;

public class NewPostFragment extends Fragment
{
	static MainActivity mainActivity;
	public static final String ARG_SECTION_NUMBER = "section_number";
	public static ArrayList<Post> postList;
	static PostListAdapter listAdapter;
	final static int sectionNumber = 1;

	public NewPostFragment()
	{
	}
	
	public NewPostFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
					
		//if doesnt have header and footer, add them
		if(fragList.getHeaderViewsCount() == 0)
		{
			//for card UI
			View headerFooter = new View(getActivity());
			headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			fragList.addFooterView(headerFooter, null, false);
			fragList.addHeaderView(headerFooter, null, false);
		}
		
		if(postList == null)
		{
			postList = new ArrayList<Post>();
			postList.add(new Post(100, "New message 1 test message 1 test message 1 test message 1 test message 1 #testtag", 5));
			postList.add(new Post(70, "New message 2 test message 2 test message #onetag #twotag", 10));
			postList.add(new Post(15, "New message 3 test message 3 #whoa test message 3 #lol test message 3 test message 3", 1));
		}		
		listAdapter = new PostListAdapter(getActivity(), R.layout.list_row_card, postList, 1);
		fragList.setAdapter(listAdapter);
		
		

	    fragList.setOnItemClickListener(new OnItemClickListener(){

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int position, long arg3) 
			{
				postClicked(postList.get(position - 1));
			}
			
		});
	    
		return rootView;
	}

	protected void postClicked(Post post) 
	{
		Intent intent = new Intent(getActivity(), PostCommentsActivity.class);
		intent.putExtra("POST_ID", post.getID());
		intent.putExtra("SECTION_NUMBER", sectionNumber);
		
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
			listAdapter.notifyDataSetChanged();
		}
		
		if(listAdapter != null)
		{
			listAdapter.notifyDataSetChanged();
		}
		
	}
}
