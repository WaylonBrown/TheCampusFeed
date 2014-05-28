package com.appuccino.collegefeed;

import java.util.ArrayList;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.AlertDialog;
import android.app.FragmentTransaction;
import android.content.DialogInterface;
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
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.dialogs.ChooseFeedDialog;
import com.appuccino.collegefeed.dialogs.NewPostDialog;
import com.appuccino.collegefeed.extra.FontManager;
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
	PagerAdapter pagerAdapter;
	ActionBar actionBar;
	ImageView newPostButton;
	
	final static int ALL_COLLEGES = 0;
	
	ArrayList<Fragment> fragmentList;
	boolean locationFound = false;
	public static LocationManager mgr;
	public static ArrayList<Integer> permissions = new ArrayList<Integer>();	//0 = no perms, otherwise the college ID is the perm IDs
	public static int currentFeedCollegeID;	//0 if viewing all colleges
	static final double MILES_FOR_PERMISSION = 15.0;
	static final int LOCATION_TIMEOUT_SECONDS = 10;
	public static final int MIN_POST_LENGTH = 10;
	
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
		
		FontManager.setup(this);
		setupActionbar();
		
		locationFound = false;
		
		newPostButton = (ImageView)findViewById(R.id.newPostButton);
		newPostButton.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				newPostClicked();
			}
		});
		
		feedStyleChanged(ALL_COLLEGES);
		getLocation();
	}

	private void setupActionbar() {
		actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_main);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
	}

	//determined between All Colleges and a specific college
	protected void feedStyleChanged(int which) 
	{
		//all colleges section
		if(which == ALL_COLLEGES)
		{
			currentFeedCollegeID = ALL_COLLEGES;
		}
		else //specific college
		{
			currentFeedCollegeID = 234234;
			showPermissionsToast();
		}
		
		// Create the adapter that will return a fragment for each of the
		// sections of the app.
		pagerAdapter = new PagerAdapter(this, getSupportFragmentManager());
	
		// Set up the ViewPager with the sections adapter.
		viewPager.setAdapter(pagerAdapter);
		viewPager.setOffscreenPageLimit(5);
		tabs.setViewPager(viewPager);
		
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
		    	}, LOCATION_TIMEOUT_SECONDS * 1000);
//			}
//		    else{
//		    	determinePermissions(lastKnownLoc);
//		    }
		}
	}

	private void determinePermissions(Location loc) 
	{
		double degreesForPermissions = MILES_FOR_PERMISSION / 50.0;	//roughly 50 miles per degree
		
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
		Toast.makeText(this, "Remember to reimplement updateListsForGPS()", Toast.LENGTH_SHORT).show();
		//if looking at All Colleges, update lists for GPS icon
//		if(spinner.getSelectedItemPosition() == 0)
//		{
//			TopPostFragment.updateList();
//			NewPostFragment.updateList();
//		}
	}
	
	public void chooseFeedDialog() {
		LayoutInflater inflater = getLayoutInflater();
		View layout = inflater.inflate(R.layout.dialog_choose_feed, null);
		new ChooseFeedDialog(this, layout);
	}

	

	public void newPostClicked() 
	{
		LayoutInflater inflater = getLayoutInflater();
		View postDialogLayout = inflater.inflate(R.layout.dialog_post, null);
		new NewPostDialog(this, postDialogLayout);
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
	
	public class PagerAdapter extends FragmentStatePagerAdapter {
		MainActivity mainActivity;
		
		public PagerAdapter(MainActivity m, FragmentManager fm) {
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
				return getString(R.string.section1).toUpperCase(l);
			case 1:
				return getString(R.string.section2).toUpperCase(l);
			case 2:
				return getString(R.string.section3).toUpperCase(l);
			case 3:
				return getString(R.string.section4).toUpperCase(l);
			case 4:
				return getString(R.string.section5).toUpperCase(l);
			case 5:
				return getString(R.string.section6).toUpperCase(l);
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
