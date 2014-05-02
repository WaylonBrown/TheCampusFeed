package com.appuccino.collegefeed;

import java.util.ArrayList;
import java.util.Locale;

import android.app.ActionBar;
import android.app.AlertDialog;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TagFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Post;

public class MainActivity extends FragmentActivity implements ActionBar.TabListener, LocationListener 
{

	OneCollegeSectionsPagerAdapter oneCollegePagerAdapter;
	AllCollegesSectionsPagerAdapter allCollegesPagerAdapter;
	ActionBar actionBar;
	ImageView newPostButton;
	public static Spinner spinner;
	ViewPager viewPager;
	ArrayList<Fragment> fragmentList;
	
	public static LocationManager mgr;
	public static int permissions = 0;	//0 = no perms, otherwise the college ID is the perm IDs
	public static int currentFeedCollegeID;	//0 if viewing all colleges
	static final double milesForPermissions = 15.0;
	/*
	 * TODO:
	 * Implement Haversine function to calculate shortest distance between two spherical points.
	 * http://www.movable-type.co.uk/scripts/latlong.html
	 */
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		// Set up the action bar.
		actionBar = getActionBar();
		actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		actionBar.setCustomView(R.layout.actionbar_main);
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

		spinner = (Spinner)findViewById(R.id.spinner);
		spinner.setOnItemSelectedListener(new OnItemSelectedListener(){

			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				spinnerChanged(arg2);
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
				// TODO Auto-generated method stub
				
			}
			
		});
		
		//determinePermissions();
		getLocation(); //This calls determine permissions now.
	}
	
	protected void spinnerChanged(int which) 
	{
		//all colleges section
		if(which == 0)
		{
			currentFeedCollegeID = 0;
			newPostButton.setVisibility(View.GONE);	
			
			// Create the adapter that will return a fragment for each of the three
			// primary sections of the app.
			allCollegesPagerAdapter = new AllCollegesSectionsPagerAdapter(this, getSupportFragmentManager());

			// Set up the ViewPager with the sections adapter.
			viewPager = (ViewPager) findViewById(R.id.pager);
			viewPager.setAdapter(allCollegesPagerAdapter);
			viewPager.setOffscreenPageLimit(5);

			// When swiping between different sections, select the corresponding
			// tab. We can also use ActionBar.Tab#select() to do this if we have
			// a reference to the Tab.
			viewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() 
			{
				@Override
				public void onPageSelected(int position) {
					actionBar.setSelectedNavigationItem(position);
				}
			});

			actionBar.removeAllTabs();
			// For each of the sections in the app, add a tab to the action bar.
			for (int i = 0; i < allCollegesPagerAdapter.getCount(); i++) 
			{
				// Create a tab with text corresponding to the page title defined by
				// the adapter. Also specify this Activity object, which implements
				// the TabListener interface, as the callback (listener) for when
				// this tab is selected.
				actionBar.addTab(actionBar.newTab()
						.setText(allCollegesPagerAdapter.getPageTitle(i))
						.setTabListener(this));
			}
		}
		else //specific college
		{
			currentFeedCollegeID = 234234;
			//change permissions UI
			if(permissions != 0)
			{
				newPostButton.setVisibility(View.VISIBLE);
			}
			else
			{
				newPostButton.setVisibility(View.GONE);
			}
			
			if(permissions == currentFeedCollegeID)
			{
				Toast.makeText(this, "Since you are near Texas A&M University, you can upvote, downvote, post, and comment", Toast.LENGTH_LONG).show();
			}
			else
			{
				Toast.makeText(this, "Since you aren't near Texas A&M University, you can only downvote", Toast.LENGTH_LONG).show();
			}
			
			// Create the adapter that will return a fragment for each of the three
			// primary sections of the app.
			oneCollegePagerAdapter = new OneCollegeSectionsPagerAdapter(this, getSupportFragmentManager());

			// Set up the ViewPager with the sections adapter.
			viewPager = (ViewPager) findViewById(R.id.pager);
			viewPager.setAdapter(oneCollegePagerAdapter);
			viewPager.setOffscreenPageLimit(5);

			// When swiping between different sections, select the corresponding
			// tab. We can also use ActionBar.Tab#select() to do this if we have
			// a reference to the Tab.
			viewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() 
			{
						@Override
						public void onPageSelected(int position) {
							actionBar.setSelectedNavigationItem(position);
						}
					});

			actionBar.removeAllTabs();
			// For each of the sections in the app, add a tab to the action bar.
			for (int i = 0; i < oneCollegePagerAdapter.getCount(); i++) 
			{
				// Create a tab with text corresponding to the page title defined by
				// the adapter. Also specify this Activity object, which implements
				// the TabListener interface, as the callback (listener) for when
				// this tab is selected.
				actionBar.addTab(actionBar.newTab()
						.setText(oneCollegePagerAdapter.getPageTitle(i))
						.setTabListener(this));
			}
		}
	}
	
	private void getLocation(){
		mgr = (LocationManager) getSystemService(LOCATION_SERVICE);
		Criteria criteria = new Criteria();
		String best = mgr.getBestProvider(criteria, true);
		if (best == null) {
		    //ask user to enable at least one of the Location Providers
			permissions = 0;
			Toast.makeText(this, "Location Services are turned off.", Toast.LENGTH_LONG).show();
			Toast.makeText(this, "You can upvote, but nothing else.", Toast.LENGTH_LONG).show();
		} else {
		    Location lastKnownLoc = mgr.getLastKnownLocation(best);
		    //But sometimes it returns null
		    if(lastKnownLoc == null){
		    	Toast.makeText(this, "Getting your location...", Toast.LENGTH_LONG).show();
		    	mgr.requestLocationUpdates(best, 0, 0, this);
			}
		    else{
		    	determinePermissions(lastKnownLoc);
		    }
		}
	}

	private void determinePermissions(Location loc) 
	{
		double degreesForPermissions = milesForPermissions / 50.0;	//roughly 50 miles per degree
		double tamuLatitude = 30.614942;
		double tamuLongitude = -96.342316;
		int tamuID = 234234;
		
		double degreesAway = Math.sqrt(Math.pow((loc.getLatitude() - tamuLatitude), 2) + Math.pow((loc.getLongitude() - tamuLongitude), 2));
		if(degreesAway < degreesForPermissions)
		{
			permissions = tamuID;
			Toast.makeText(this, "You're near Texas A&M University, you can upvote, downvote, post, and comment on that college's posts", Toast.LENGTH_LONG).show();
		}
		else
		{
			permissions = 0;
			Toast.makeText(this, "You aren't near a college, you can upvote but nothing else", Toast.LENGTH_LONG).show();
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
    			NewPostFragment.postList.add(new Post(postMessage.getText().toString()));
    			TopPostFragment.postList.add(new Post(postMessage.getText().toString()));
    		}
    	});
    	
    	final AlertDialog dialog = builder.create();
    	if(spinner.getSelectedItemPosition() == 2)
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
   
    	final TextView tagsText = (TextView)postDialogLayout.findViewById(R.id.newPostTagsText);
    	tagsText.setTypeface(customfont);
    	
    	//set listener for tags
    	postMessage.addTextChangedListener(new TextWatcher(){

			@Override
			public void afterTextChanged(Editable s) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				String message = postMessage.getText().toString();
				String currentTags = "Tags: <font color='#33B5E5'>";
				
				String[] wordArray = message.split(" ");
				if(wordArray.length > 0)
				{
					for(int i = 0; i < wordArray.length; i++)
					{
						//prevent indexoutofboundsexception
						if(wordArray[i].length() > 0)
						{
							if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
							{
								currentTags += wordArray[i] + " ";
							}
						}
					}
				}
				
				currentTags += "</font>";
				//if there aren't any tags and view is shown, remove view
				if(currentTags.equals("Tags: <font color='#33B5E5'></font>") && tagsText.isShown())
				{
					tagsText.setVisibility(View.GONE);
					//tagsText.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, 0));
					//tagsText.setHeight(0);
				}					
				else if(!currentTags.equals("Tags: <font color='#33B5E5'></font>") && !tagsText.isShown())
				{
					tagsText.setVisibility(View.VISIBLE);
//					//tagsText.setLayoutParams(new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.WRAP_CONTENT));
//					Resources r = getApplicationContext().getResources();
//					Toast.makeText(getApplicationContext(), Math.round(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 100, r.getDisplayMetrics())), Toast.LENGTH_LONG).show();
//					tagsText.setHeight(100);
				}
					
				tagsText.setText(Html.fromHtml((currentTags)));
			}
    		
    	});
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
	public class OneCollegeSectionsPagerAdapter extends FragmentStatePagerAdapter {
		MainActivity mainActivity;
		
		public OneCollegeSectionsPagerAdapter(MainActivity m, FragmentManager fm) {
			super(fm);
			mainActivity = m;
		}
		
		@Override
		public Fragment getItem(int position) {
			// getItem is called to instantiate the fragment for the given page.
			// Return a SectionFragment (defined as a static inner class
			// below) with the page number as its lone argument.
			Fragment fragment = null;
			switch(position)
			{
			case 0:	//top posts
				fragment = new TopPostFragment(mainActivity);
				break;
			case 1:	//new posts
				fragment = new NewPostFragment(mainActivity);
				break;
			case 2:	//trending tags
				fragment = new TagFragment(mainActivity);
				break;
			case 3:	//my posts
				fragment = new NewPostFragment(mainActivity);
				break;
			case 4:	//my comments
				fragment = new NewPostFragment(mainActivity);
				break;
			}
			
			Bundle args = new Bundle();
			args.putInt(TopPostFragment.ARG_TAB_NUMBER, position);
			fragment.setArguments(args);
			return fragment;
		}

		@Override
		public int getCount() {
			return 5;
		}

		@Override
		public CharSequence getPageTitle(int position) {
			Locale l = Locale.getDefault();
			switch (position) {
			case 0:
				return getString(R.string.onecollege_section1).toUpperCase(l);
			case 1:
				return getString(R.string.onecollege_section2).toUpperCase(l);
			case 2:
				return getString(R.string.onecollege_section3).toUpperCase(l);
			case 3:
				return getString(R.string.onecollege_section4).toUpperCase(l);
			case 4:
				return getString(R.string.onecollege_section5).toUpperCase(l);
			}
			return null;
		}
		
	}
	
	public class AllCollegesSectionsPagerAdapter extends FragmentStatePagerAdapter {
		MainActivity mainActivity;
		
		public AllCollegesSectionsPagerAdapter(MainActivity m, FragmentManager fm) {
			super(fm);
			mainActivity = m;
		}
		
		@Override
		public Fragment getItem(int position) {
			// getItem is called to instantiate the fragment for the given page.
			// Return a SectionFragment (defined as a static inner class
			// below) with the page number as its lone argument.
			Bundle args = new Bundle();
			args.putInt(TopPostFragment.ARG_TAB_NUMBER, position);
			
			Fragment fragment = null;
			switch(position)
			{
			case 0:	//top posts
				fragment = new TopPostFragment(mainActivity);
				break;
			case 1:	//new posts
				fragment = new NewPostFragment(mainActivity);
				break;
			case 2:	//trending tags
				fragment = new TagFragment(mainActivity);
				break;
			case 3:	//most active colleges
				fragment = new TagFragment(mainActivity);
				break;
			case 4:	//my posts
				fragment = new NewPostFragment(mainActivity);
				break;
			case 5:	//my comments
				fragment = new NewPostFragment(mainActivity);
				break;
			}
			
			fragment.setArguments(args);
			return fragment;
		}

		@Override
		public int getCount() {
			return 6;
		}

		@Override
		public CharSequence getPageTitle(int position) {
			Locale l = Locale.getDefault();
			switch (position) {
			case 0:
				return getString(R.string.allcollege_section1).toUpperCase(l);
			case 1:
				return getString(R.string.allcollege_section2).toUpperCase(l);
			case 2:
				return getString(R.string.allcollege_section3).toUpperCase(l);
			case 3:
				return getString(R.string.allcollege_section4).toUpperCase(l);
			case 4:
				return getString(R.string.allcollege_section5).toUpperCase(l);
			case 5:
				return getString(R.string.allcollege_section6).toUpperCase(l);
			}
			return null;
		}
	}

	@Override
	public void onLocationChanged(Location loc) {
		determinePermissions(loc);
		mgr.removeUpdates(this);
	}

	@Override
	public void onProviderDisabled(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onProviderEnabled(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
		// TODO Auto-generated method stub
		
	}
}
