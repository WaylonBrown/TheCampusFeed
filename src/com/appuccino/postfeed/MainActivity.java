package com.appuccino.postfeed;

import java.util.ArrayList;
import java.util.Locale;
import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.NavUtils;
import android.support.v4.view.ViewPager;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

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
			if(position != 2)	//third section is tags
				fragment = new SectionFragment(mainActivity);
			else
				fragment = new TagFragment(mainActivity);
			Bundle args = new Bundle();
			args.putInt(SectionFragment.ARG_SECTION_NUMBER, position + 1);
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

	public static class SectionFragment extends Fragment {
		
		MainActivity mainActivity;
		public static final String ARG_SECTION_NUMBER = "section_number";

		public SectionFragment()
		{
		}
		
		public SectionFragment(MainActivity m) 
		{
			mainActivity = m;
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_layout,
					container, false);
			ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
			
			ArrayList<Post> testList = new ArrayList<Post>();
			testList.add(new Post(100, "Test message 1 test message 1 test message 1 test message 1 test message 1", 5));
			testList.add(new Post(70, "Test message 2 test message 2 test message", 10));
			testList.add(new Post(15, "Test message 3 test message 3 test message 3 test message 3 test message 3", 1));
			
			CustomListAdapter adapter = new CustomListAdapter(getActivity(), R.layout.list_row_card, testList);
			
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

			return rootView;
		}
	}

public static class TagFragment extends Fragment {
		
		MainActivity mainActivity;
		public static final String ARG_SECTION_NUMBER = "section_number";

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
			
			ArrayList<Tag> testList = new ArrayList<Tag>();
			testList.add(new Tag("#wwwwww", 5));
			testList.add(new Tag("#wwwwwwwwwwwwwwwwwwwwwwwwwww", 5));
			testList.add(new Tag("#wwwwwwww", 5));
			
			CustomTagListAdapter adapter = new CustomTagListAdapter(getActivity(), R.layout.list_row_card_tag, testList);
			
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

			return rootView;
		}
	}
}
