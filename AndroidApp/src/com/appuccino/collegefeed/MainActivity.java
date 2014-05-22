package com.appuccino.collegefeed;

import java.util.ArrayList;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

import android.animation.ArgbEvaluator;
import android.animation.ObjectAnimator;
import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.AlertDialog;
import android.app.FragmentTransaction;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.TransitionDrawable;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.extra.NetWorker.MakePostTask;
import com.appuccino.collegefeed.fragments.MostActiveCollegesFragment;
import com.appuccino.collegefeed.fragments.MyCommentsFragment;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TagFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Post;
import com.astuetz.PagerSlidingTabStrip;

public class MainActivity extends FragmentActivity implements ActionBar.TabListener, LocationListener 
{
	ViewPager viewPager;
	PagerSlidingTabStrip tabs;
	OneCollegeSectionsPagerAdapter oneCollegePagerAdapter;
	AllCollegesSectionsPagerAdapter allCollegesPagerAdapter;
	
	ActionBar actionBar;
	ImageView newPostButton;
	public static Spinner spinner;
	ArrayList<Fragment> fragmentList;
	boolean locationFound = false;
	public static LocationManager mgr;
	public static ArrayList<Integer> permissions = new ArrayList<Integer>();	//0 = no perms, otherwise the college ID is the perm IDs
	public static int currentFeedCollegeID;	//0 if viewing all colleges
	static final double milesForPermissions = 15.0;
	final int locationTimeoutSeconds = 10;
	final int minPostLength = 10;
	
	/*
	 * TODO:
	 * Implement Haversine function to calculate shortest distance between two spherical points.
	 * http://www.movable-type.co.uk/scripts/latlong.html
	 */
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		tabs = (PagerSlidingTabStrip)findViewById(R.id.tabs);
		viewPager = (ViewPager) findViewById(R.id.pager);
		tabs.setIndicatorColor(getResources().getColor(R.color.tabunderlineblue));
		
		// Set up the action bar.
		actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_main);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
		
		locationFound = false;
		
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
		
		getLocation();
	}
	
	protected void spinnerChanged(int which) 
	{
		//all colleges section
		if(which == 0)
		{
			currentFeedCollegeID = 0;
			
			// Create the adapter that will return a fragment for each of the three
			// primary sections of the app.
			allCollegesPagerAdapter = new AllCollegesSectionsPagerAdapter(this, getSupportFragmentManager());

			// Set up the ViewPager with the sections adapter.
			viewPager.setAdapter(allCollegesPagerAdapter);
			viewPager.setOffscreenPageLimit(5);
			tabs.setViewPager(viewPager);
						
		}
		else //specific college
		{
			currentFeedCollegeID = 234234;
			
			showPermissionsToast();
			
			// Create the adapter that will return a fragment for each of the three
			// primary sections of the app.
			oneCollegePagerAdapter = new OneCollegeSectionsPagerAdapter(this, getSupportFragmentManager());

			// Set up the ViewPager with the sections adapter.
			viewPager.setAdapter(oneCollegePagerAdapter);
			viewPager.setOffscreenPageLimit(5);
			tabs.setViewPager(viewPager);
		}
	}
	
	private void showPermissionsToast() 
	{
		if(hasPermissions(currentFeedCollegeID))
		{
			Toast.makeText(this, "Since you are near Texas A&M University, you can upvote, downvote, post, and comment", Toast.LENGTH_LONG).show();
		}
		else
		{
			Toast.makeText(this, "Since you aren't near Texas A&M University, you can only downvote", Toast.LENGTH_LONG).show();
		}
	}

	public static boolean hasPermissions(int collegeID) 
	{
		if(permissions == null)
			return false;
		else
		{
			//have to access here to not throw nullpointerexception
			if(permissions.size() == 0)
				return false;
			else
			{
				if(permissions.contains(collegeID))
					return true;
				else
					return false;
			}
		}
	}

	private void fadeActionBarColor(ColorDrawable to){
		ColorDrawable[] colors = {new ColorDrawable(getResources().getColor(R.color.blue)), to};
	    
		if (android.os.Build.VERSION.SDK_INT >= 16){
			fadeActionBarColorCurrent(colors);
        }
		else{
			fadeActionBarColorDeprecated(colors);
		}
	}
	
	@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
	private void fadeActionBarColorCurrent(ColorDrawable[] colors){
		TransitionDrawable trans = new TransitionDrawable(colors); //ok so this doesn't work yet its so weird.
		TransitionDrawable trans2 = new TransitionDrawable(colors); //so ridiculous that i have to make two transitions
	    actionBar.setBackgroundDrawable(trans);						//must be doing something wrong lol.
	    actionBar.getCustomView().setBackground(trans2);
	    trans.startTransition(1000);
	    trans2.startTransition(2000);
	}
	
	@SuppressWarnings("deprecation")
	private void fadeActionBarColorDeprecated(ColorDrawable[] colors){
		TransitionDrawable trans = new TransitionDrawable(colors);
		TransitionDrawable trans2 = new TransitionDrawable(colors);
	    actionBar.setBackgroundDrawable(trans);
	    actionBar.getCustomView().setBackgroundDrawable(trans2);
	    trans.startTransition(1000);
	    trans2.startTransition(1000);
	}
	
	private void getLocation(){
		mgr = (LocationManager) getSystemService(LOCATION_SERVICE);
		Criteria criteria = new Criteria();
		criteria.setAccuracy(Criteria.ACCURACY_COARSE);
		String best = mgr.getBestProvider(criteria, true);
		Log.d("location", best);
		if (best == null) {
		    //ask user to enable at least one of the Location Providers
			permissions.clear();	//no permissions
			if(newPostButton.isShown())
				newPostButton.setVisibility(View.INVISIBLE);
			Toast.makeText(this, "Location Services are turned off.", Toast.LENGTH_LONG).show();
			Toast.makeText(this, "You can upvote, but nothing else.", Toast.LENGTH_LONG).show();
		} else {
//		    Location lastKnownLoc = mgr.getLastKnownLocation(best);
//		    //But sometimes it returns null
//		    if(lastKnownLoc == null){
//		    	Toast.makeText(this, "Getting your location...", Toast.LENGTH_LONG).show();
		    	//mgr.requestLocationUpdates(best, 0, 0, this);
		    	//mgr.requestSingleUpdate(best, this, null);
				if(mgr.getProvider(LocationManager.NETWORK_PROVIDER) != null){
					mgr.requestSingleUpdate(LocationManager.NETWORK_PROVIDER, this, null);
				}
				else if(mgr.getProvider(LocationManager.GPS_PROVIDER) != null){
					mgr.requestSingleUpdate(LocationManager.GPS_PROVIDER, this, null);
				}
		    	Timer timeout = new Timer();
		    	final MainActivity that = this;
		    	timeout.schedule(new TimerTask()
		    	{
					@Override
					public void run() 
					{						
						if(!locationFound)
						{
							mgr.removeUpdates(that);
							that.runOnUiThread(new Runnable(){

								@Override
								public void run() {
									Toast.makeText(getApplicationContext(), "Couldn't find location. You can upvote, but nothing else.", Toast.LENGTH_LONG).show();

								}
								
							});
							
						}							
					}		    		
		    	}, locationTimeoutSeconds * 1000);
//			}
//		    else{
//		    	determinePermissions(lastKnownLoc);
//		    }
		}
	}

	private void determinePermissions(Location loc) 
	{
		double degreesForPermissions = milesForPermissions / 50.0;	//roughly 50 miles per degree
		
		//USED FOR TESTING, ALL OF OUR CITIES RETURN A&M
		double tamuLatitude = 30.614942;
		double tamuLongitude = -96.342316;
		double austinLatitude = 30.270664;
		double austinLongitude = -97.741064;
		double seattleLatitude = 0;	//JAMES fill these in
		double seattleLongitude = 0;
		
		int tamuID = 234234;
		
		double degreesAway1 = Math.sqrt(Math.pow((loc.getLatitude() - tamuLatitude), 2) + Math.pow((loc.getLongitude() - tamuLongitude), 2));
		double degreesAway2 = Math.sqrt(Math.pow((loc.getLatitude() - austinLatitude), 2) + Math.pow((loc.getLongitude() - austinLongitude), 2));
		double degreesAway3 = Math.sqrt(Math.pow((loc.getLatitude() - seattleLatitude), 2) + Math.pow((loc.getLongitude() - seattleLongitude), 2));
		
		//gets which is least of the three
		double degreesAway = Math.min(degreesAway1, degreesAway2);
		degreesAway = Math.min(degreesAway, degreesAway3);
		if(degreesAway < degreesForPermissions)
		{
			permissions.clear();
			permissions.add(tamuID);
			if(!newPostButton.isShown())
				newPostButton.setVisibility(View.VISIBLE);
			Toast.makeText(this, "You're near Texas A&M University", Toast.LENGTH_LONG).show();
			Toast.makeText(this, "You can upvote, downvote, post, and comment on that college's posts", Toast.LENGTH_LONG).show();
			updateListsForGPS();	//so that GPS icon can be set
		}
		else
		{
			permissions.clear();
			if(newPostButton.isShown())
				newPostButton.setVisibility(View.INVISIBLE);
			Toast.makeText(this, "You aren't near a college, you can upvote but nothing else", Toast.LENGTH_LONG).show();
		}
	}

	private void updateListsForGPS() 
	{
		//if looking at All Colleges, update lists for GPS icon
		if(spinner.getSelectedItemPosition() == 0)
		{
			TopPostFragment.updateList();
			NewPostFragment.updateList();
		}
	}


	public void newPostClicked() 
	{
		LayoutInflater inflater = getLayoutInflater();
		View postDialogLayout = inflater.inflate(R.layout.dialog_post, null);
		final EditText postMessage = (EditText)postDialogLayout.findViewById(R.id.newPostMessage);
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
    	builder.setCancelable(true);
    	builder.setView(postDialogLayout)
    	.setPositiveButton("Post", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing here since overridden below to be able to click button and not dismiss dialog
            }
        });
    	    	
    	final AlertDialog dialog = builder.create();
    	dialog.show();
    	
    	Button postButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
    	postButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{				
    			if(postMessage.getText().toString().length() >= minPostLength)
    			{
    				Post newPost = new Post(postMessage.getText().toString());
        			NewPostFragment.postList.add(newPost);
        			TopPostFragment.postList.add(newPost);
        			new MakePostTask().execute(newPost);
        			dialog.dismiss();
    			}
    			else
    			{
    				Toast.makeText(getApplicationContext(), "Post must be at least 10 characters long.", Toast.LENGTH_LONG).show();
    			}
			}
    	});
    	
    	Typeface light = Typeface.createFromAsset(getAssets(), "fonts/Roboto-Light.ttf");
    	Typeface italic = Typeface.createFromAsset(getAssets(), "fonts/Roboto-LightItalic.ttf");
    	TextView title = (TextView)postDialogLayout.findViewById(R.id.newPostTitle);
    	TextView college = (TextView)postDialogLayout.findViewById(R.id.collegeText);
    	postMessage.setTypeface(light);
    	college.setTypeface(italic);
    	title.setTypeface(light);
    	postButton.setTypeface(light);
    	
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
    	tagsText.setTypeface(light);
    	
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
				fragment = new MyPostsFragment(mainActivity);
				break;
			case 4:	//my comments
				fragment = new MyCommentsFragment(mainActivity);
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
				fragment = new MostActiveCollegesFragment(mainActivity);
				break;
			case 4:	//my posts
				fragment = new MyPostsFragment(mainActivity);
				break;
			case 5:	//my comments
				fragment = new MyCommentsFragment(mainActivity);
				break;
			}
			
			if(fragment != null)
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
		locationFound = true;
		determinePermissions(loc);
		//mgr.removeUpdates(this);
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
