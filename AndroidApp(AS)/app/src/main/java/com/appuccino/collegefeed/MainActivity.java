package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.graphics.drawable.ColorDrawable;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.appuccino.collegefeed.dialogs.ChooseFeedDialog;
import com.appuccino.collegefeed.dialogs.GettingStartedDialog;
import com.appuccino.collegefeed.dialogs.NewPostDialog;
import com.appuccino.collegefeed.extra.AllCollegeJSONString;
import com.appuccino.collegefeed.fragments.MostActiveCollegesFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TagFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.JSONParser;
import com.appuccino.collegefeed.utils.ListComparator;
import com.appuccino.collegefeed.utils.NetWorker;
import com.appuccino.collegefeed.utils.PrefManager;
import com.astuetz.PagerSlidingTabStrip;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends FragmentActivity implements ActionBar.TabListener, LocationListener 
{
	//views and widgets
	static ViewPager viewPager;
	PagerSlidingTabStrip tabs;
	PagerAdapter pagerAdapter;
	ActionBar actionBar;
	ImageView newPostButton;
	ProgressBar permissionsProgress;
	ChooseFeedDialog chooseFeedDialog;
	
	//final values
	public static final int ALL_COLLEGES = 0;	//used for permissions
	public static final String PREFERENCE_KEY_COLLEGE_LIST1 = "all_colleges_preference_key1";
	public static final String PREFERENCE_KEY_COLLEGE_LIST2 = "all_colleges_preference_key2";
	public static final double MILES_FOR_PERMISSION = 15.0;
	public static final int LOCATION_TIMEOUT_SECONDS = 10;
	public static final int MIN_POST_LENGTH = 10;
	public static final int MIN_COMMENT_LENGTH = 5;
    public static final int COLLEGE_LIST_UPDATE_IN_WEEKS = 2;
	
	boolean locationFound = false;
	public static LocationManager mgr;
	public static int currentFeedCollegeID;	//0 if viewing all colleges
    public static Calendar lastCollegeListUpdate;
	public static ArrayList<Integer> permissions = new ArrayList<Integer>();	//length of 0 or null = no perms, otherwise the college ID is the perm IDs
	public static ArrayList<College> collegeList = new ArrayList<College>();
	
	public static List<Integer> postUpvoteList = new ArrayList<Integer>();
	public static List<Integer> postDownvoteList = new ArrayList<Integer>();
	public static List<Integer> commentUpvoteList = new ArrayList<Integer>();
	public static List<Integer> commentDownvoteList = new ArrayList<Integer>();
    public static List<Integer> flagList = new ArrayList<Integer>();
    public static List<Integer> myPostsList = new ArrayList<Integer>();
    public static List<Integer> myCommentsList = new ArrayList<Integer>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        PrefManager.setup(this);
		setupApp();
        lastCollegeListUpdate = PrefManager.getLastCollegeListUpdate();
        getNewCollegeListIfNeeded();
		getLocation();
		Log.i("cfeed","APPSETUP: onCreate");		
	}
	
	//this is called when orientation changes
	@Override
	public void onConfigurationChanged(Configuration newConfig)
	{
	    super.onConfigurationChanged(newConfig);
	    Log.i("cfeed","APPSETUP: orientation change");
	    setupApp();
	    if(permissions == null || permissions.size() == 0){
	    	newPostButton.setVisibility(View.GONE);
	    } else {
	    	newPostButton.setVisibility(View.VISIBLE);
	    }
	}

	private void setupApp(){
		setContentView(R.layout.activity_main);
		tabs = (PagerSlidingTabStrip)findViewById(R.id.tabs);
		viewPager = (ViewPager) findViewById(R.id.pager);
		tabs.setIndicatorColor(getResources().getColor(R.color.tabunderlineblue));
		
		FontManager.setup(this);
		setupActionbar();

		postUpvoteList = PrefManager.getPostUpvoteList();
		postDownvoteList = PrefManager.getPostDownvoteList();
		commentUpvoteList = PrefManager.getCommentUpvoteList();
		commentDownvoteList = PrefManager.getCommentDownvoteList();
		flagList = PrefManager.getFlagList();
        myPostsList = PrefManager.getMyPostsList();
        myCommentsList = PrefManager.getMyCommentsList();

		permissionsProgress = (ProgressBar)findViewById(R.id.permissionsLoadingIcon);
		newPostButton = (ImageView)findViewById(R.id.newPostButton);
		newPostButton.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				newPostClicked();
			}
		});
		
		setupAdapter();
	}
	
	private void setupAdapter() {
		// Create the adapter that will return a fragment for each of the
		// sections of the app.
		pagerAdapter = new PagerAdapter(this, getSupportFragmentManager());
	
		// Set up the ViewPager with the sections adapter.
		viewPager.setAdapter(pagerAdapter);
		viewPager.setOffscreenPageLimit(10);
		tabs.setViewPager(viewPager);
	}

    public static void addNewPostToListAndMyContent(Post post){
        //instantly add to new posts
        if(currentFeedCollegeID == ALL_COLLEGES || currentFeedCollegeID == post.getCollegeID()){
            NewPostFragment.postList.add(0, post);
            myPostsList.add(post.getID());
            PrefManager.putMyPostsList(myPostsList);
            NewPostFragment.updateList();
            MainActivity.goToNewPostsAndScrollToTop();

            Log.i("cfeed","New My Posts list is of size " + myPostsList.size());
        }
    }

    private void getNewCollegeListIfNeeded(){
        setupCollegeList();
        Calendar now = Calendar.getInstance();
        if(lastCollegeListUpdate == null){
            Log.i("cfeed","COLLEGE_LIST no saved college retrieval time, setting update time to now");
            PrefManager.putLastCollegeListUpdate(now);
        } else {
            Log.i("cfeed","COLLEGE_LIST there is a saved college retrieval time, checking....");
            Calendar lastUpdate = (Calendar)lastCollegeListUpdate.clone();
            lastUpdate.add(Calendar.WEEK_OF_YEAR , COLLEGE_LIST_UPDATE_IN_WEEKS);
            Log.i("cfeed","COLLEGE_LIST Now: Month: " + now.get(Calendar.MONTH) + " Day: " + now.get(Calendar.DAY_OF_MONTH) +
                " Hour: " + now.get(Calendar.HOUR_OF_DAY) + " Minute: " + now.get(Calendar.MINUTE) + " Second: " + now.get(Calendar.SECOND));
            Log.i("cfeed","COLLEGE_LIST Last update: Month: " + lastUpdate.get(Calendar.MONTH) + " Day: " + lastUpdate.get(Calendar.DAY_OF_MONTH) +
                    " Hour: " + lastUpdate.get(Calendar.HOUR_OF_DAY) + " Minute: " + lastUpdate.get(Calendar.MINUTE) + " Second: " + lastUpdate.get(Calendar.SECOND));
            //if last update was 2 or more weeks ago
            if(now.after(lastUpdate)){
                Log.i("cfeed","COLLEGE_LIST list is old, getting new one from server");
                new NetWorker.GetFullCollegeListTask().execute(new NetWorker.PostSelector());
            } else {
                Log.i("cfeed","COLLEGE_LIST list isn't outdated");
            }
        }
    }

	private void setupCollegeList() {
		collegeList = new ArrayList<College>();
		String storedCollegeListJSON1 = PrefManager.getString(PREFERENCE_KEY_COLLEGE_LIST1, "default_value");
		String storedCollegeListJSON2 = PrefManager.getString(PREFERENCE_KEY_COLLEGE_LIST2, "default_value");
		
		//should only happen very first time, store the backup college string to SharedPrefs
		if(storedCollegeListJSON1.equals("default_value") || storedCollegeListJSON1.equals("default_value" ))
		{
            Log.i("cfeed","COLLEGE_LIST using hard coded strings");
			PrefManager.putString(PREFERENCE_KEY_COLLEGE_LIST1, AllCollegeJSONString.ALL_COLLEGES_JSON1);
			PrefManager.putString(PREFERENCE_KEY_COLLEGE_LIST2, AllCollegeJSONString.ALL_COLLEGES_JSON2);
			storedCollegeListJSON1 = PrefManager.getString(PREFERENCE_KEY_COLLEGE_LIST1, "default_value");
			storedCollegeListJSON2 = PrefManager.getString(PREFERENCE_KEY_COLLEGE_LIST2, "default_value");
		}
		
		try {
			collegeList = JSONParser.collegeListFromJSON(storedCollegeListJSON1, storedCollegeListJSON2);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if(collegeList != null)
		{
			//sort list by name
			Collections.sort(collegeList, new ListComparator());
		}
		else
			Toast.makeText(this, "Error fetching college list.", Toast.LENGTH_LONG).show();
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

	public void changeFeed(int id) {
		Log.i("cfeed","Changing to feed with ID " + id);
		currentFeedCollegeID = id;
		if(id != ALL_COLLEGES)
		{
			showPermissionsToast();
		}
			
		PrefManager.putInt(PrefManager.LAST_FEED, id);
		TopPostFragment.changeFeed(id);
		NewPostFragment.changeFeed(id);
		TagFragment.changeFeed(id);

        TopPostFragment.scrollToTop();
        NewPostFragment.scrollToTop();
	}

    public void showFirstTimeMessages(){
        chooseFeedDialog();
        //this one is called second as it has to be on top
        new GettingStartedDialog(this, "Getting Started");
    }
	
	private void showPermissionsToast() 
	{
		String collegeName = getCollegeByID(currentFeedCollegeID).getName();
		if(hasPermissions(currentFeedCollegeID))
		{
			Toast.makeText(this, "Since you are near " + collegeName + ", you can upvote, downvote, post, and comment", Toast.LENGTH_LONG).show();
		}
		else
		{
			Toast.makeText(this, "Since you aren't near " + collegeName + ", you can only upvote", Toast.LENGTH_LONG).show();
		}
	}

	/**
	 * Determine if the user has permissions to the collegeID given
	 * 
	 * @param collegeID
	 * @return
	 */
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
	
	private void getLocation(){
		//lock to portrait until location is received so location retrieval isn't messed up
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		
		permissionsProgress.setVisibility(View.VISIBLE);
		newPostButton.setVisibility(View.GONE);
		
		if(isMockSettingOn() && areThereMockApps()){
			Toast.makeText(this, "Sorry, we can't use your location as in the Android settings you have Allow Mock Location turned on.", Toast.LENGTH_LONG).show();
			Toast.makeText(this, "Turn off Allow Mock Location in Settings>Developer Options.", Toast.LENGTH_LONG).show();
			permissionsProgress.setVisibility(View.GONE);
			newPostButton.setVisibility(View.GONE);
		}else{
			mgr = (LocationManager) getSystemService(LOCATION_SERVICE);
			Criteria criteria = new Criteria();
			criteria.setAccuracy(Criteria.ACCURACY_COARSE);
			String best = mgr.getBestProvider(criteria, true);
			Log.d("location", best);
			if (best == null) {
			    //ask user to enable at least one of the Location Providers
				permissions.clear();	//no permissions
				if(newPostButton.isShown())
				{
					newPostButton.setVisibility(View.GONE);
					permissionsProgress.setVisibility(View.VISIBLE);
				}
				Toast.makeText(this, "Location Services are turned off.", Toast.LENGTH_LONG).show();
				Toast.makeText(this, "You can upvote, but nothing else.", Toast.LENGTH_LONG).show();
			} else {
//			    Location lastKnownLoc = mgr.getLastKnownLocation(best);
//			    //But sometimes it returns null
//			    if(lastKnownLoc == null){
//			    	Toast.makeText(this, "Getting your location...", Toast.LENGTH_LONG).show();
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
										Toast.makeText(that, "Couldn't find location. You can upvote, but nothing else.", Toast.LENGTH_LONG).show();
										permissionsProgress.setVisibility(View.GONE);
										newPostButton.setVisibility(View.GONE);
									}
									
								});
								
							}							
						}		    		
			    	}, LOCATION_TIMEOUT_SECONDS * 1000);
//				}
//			    else{
//			    	determinePermissions(lastKnownLoc);
//			    }
			}
		}
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
	}

	private boolean areThereMockApps() {
		int count = 0;
		
		PackageManager pm = getPackageManager();
		List<ApplicationInfo> packages = pm.getInstalledApplications(PackageManager.GET_META_DATA);
		
		for (ApplicationInfo applicationInfo : packages) {
			try {
				PackageInfo packageInfo = pm.getPackageInfo(applicationInfo.packageName,
		                                                    PackageManager.GET_PERMISSIONS);
		
				// Get Permissions
				String[] requestedPermissions = packageInfo.requestedPermissions;
		
				if (requestedPermissions != null) {
					for (int i = 0; i < requestedPermissions.length; i++) {
						if (requestedPermissions[i]
								.equals("android.permission.ACCESS_MOCK_LOCATION")
								&& !applicationInfo.packageName.equals(getPackageName())) {
							count++;
		          }
		       }
		    }
		 } catch (NameNotFoundException e) {
		    e.printStackTrace();
		     }
		  }
		
		  if (count > 0)
		     return true;
		  return false;
	}

	private boolean isMockSettingOn() {
		// returns true if mock location enabled, false if not enabled.
		if (Settings.Secure.getString(getContentResolver(), Settings.Secure.ALLOW_MOCK_LOCATION).equals("0")){
			return false;
		}
			
		return true;
	}

	private void determinePermissions(Location loc) 
	{
		if(collegeList != null)
		{
			if(permissions != null)
				permissions.clear();
			else
				permissions = new ArrayList<Integer>();
			
			//add IDs to permissions list
			for(College c : collegeList)
			{
				double milesAway = milesAway(loc, c.getLatitude(), c.getLongitude());
				if(milesAway <= MILES_FOR_PERMISSION)
				{
					permissions.add(c.getID());
					Log.i("cfeed","Permissions college data: " + c.toString());
					if(!newPostButton.isShown())
					{
						permissionsProgress.setVisibility(View.GONE);
						newPostButton.setVisibility(View.VISIBLE);
					}
				}
			}
			
			//no nearby colleges found
			if(permissions == null || permissions.size() == 0)
			{
				if(newPostButton.isShown())
				{
					permissionsProgress.setVisibility(View.GONE);
					newPostButton.setVisibility(View.INVISIBLE);
				}
				Toast.makeText(this, "You aren't near a college, you can upvote but nothing else", Toast.LENGTH_LONG).show();
			}
			else	//near a college
			{
				CommentsActivity.setNewPermissionsIfAvailable();
				if(permissions.size() == 1)
				{
					Toast.makeText(this, "You're near " + getCollegeByID(permissions.get(0)).getName(), Toast.LENGTH_LONG).show();
					Toast.makeText(this, "You can upvote, downvote, post, and comment on that college's posts", Toast.LENGTH_LONG).show();
				}
				else
				{
					String toastMessage = "You're near ";
					for(int id : permissions)
					{
						toastMessage += getCollegeByID(id).getName() + " and ";
					}
					//remove last "and"
					toastMessage = toastMessage.substring(0, toastMessage.length() - 5);
					Toast.makeText(this, toastMessage, Toast.LENGTH_LONG).show();
					Toast.makeText(this, "You can upvote, downvote, post, and comment on those colleges' posts", Toast.LENGTH_LONG).show();
				}
				
				if(currentFeedCollegeID == ALL_COLLEGES){
					updateListsForGPS();	//so that GPS icon can be set
				}
				
				if(chooseFeedDialog != null && chooseFeedDialog.isShowing()){
					chooseFeedDialog.populateNearYouList();
				}
			}
		}		
	}
	
    public void goToTopPostsAndScrollToTop() {
        if(viewPager != null){
            viewPager.setCurrentItem(0);
            TopPostFragment.scrollToTop();
        }
    }

	public static void goToNewPostsAndScrollToTop() {
		if(viewPager != null){
			viewPager.setCurrentItem(1);
			NewPostFragment.scrollToTop();
		}
	}

	/**
	 * Implemented using Haversine formula
	 */
	private double milesAway(Location userLoc, double collegeLat, double collegeLon) {
        final int R = 3959; // Radius of the earth in miles
        Double lat1 = userLoc.getLatitude();
        Double lon1 = userLoc.getLongitude();
        Double lat2 = collegeLat;
        Double lon2 = collegeLon;
        Double latDistance = toRad(lat2-lat1);
        Double lonDistance = toRad(lon2-lon1);
        Double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2) + 
                   Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
                   Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        Double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return (R * c);
	}
	
	/**
	 * Helper method for milesAway
	 */
	private static Double toRad(Double value) {
        return value * Math.PI / 180;
    }

	public static College getCollegeByID(Integer id) {
		if(collegeList != null && collegeList.size() > 0)
		{
			for(College c : collegeList)
			{
				if(c.getID() == id)
					return c;
			}
		}
		return null;
	}

	private void updateListsForGPS() 
	{
		if(currentFeedCollegeID == ALL_COLLEGES){
			TopPostFragment.updateList();
			NewPostFragment.updateList();
		}
	}
	
	public void chooseFeedDialog() {
		LayoutInflater inflater = getLayoutInflater();
		View layout = inflater.inflate(R.layout.dialog_choosefeed, null);
        if(chooseFeedDialog == null || !chooseFeedDialog.isShowing()){
            chooseFeedDialog = new ChooseFeedDialog(this, layout);
        }
	}

	public void newPostClicked() 
	{
		if(permissions != null)
		{
			LayoutInflater inflater = getLayoutInflater();
			View postDialogLayout = inflater.inflate(R.layout.dialog_post, null);
			new NewPostDialog(this, postDialogLayout);
		}
	}
	
	public static int getIdByCollegeName(String name) {
		for(College c: collegeList)
		{
			if(c.getName().equals(name))
				return c.getID();
		}
		
		return -1;
	}
	
	public static int getVoteByPostId(int id){
		if(postUpvoteList.contains(id)){
			return 1;
		}else if(postDownvoteList.contains(id)){
			return -1;
		}
		return 0;
	}
	
	public static int getVoteByCommentId(int id){
		if(commentUpvoteList.contains(id)){
			return 1;
		}else if(commentDownvoteList.contains(id)){
			return -1;
		}
		return 0;
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.myContent:
                launchMyContentActivity();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void launchMyContentActivity() {
        Intent intent = new Intent(this, MyContentActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
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
			}
			
			if(fragment != null)
				fragment.setArguments(args);
			return fragment;
		}

		@Override
		public int getCount() {
			return 4;
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
	}

	@Override
	public void onProviderEnabled(String arg0) {
	}

	@Override
	public void onStatusChanged(String arg0, int arg1, Bundle arg2) {
	}
}
