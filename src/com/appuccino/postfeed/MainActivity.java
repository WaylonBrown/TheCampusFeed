package com.appuccino.postfeed;

import java.util.ArrayList;
import java.util.Locale;

import com.appuccino.postfeed.listadapters.PostListAdapter;
import com.appuccino.postfeed.listadapters.TagListAdapter;
import com.appuccino.postfeed.objects.Post;
import com.appuccino.postfeed.objects.Tag;

import android.app.ActionBar;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.FragmentTransaction;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.NavUtils;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

public class MainActivity extends FragmentActivity implements
		ActionBar.TabListener {

	/**
	 * The {@link android.support.v4.view.PagerAdapter} that will provide
	 * fragments for each of the sections. We use a
	 * {@link android.support.v4.app.FragmentPagerAdapter} derivative, which
	 * will keep every loaded fragment in memory. If this becomes too memory
	 * intensive, it may be best to switch to a
	 * {@link android.support.v4.app.FragmentStatePagerAdapter}.
	 */
	SectionsPagerAdapter pagerAdapter;
	ImageView newPostButton;
	
	/**
	 * The {@link ViewPager} that will host the section contents.
	 */
	ViewPager viewPager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		actionBar.setCustomView(R.layout.actionbar_layout);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
		
		newPostButton = (ImageView)findViewById(R.id.newPostButton);
		newPostButton.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				newPostClicked();
			}
		});

		// Create the adapter that will return a fragment for each of the three
		// primary sections of the app.
		pagerAdapter = new SectionsPagerAdapter(this, 
				getSupportFragmentManager());

		// Set up the ViewPager with the sections adapter.
		viewPager = (ViewPager) findViewById(R.id.pager);
		viewPager.setAdapter(pagerAdapter);
		viewPager.setOffscreenPageLimit(3);

		// When swiping between different sections, select the corresponding
		// tab. We can also use ActionBar.Tab#select() to do this if we have
		// a reference to the Tab.
		viewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
					@Override
					public void onPageSelected(int position) {
						actionBar.setSelectedNavigationItem(position);
					}
				});

		// For each of the sections in the app, add a tab to the action bar.
		for (int i = 0; i < pagerAdapter.getCount(); i++) {
			// Create a tab with text corresponding to the page title defined by
			// the adapter. Also specify this Activity object, which implements
			// the TabListener interface, as the callback (listener) for when
			// this tab is selected.
			actionBar.addTab(actionBar.newTab()
					.setText(pagerAdapter.getPageTitle(i))
					.setTabListener(this));
		}
	}
	
	public void newPostClicked() 
	{
		LayoutInflater inflater = getLayoutInflater();
		View postDialogLayout = inflater.inflate(R.layout.new_post_layout, null);
		final EditText postMessage = (EditText)postDialogLayout.findViewById(R.id.newPostMessage);
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
    	builder.setCancelable(true);
    	builder.setView(postDialogLayout)
    	.setPositiveButton("Post", new DialogInterface.OnClickListener() {
    		public void onClick(DialogInterface dialog, int id) {
    			NewPostFragment.newPostList.add(new Post(postMessage.getText().toString()));
    			TopPostFragment.topPostList.add(new Post(postMessage.getText().toString()));
    		}
    	});
    	
    	final AlertDialog dialog = builder.create();
    	dialog.show();
    	
    	Typeface customfont = Typeface.createFromAsset(getAssets(), "fonts/Roboto-Light.ttf");
    	TextView title = (TextView)postDialogLayout.findViewById(R.id.newPostTitle);
    	postMessage.setTypeface(customfont);
    	title.setTypeface(customfont);
    	
    	//ensure keyboard is brought up when dialog shows
    	postMessage.setOnFocusChangeListener(new View.OnFocusChangeListener() {
    	    @Override
    	    public void onFocusChange(View v, boolean hasFocus) {
    	        if (hasFocus) {
    	            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    	        }
    	    }
    	});
   
//    	TextView messagetext = (TextView)dialog.findViewById(android.R.id.message);
//    	messagetext.setTypeface(customfont);		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public void onTabSelected(ActionBar.Tab tab,
			FragmentTransaction fragmentTransaction) {
		// When the given tab is selected, switch to the corresponding page in
		// the ViewPager.
		viewPager.setCurrentItem(tab.getPosition());
	}

	@Override
	public void onTabUnselected(ActionBar.Tab tab,
			FragmentTransaction fragmentTransaction) {
	}

	@Override
	public void onTabReselected(ActionBar.Tab tab,
			FragmentTransaction fragmentTransaction) {
	}

	/**
	 * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
	 * one of the sections/tabs/pages.
	 */
	public class SectionsPagerAdapter extends FragmentPagerAdapter {
		MainActivity mainActivity;
		
		public SectionsPagerAdapter(MainActivity m, FragmentManager fm) {
			super(fm);
			mainActivity = m;
		}

		@Override
		public Fragment getItem(int position) {
			// getItem is called to instantiate the fragment for the given page.
			// Return a SectionFragment (defined as a static inner class
			// below) with the page number as its lone argument.
			Fragment fragment;
			if(position == 0)
				fragment = new TopPostFragment(mainActivity);
			else if (position == 1)
				fragment = new NewPostFragment(mainActivity);
			else
				fragment = new TagFragment(mainActivity);
			
			Bundle args = new Bundle();
			args.putInt(TopPostFragment.ARG_SECTION_NUMBER, position);
			fragment.setArguments(args);
			return fragment;
		}

		@Override
		public int getCount() {
			// Show 3 total pages.
			return 3;
		}

		@Override
		public CharSequence getPageTitle(int position) {
			Locale l = Locale.getDefault();
			switch (position) {
			case 0:
				return getString(R.string.title_section1).toUpperCase(l);
			case 1:
				return getString(R.string.title_section2).toUpperCase(l);
			case 2:
				return getString(R.string.title_section3).toUpperCase(l);
			}
			return null;
		}
	}

	public static class TopPostFragment extends Fragment 
	{		
		static MainActivity mainActivity;
		public static final String ARG_SECTION_NUMBER = "section_number";
		static ArrayList<Post> topPostList;
		static PostListAdapter topListAdapter;
		final static int sectionNumber = 0;

		public TopPostFragment()
		{
		}
		
		public TopPostFragment(MainActivity m) 
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
			
			if(topPostList == null)
			{
				topPostList = new ArrayList<Post>();
				topPostList.add(new Post(100, "Top message 1 test message 1 test message 1 test message 1 test message 1", 5));
				topPostList.add(new Post(70, "Top message 2 test message 2 test message", 10));
				topPostList.add(new Post(15, "Top message 3 test message 3 test message 3 test message 3 test message 3", 1));
			}		
			topListAdapter = new PostListAdapter(getActivity(), R.layout.list_row_card, topPostList, 0);
			fragList.setAdapter(topListAdapter);
			
			

		    fragList.setOnItemClickListener(new OnItemClickListener(){

				@Override
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int position, long arg3) 
				{
					postClicked(topPostList.get(position - 1));
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
		
		static Post getPostByID(int id, int sectionNumber)
		{
			if(topPostList != null)
			{
				for(int i = 0; i < topPostList.size(); i++)
				{
					if(topPostList.get(i).getID() == id)
					{
						return topPostList.get(i);
					}
				}
			}
		
			return null;
		}

		public static void updateList() 
		{
			if(topListAdapter != null)
			{
				topListAdapter.notifyDataSetChanged();
			}			
		}
	}
	
	public static class NewPostFragment extends Fragment 
	{		
		static MainActivity mainActivity;
		public static final String ARG_SECTION_NUMBER = "section_number";
		static ArrayList<Post> newPostList;
		static PostListAdapter newListAdapter;
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
			
			if(newPostList == null)
			{
				newPostList = new ArrayList<Post>();
				newPostList.add(new Post(100, "New message 1 test message 1 test message 1 test message 1 test message 1", 5));
				newPostList.add(new Post(70, "New message 2 test message 2 test message", 10));
				newPostList.add(new Post(15, "New message 3 test message 3 test message 3 test message 3 test message 3", 1));
			}		
			newListAdapter = new PostListAdapter(getActivity(), R.layout.list_row_card, newPostList, 1);
			fragList.setAdapter(newListAdapter);
			
			

		    fragList.setOnItemClickListener(new OnItemClickListener(){

				@Override
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int position, long arg3) 
				{
					postClicked(newPostList.get(position - 1));
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
		
		static Post getPostByID(int id, int sectionNumber)
		{
			if(newPostList != null)
			{
				for(int i = 0; i < newPostList.size(); i++)
				{
					if(newPostList.get(i).getID() == id)
					{
						return newPostList.get(i);
					}
				}
			}
		
			return null;
		}

		public static void updateList() 
		{
			if(newListAdapter != null)
			{
				newListAdapter.notifyDataSetChanged();
			}
			
			if(newListAdapter != null)
			{
				newListAdapter.notifyDataSetChanged();
			}
			
		}
	}

public static class TagFragment extends Fragment {
		
		static MainActivity mainActivity;
		public static final String ARG_SECTION_NUMBER = "section_number";
		static ArrayList<Tag> tagList;

		public TagFragment()
		{
		}
		
		public TagFragment(MainActivity m) 
		{
			mainActivity = m;
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_layout,
					container, false);
			ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
			
			tagList = new ArrayList<Tag>();
			tagList.add(new Tag("#wwwwww", 5));
			tagList.add(new Tag("#wwwwwwwwwwwwwwwwwwwwwwwwwww", 5));
			tagList.add(new Tag("#wwwwwwww", 5));
			
			TagListAdapter adapter = new TagListAdapter(getActivity(), R.layout.list_row_card_tag, tagList);
			
			//if doesnt have header and footer, add them
			if(fragList.getHeaderViewsCount() == 0)
			{
				//for card UI
				View headerFooter = new View(getActivity());
				headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
				fragList.addFooterView(headerFooter, null, false);
				fragList.addHeaderView(headerFooter, null, false);
			}
		    fragList.setAdapter(adapter);
		    fragList.setItemsCanFocus(true);
		    
			return rootView;
		}

		public static void tagClicked(Tag tag) 
		{
			Intent intent = new Intent(mainActivity, TagListActivity.class);
			intent.putExtra("TAG_ID", tag.getText());
			
			mainActivity.startActivity(intent);
			mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);			
		}
	}
}
