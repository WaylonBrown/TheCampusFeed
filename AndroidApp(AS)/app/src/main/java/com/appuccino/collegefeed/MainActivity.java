package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.content.Context;
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
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.PagerAdapter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
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
import com.appuccino.collegefeed.objects.Vote;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.JSONParser;
import com.appuccino.collegefeed.utils.ListComparator;
import com.appuccino.collegefeed.utils.NetWorker;
import com.appuccino.collegefeed.utils.PopupManager;
import com.appuccino.collegefeed.utils.PrefManager;

import net.simonvt.menudrawer.MenuDrawer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends FragmentActivity implements LocationListener
{
    private MenuDrawer menuDrawer;
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
    public static final int TIME_BETWEEN_POSTS = 5;     //in minutes
    public static final int TIME_BETWEEN_COMMENTS = 1;  //in minutes

    private int selectedMenuItem = 0;
	boolean locationFound = false;
	public static LocationManager mgr;
	public static int currentFeedCollegeID;	//0 if viewing all colleges
    public static String collegeListCheckSum;
    public static Calendar lastPostTime;
    public static Calendar lastCommentTime;
	public static ArrayList<Integer> permissions = new ArrayList<Integer>();	//length of 0 or null = no perms, otherwise the college ID is the perm IDs
	public static ArrayList<College> collegeList = new ArrayList<College>();
	
	public static List<Vote> postVoteList = new ArrayList<Vote>();
	public static List<Vote> commentVoteList = new ArrayList<Vote>();
    public static List<Integer> flagList = new ArrayList<Integer>();
    public static List<Integer> myPostsList = new ArrayList<Integer>();
    public static List<Integer> myCommentsList = new ArrayList<Integer>();

    //menu drawer items
    private TextView menuTopPosts;
    private TextView menuNewPosts;
    private TextView menuTags;
    private TextView menuColleges;
    private TextView menuMyPosts;
    private TextView menuMyComments;
    private TextView menuHelp;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        PrefManager.setup(this);
		setupApp();

        collegeListCheckSum = PrefManager.getCollegeListCheckSum();
        lastPostTime = PrefManager.getLastPostTime();
        lastCommentTime = PrefManager.getLastCommentTime();

        checkCollegeListCheckSum();
		getLocation();
        PopupManager.run(this);
		Log.i("cfeed", "APPSETUP: onCreate");

        setupMenuDrawerViews();
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
        menuDrawer = MenuDrawer.attach(this);
        menuDrawer.setContentView(R.layout.activity_main);
        menuDrawer.setMenuView(R.layout.menu_drawer);
		
		FontManager.setup(this);
		setupActionbar();

		postVoteList = PrefManager.getPostVoteList();
		commentVoteList = PrefManager.getCommentVoteList();
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
	}

    private void setupMenuDrawerViews() {
        menuTopPosts = (TextView)findViewById(R.id.topPostsMenuText);
        menuNewPosts = (TextView)findViewById(R.id.newPostsMenuText);
        menuTags = (TextView)findViewById(R.id.tagsMenuText);
        menuColleges = (TextView)findViewById(R.id.collegesMenuText);
        menuMyPosts = (TextView)findViewById(R.id.myPostsMenuText);
        menuMyComments = (TextView)findViewById(R.id.myCommentsMenuText);
        menuHelp = (TextView)findViewById(R.id.helpMenuText);

        menuTopPosts.setTypeface(FontManager.light);
        menuNewPosts.setTypeface(FontManager.light);
        menuTags.setTypeface(FontManager.light);
        menuColleges.setTypeface(FontManager.light);
        menuMyPosts.setTypeface(FontManager.light);
        menuMyComments.setTypeface(FontManager.light);
        menuHelp.setTypeface(FontManager.light);

        OnClickListener menuClick = new OnClickListener() {
            @Override
            public void onClick(View view) {
                if(view == menuTopPosts){
                    selectedMenuItem = 0;
                } else if(view == menuNewPosts){
                    selectedMenuItem = 1;
                } else if(view == menuTags){
                    selectedMenuItem = 2;
                } else if(view == menuColleges){
                    selectedMenuItem = 3;
                } else if(view == menuMyPosts){
                    selectedMenuItem = 4;
                } else if(view == menuMyComments){
                    selectedMenuItem = 5;
                } else if(view == menuHelp){
                    selectedMenuItem = 6;
                }

                menuItemSelected();
            }
        };

        menuTopPosts.setOnClickListener(menuClick);
        menuNewPosts.setOnClickListener(menuClick);
        menuTags.setOnClickListener(menuClick);
        menuColleges.setOnClickListener(menuClick);
        menuMyPosts.setOnClickListener(menuClick);
        menuMyComments.setOnClickListener(menuClick);
        menuHelp.setOnClickListener(menuClick);

        menuItemSelected();
    }

    private void menuItemSelected() {
        menuTopPosts.setBackgroundResource(R.drawable.postbuttonclick);
        menuNewPosts.setBackgroundResource(R.drawable.postbuttonclick);
        menuTags.setBackgroundResource(R.drawable.postbuttonclick);
        menuColleges.setBackgroundResource(R.drawable.postbuttonclick);
        menuMyPosts.setBackgroundResource(R.drawable.postbuttonclick);
        menuMyComments.setBackgroundResource(R.drawable.postbuttonclick);
        menuHelp.setBackgroundResource(R.drawable.postbuttonclick);

        android.support.v4.app.FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

        switch (selectedMenuItem){
            case 0:
                menuTopPosts.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new TopPostFragment(this)).commit();
                break;
            case 1:
                menuNewPosts.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new NewPostFragment(this)).commit();
                break;
            case 2:
                menuTags.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new TagFragment(this)).commit();
                break;
            case 3:
                menuColleges.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new MostActiveCollegesFragment(this)).commit();
                break;
            case 4:
                menuMyPosts.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new NewPostFragment(this)).commit();
                break;
            case 5:
                menuMyComments.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new NewPostFragment(this)).commit();
                break;
            default:
                menuHelp.setBackgroundColor(getResources().getColor(R.color.blue));
                ft.replace(R.id.fragmentContainer, new NewPostFragment(this)).commit();
                break;
        }

        menuDrawer.closeMenu();
    }

    public static void addNewPostToListAndMyContent(Post post, Context c){
        //instantly add to new posts
        if(currentFeedCollegeID == ALL_COLLEGES || currentFeedCollegeID == post.getCollegeID()){
            NewPostFragment.postList.add(0, post);
            myPostsList.add(post.getID());
            NewPostFragment.updateList();
            MainActivity.goToNewPostsAndScrollToTop(c);

            Log.i("cfeed","New My Posts list is of size " + myPostsList.size());
        }
        PrefManager.putMyPostsList(myPostsList);
        lastPostTime = Calendar.getInstance();
        PrefManager.putLastPostTime(lastPostTime);
    }

    private void checkCollegeListCheckSum(){
        setupCollegeList();
        new NetWorker.CollegeListCheckSumTask().execute();
    }

    public static void updateCollegeList(String checkSumVersion){
        new NetWorker.GetFullCollegeListTask(checkSumVersion).execute(new NetWorker.PostSelector());
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
        actionBar.setDisplayShowHomeEnabled(false);
        actionBar.setDisplayHomeAsUpEnabled(false);
	}

    public static int getVoteByPostId(int postID){
        for(Vote v : postVoteList){
            if(v.postID == postID){
                if(v.upvote){
                    return 1;
                } else {
                    return -1;
                }
            }
        }
        return 0;
    }

    public static int getVoteByCommentId(int commentID){
        for(Vote v : commentVoteList){
            if(v.commentID == commentID){
                if(v.upvote){
                    return 1;
                } else {
                    return -1;
                }
            }
        }
        return 0;
    }

    public static Vote voteObjectFromPostID(int postID){
        for(Vote v : postVoteList){
            if(v.postID == postID){
                return v;
            }
        }
        return null;
    }

    public static Vote voteObjectFromCommentID(int commentID){
        for(Vote v : commentVoteList){
            if(v.postID == commentID){
                return v;
            }
        }
        return null;
    }

    public static void removePostVoteByPostID(int postID){
        for(Vote v : postVoteList){
            if(v.postID == postID){
                postVoteList.remove(v);
                break;
            }
        }
    }

    public static void removeCommentVoteByCommentID(int commentID){
        for(Vote v : commentVoteList){
            if(v.commentID == commentID){
                commentVoteList.remove(v);
                break;
            }
        }
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
        menuDrawer.openMenu();
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
					chooseFeedDialog.populateNearYouList(true);
				}
			}
		}
	}
	
    public void goToTopPostsAndScrollToTop(Context c) {
//        if(viewPager != null){
//            viewPager.setCurrentItem(0);
//            TopPostFragment.scrollToTop();
//        }
        Toast.makeText(c, "Implement goToTopPostsAndScrollToTop", Toast.LENGTH_LONG).show();
    }

	public static void goToNewPostsAndScrollToTop(Context c) {
//		if(viewPager != null){
//			viewPager.setCurrentItem(1);
//			NewPostFragment.scrollToTop();
//		}
        Toast.makeText(c, "Implement goToNewPostsAndScrollToTop", Toast.LENGTH_LONG).show();
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
            if(haventPostedInXMinutes()){
                LayoutInflater inflater = getLayoutInflater();
                View postDialogLayout = inflater.inflate(R.layout.dialog_post, null);
                new NewPostDialog(this, postDialogLayout);
            } else {
                Toast.makeText(this, "Sorry, you can only post once every " + MainActivity.TIME_BETWEEN_POSTS + " minutes.", Toast.LENGTH_LONG).show();
            }

		}
	}

    private boolean haventPostedInXMinutes(){
        Calendar now = Calendar.getInstance();
        now.add(Calendar.MINUTE, -TIME_BETWEEN_POSTS);
        if(lastPostTime != null && now.before(lastPostTime)){
            return false;
        }
        return true;
    }
	
	public static int getIdByCollegeName(String name) {
		for(College c: collegeList)
		{
			if(c.getName().equals(name))
				return c.getID();
		}
		
		return -1;
	}

    public static boolean containsSymbols(String text) {
        if(text.contains("!") ||
                text.contains("$") ||
                text.contains("%") ||
                text.contains("^") ||
                text.contains("&") ||
                text.contains("*") ||
                text.contains("+") ||
                text.contains(".") ||
                text.contains(",") ||
                text.contains("#")){
            return true;
        }
        return false;
    }

//	@Override
//	public boolean onCreateOptionsMenu(Menu menu) {
//		// Inflate the menu; this adds items to the action bar if it is present.
//		getMenuInflater().inflate(R.menu.main, menu);
//		return true;
//	}

//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//        // Handle item selection
//        switch (item.getItemId()) {
//            case R.id.myContent:
//                launchMyContentActivity();
//                return true;
//            case R.id.menu_help:
//                new GettingStartedDialog(this, "Help");
//                return true;
//            default:
//                return super.onOptionsItemSelected(item);
//        }
//    }

//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//        switch (item.getItemId()) {
//            case android.R.id.home:
//                menuDrawer.toggleMenu();
//                return true;
//        }
//
//        return super.onOptionsItemSelected(item);
//    }

    private void launchMyContentActivity() {
        Intent intent = new Intent(this, MyContentActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    public void onBackPressed() {
        if(menuDrawer != null){
            final int drawerState = menuDrawer.getDrawerState();
            if (drawerState == MenuDrawer.STATE_OPEN || drawerState == MenuDrawer.STATE_OPENING) {
                menuDrawer.closeMenu();
                return;
            }
        }

        super.onBackPressed();
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
