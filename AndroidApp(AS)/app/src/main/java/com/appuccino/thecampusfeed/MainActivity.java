package com.appuccino.thecampusfeed;

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
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.dialogs.AchievementsDialog;
import com.appuccino.thecampusfeed.dialogs.ChooseFeedDialog;
import com.appuccino.thecampusfeed.dialogs.GettingStartedDialog;
import com.appuccino.thecampusfeed.dialogs.NewPostDialog;
import com.appuccino.thecampusfeed.extra.AllCollegeJSONString;
import com.appuccino.thecampusfeed.fragments.MostActiveCollegesFragment;
import com.appuccino.thecampusfeed.fragments.MyCommentsFragment;
import com.appuccino.thecampusfeed.fragments.MyPostsFragment;
import com.appuccino.thecampusfeed.fragments.NewPostFragment;
import com.appuccino.thecampusfeed.fragments.TagFragment;
import com.appuccino.thecampusfeed.fragments.TimeCrunchFragment;
import com.appuccino.thecampusfeed.fragments.TopPostFragment;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.objects.Vote;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.JSONParser;
import com.appuccino.thecampusfeed.utils.ListComparator;
import com.appuccino.thecampusfeed.utils.MyLog;
import com.appuccino.thecampusfeed.utils.NetWorker;
import com.appuccino.thecampusfeed.utils.PopupManager;
import com.appuccino.thecampusfeed.utils.PrefManager;

import net.simonvt.menudrawer.MenuDrawer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MainActivity extends FragmentActivity implements LocationListener
{
    public static MainActivity activity;

    private MenuDrawer menuDrawer;
	ActionBar actionBar;
	ImageView newPostButton;
	ProgressBar permissionsProgress;
	ChooseFeedDialog chooseFeedDialog;
    NewPostDialog newPostDialog;
	
	//final values
    public static final boolean TEST_MODE_ON = true;
    public static final boolean COMPRESSION_TEST_MODE_ON = false;
    public static final boolean ALL_POSTS_HAVE_IMAGES_TEST_MODE_ON = false;
	public static final int ALL_COLLEGES = 0;	//used for permissions
	public static final String PREFERENCE_KEY_COLLEGE_LIST1 = "all_colleges_preference_key1";
	public static final String PREFERENCE_KEY_COLLEGE_LIST2 = "all_colleges_preference_key2";
	public static final double MILES_FOR_PERMISSION = 15.0;
	public static final int LOCATION_TIMEOUT_SECONDS = 10;
	public static final int MIN_POST_LENGTH = 10;
	public static final int MIN_COMMENT_LENGTH = 5;
    //TODO: make sure these values are correct
    public static int TIME_BETWEEN_POSTS = 10;     //in minutes
    public static int TIME_BETWEEN_COMMENTS = 1;  //in minutes
    public static final int TIME_CRUNCH_POST_TIME = 24;
    public static final boolean PICTURE_MODE = true;    //allow users to upload pics, and posts to show them
    public static final int SELECT_PHOTO_INTENT_CODE = 1;

    public Location userLocation;
    private static int selectedMenuItem = 0;
    private int previouslySelectedMenuItem = 0;
	public static boolean locationFound = false;
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
    public static List<Integer> achievementUnlockedList = new ArrayList<Integer>();

    //menu drawer items
    private TextView icon1;
    private TextView icon2;
    private TextView icon3;
    private TextView icon4;
    private TextView icon5;
    private TextView icon6;
    private TextView icon7;
    private TextView icon8;
    private TextView icon9;
    private LinearLayout firstItem;
    private LinearLayout secondItem;
    private LinearLayout thirdItem;
    private LinearLayout fourthItem;
    private LinearLayout fifthItem;
    private LinearLayout sixthItem;
    private LinearLayout seventhItem;
    private LinearLayout eighthItem;
    private LinearLayout ninthItem;

    //Fragments
    public static TopPostFragment topPostFrag;
    public static NewPostFragment newPostFrag;
    TagFragment tagFrag;
    MostActiveCollegesFragment collegeFrag;
    public static MyPostsFragment myPostsFrag;
    public static MyCommentsFragment myCommentsFrag;
    TimeCrunchFragment timeCrunchFrag;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        PrefManager.setup(this);
        activity = this;
        checkForceRequiredUpdate();
		setupApp();
        AchievementsDialog.generateAchievementList();

        if(TEST_MODE_ON){
            Toast.makeText(this, "Test mode is on, using zero for post and comment time limit", Toast.LENGTH_SHORT).show();
            TIME_BETWEEN_POSTS = 0;
            TIME_BETWEEN_COMMENTS = 0;
        }

        collegeListCheckSum = PrefManager.getCollegeListCheckSum();
        lastPostTime = PrefManager.getLastPostTime();
        lastCommentTime = PrefManager.getLastCommentTime();

        checkCollegeListCheckSum();
        TimeCrunchFragment.checkTimeCrunchHoursLeft(this);
        //if Time Crunch is active, set location to it, otherwise get location like normal
        if(PrefManager.getBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false)){
            setupTimeCrunchLocation();
        } else {
            getLocation();
        }
        PopupManager.run(this);
		Log.i("cfeed", "APPSETUP: onCreate");

        setupMenuDrawerViews();
	}

    private void checkForceRequiredUpdate() {
        PackageInfo pInfo = null;
        try {
            pInfo = getPackageManager().getPackageInfo(getPackageName(), 0);
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        String currentAppVersion = pInfo.versionName;
        MyLog.i("Current app version: " + currentAppVersion);
        new NetWorker.CheckForceRequiredUpdated(currentAppVersion, this).execute();
    }

    @Override
    protected void onResume() {
        super.onResume();

        //open post if app opened from clicking URL, open that post
        Intent i = getIntent();
        int urlPostID = i.getIntExtra(SplashActivity.URL_POST_ID, -1);
        if(urlPostID >= 0){
            openPostFromURLClick(urlPostID);
        }
    }

    private void openPostFromURLClick(int urlPostID) {
        getIntent().putExtra(SplashActivity.URL_POST_ID, -1);
        Intent intent = new Intent(this, CommentsActivity.class);
        intent.putExtra("POST_ID", urlPostID);
        intent.putExtra("FROM_URL", true);
        //intent.putExtra("COLLEGE_ID", post.getCollegeID());
        intent.putExtra("SECTION_NUMBER", 0);

        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    //this is called when orientation changes
	@Override
	public void onConfigurationChanged(Configuration newConfig)
	{
	    super.onConfigurationChanged(newConfig);

	}

	private void setupApp(){
        FontManager.setup(this);
        menuDrawer = MenuDrawer.attach(this);
        menuDrawer.setContentView(R.layout.activity_main);
        menuDrawer.setMenuView(R.layout.menu_drawer);
		

		setupActionbar();

		postVoteList = PrefManager.getPostVoteList();
		commentVoteList = PrefManager.getCommentVoteList();
		flagList = PrefManager.getFlagList();
        myPostsList = PrefManager.getMyPostsList();
        myCommentsList = PrefManager.getMyCommentsList();
        achievementUnlockedList = PrefManager.getAchievementUnlockedList();

		permissionsProgress = (ProgressBar)findViewById(R.id.permissionsLoadingIcon);
        //set progressbar as white
        //permissionsProgress.getIndeterminateDrawable().setColorFilter(new LightingColorFilter(getResources().getColor(R.color.white), getResources().getColor(R.color.white)));
		newPostButton = (ImageView)findViewById(R.id.newPostButton);
		newPostButton.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				newPostClicked();
			}
		});

        ImageView mainLogo = (ImageView)findViewById(R.id.mainLogo);
        mainLogo.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if(menuDrawer != null) {
                    menuDrawer.toggleMenu();
                }
            }
        });
	}

    //toggle menu on hardware button menu press
    @Override
    public boolean onKeyDown(int keycode, KeyEvent e) {
        switch(keycode) {
            case KeyEvent.KEYCODE_MENU:
                if(menuDrawer != null)
                    menuDrawer.toggleMenu();
                return true;
        }

        return super.onKeyDown(keycode, e);
    }

    private void setupMenuDrawerViews() {
        icon1 = (TextView)findViewById(R.id.icon1);
        icon2 = (TextView)findViewById(R.id.icon2);
        icon3 = (TextView)findViewById(R.id.icon3);
        icon4 = (TextView)findViewById(R.id.icon4);
        icon5 = (TextView)findViewById(R.id.icon5);
        icon6 = (TextView)findViewById(R.id.icon6);
        icon7 = (TextView)findViewById(R.id.icon7);
        icon8 = (TextView)findViewById(R.id.icon8);
        icon9 = (TextView)findViewById(R.id.icon9);
        firstItem = (LinearLayout)findViewById(R.id.firstItem);
        secondItem = (LinearLayout)findViewById(R.id.secondItem);
        thirdItem = (LinearLayout)findViewById(R.id.thirdItem);
        fourthItem = (LinearLayout)findViewById(R.id.fourthItem);
        fifthItem = (LinearLayout)findViewById(R.id.fifthItem);
        sixthItem = (LinearLayout)findViewById(R.id.sixthItem);
        seventhItem = (LinearLayout)findViewById(R.id.seventhItem);
        eighthItem = (LinearLayout)findViewById(R.id.eighthItem);
        ninthItem = (LinearLayout)findViewById(R.id.ninthItem);

        OnClickListener menuClick = new OnClickListener() {
            @Override
            public void onClick(View view) {
                previouslySelectedMenuItem = selectedMenuItem;

                if(view == firstItem){
                    selectedMenuItem = 0;
                } else if(view == secondItem){
                    selectedMenuItem = 1;
                } else if(view == thirdItem){
                    selectedMenuItem = 2;
                } else if(view == fourthItem){
                    selectedMenuItem = 3;
                } else if(view == fifthItem){
                    selectedMenuItem = 4;
                } else if(view == sixthItem){
                    selectedMenuItem = 5;
                } else if(view == seventhItem){
                    selectedMenuItem = 6;
                } else if(view == eighthItem){
                    selectedMenuItem = 7;
                } else if(view == ninthItem){
                    selectedMenuItem = 8;
                }

                menuItemSelected();
            }
        };

        firstItem.setOnClickListener(menuClick);
        secondItem.setOnClickListener(menuClick);
        thirdItem.setOnClickListener(menuClick);
        fourthItem.setOnClickListener(menuClick);
        fifthItem.setOnClickListener(menuClick);
        sixthItem.setOnClickListener(menuClick);
        seventhItem.setOnClickListener(menuClick);
        eighthItem.setOnClickListener(menuClick);
        ninthItem.setOnClickListener(menuClick);

        menuItemSelected();
    }

    private void menuItemSelected() {
        //selected Help
        if(selectedMenuItem == 7) {
            new GettingStartedDialog(this, "Help");
            selectedMenuItem = previouslySelectedMenuItem;
        } else if(selectedMenuItem == 8) {
            emailForFeedback();
            selectedMenuItem = previouslySelectedMenuItem;
        } else {
            firstItem.setBackgroundResource(R.drawable.postbuttonclick);
            secondItem.setBackgroundResource(R.drawable.postbuttonclick);
            thirdItem.setBackgroundResource(R.drawable.postbuttonclick);
            fourthItem.setBackgroundResource(R.drawable.postbuttonclick);
            fifthItem.setBackgroundResource(R.drawable.postbuttonclick);
            sixthItem.setBackgroundResource(R.drawable.postbuttonclick);
            seventhItem.setBackgroundResource(R.drawable.postbuttonclick);
            eighthItem.setBackgroundResource(R.drawable.postbuttonclick);
            icon1.setTextColor(getResources().getColor(R.color.lightblue));
            icon2.setTextColor(getResources().getColor(R.color.lightblue));
            icon3.setTextColor(getResources().getColor(R.color.lightblue));
            icon4.setTextColor(getResources().getColor(R.color.lightblue));
            icon5.setTextColor(getResources().getColor(R.color.lightblue));
            icon6.setTextColor(getResources().getColor(R.color.lightblue));
            icon7.setTextColor(getResources().getColor(R.color.lightblue));
            icon8.setTextColor(getResources().getColor(R.color.lightblue));
            icon9.setTextColor(getResources().getColor(R.color.lightblue));

            android.support.v4.app.FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

            switch (selectedMenuItem){
                case 0:
                    firstItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon1.setTextColor(getResources().getColor(R.color.white));
                    if(topPostFrag == null){    //so that nothing happens except close the menu if nothing is showing
                        topPostFrag = new TopPostFragment(this);
                        ft.replace(R.id.fragmentContainer, topPostFrag).commit();
                        makeFragsNull(0);
                    }
                    break;
                case 1:
                    secondItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon2.setTextColor(getResources().getColor(R.color.white));
                    if(newPostFrag == null){
                        newPostFrag = new NewPostFragment(this);
                        ft.replace(R.id.fragmentContainer, newPostFrag).commit();
                        makeFragsNull(1);
                    }
                    break;
                case 2:
                    thirdItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon3.setTextColor(getResources().getColor(R.color.white));
                    if(tagFrag == null){
                        tagFrag = new TagFragment(this);
                        ft.replace(R.id.fragmentContainer, tagFrag).commit();
                        makeFragsNull(2);
                    }
                    break;
                case 3:
                    fourthItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon4.setTextColor(getResources().getColor(R.color.white));
                    if(collegeFrag == null){
                        collegeFrag = new MostActiveCollegesFragment(this);
                        ft.replace(R.id.fragmentContainer, collegeFrag).commit();
                        makeFragsNull(3);
                    }
                    break;
                case 4:
                    fifthItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon5.setTextColor(getResources().getColor(R.color.white));
                    if(myPostsFrag == null){
                        myPostsFrag = new MyPostsFragment(this);
                        ft.replace(R.id.fragmentContainer, myPostsFrag).commit();
                        makeFragsNull(4);
                    }
                    break;
                case 5:
                    sixthItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon6.setTextColor(getResources().getColor(R.color.white));
                    if(myCommentsFrag == null){
                        myCommentsFrag = new MyCommentsFragment(this);
                        ft.replace(R.id.fragmentContainer, myCommentsFrag).commit();
                        makeFragsNull(5);
                    }
                    break;
                case 6:
                    seventhItem.setBackgroundColor(getResources().getColor(R.color.blue));
                    icon7.setTextColor(getResources().getColor(R.color.white));
                    if(timeCrunchFrag == null){
                        timeCrunchFrag = new TimeCrunchFragment(this);
                        ft.replace(R.id.fragmentContainer, timeCrunchFrag).commit();
                        makeFragsNull(6);
                    }
                    break;
            }
        }

        menuDrawer.closeMenu();
    }

    private void emailForFeedback() {
        Intent send = new Intent(Intent.ACTION_SENDTO);
        String uriText = "mailto:" + Uri.encode("feedback@thecampusfeed.com") +
                "?subject=" + Uri.encode("Android App Feedback") +
                "&body=" + Uri.encode("Please enter your feedback here:\n" +
                "\n");
        Uri uri = Uri.parse(uriText);

        send.setData(uri);
        startActivity(Intent.createChooser(send, "Give Feedback"));
    }

    /**
     * Null each fragment except the one given in the parameter
     */
    private void makeFragsNull(int i) {
        if(i != 0){
            topPostFrag = null;
        }
        if(i != 1){
            newPostFrag = null;
        }
        if(i != 2){
            tagFrag = null;
        }
        if(i != 3){
            collegeFrag = null;
        }
        if(i != 4){
            myPostsFrag = null;
        }
        if(i != 5){
            myCommentsFrag = null;
        }
        if(i != 6){
            timeCrunchFrag = null;
        }
    }

    public void addNewPostToListAndMyContent(Post post, Context c){
        //instantly add to new posts
        if(currentFeedCollegeID == ALL_COLLEGES || currentFeedCollegeID == post.getCollegeID()){
            if(newPostFrag != null){
                newPostFrag.postList.add(0, post);
                newPostFrag.updateList();
            } else {
                goToNewPostsAndScrollToTop(post.getCollegeID());
            }
            Log.i("cfeed","New My Posts list is of size " + myPostsList.size());
        }
        myPostsList.add(post.getID());
        PrefManager.putMyPostsList(myPostsList);
        lastPostTime = Calendar.getInstance();
        PrefManager.putLastPostTime(lastPostTime);
    }

    private void checkCollegeListCheckSum(){
        setupCollegeList();
        new NetWorker.CollegeListCheckSumTask().execute();
    }

    public static void updateCollegeList(String checkSumVersion){
        new NetWorker.GetFullCollegeListTask(checkSumVersion, MainActivity.activity).execute(new NetWorker.PostSelector());
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
		//actionBar.setIcon(R.drawable.logofake);
        actionBar.setDisplayShowHomeEnabled(false);
        //actionBar.setDisplayHomeAsUpEnabled(false);
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
            if(v.commentID == commentID){
                return v;
            }
        }
        return null;
    }

    public static void removePostVoteByPostID(int postID){
        //using iterator to get rid of concurrentmodificationexception
        for(Iterator<Vote> it = postVoteList.iterator(); it.hasNext();){
            Vote vote = it.next();
            if(vote.postID == postID){
                it.remove();
                break;
            }
        }
    }

    public static void removeCommentVoteByCommentID(int commentID){
        //using iterator to get rid of concurrentmodificationexception
        for(Iterator<Vote> it = commentVoteList.iterator(); it.hasNext();){
            Vote vote = it.next();
            if(vote.commentID == commentID){
                it.remove();
                break;
            }
        }
    }

    public static void setCommentVoteID(int voteID, int commentID){
        for(Vote v : commentVoteList){
            if(v.commentID == commentID){
                v.setVoteID(voteID);
            }
        }

        PrefManager.putCommentVoteList(MainActivity.commentVoteList);
    }

    public static void setPostVoteID(int voteID, int postID){
        for(Vote v : postVoteList){
            if(v.postID == postID){
                v.setVoteID(voteID);
            }
        }

        PrefManager.putPostVoteList(MainActivity.postVoteList);
    }

	public void changeFeed(int id) {
		Log.i("cfeed","Changing to feed with ID " + id);
		currentFeedCollegeID = id;
		if(id != ALL_COLLEGES)
		{
			showPermissionsToast();
		}
			
		PrefManager.putInt(PrefManager.LAST_FEED, id);

        if(topPostFrag != null){
            topPostFrag.changeFeed(id);
        } else if(newPostFrag != null) {
            newPostFrag.changeFeed(id);
        } else if(tagFrag != null) {
            tagFrag.changeFeed(id);
        }
	}

    public void showFirstTimeMessages(){
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        TopPostFragment.disableChooseFeedButton();
        final RelativeLayout overlay = (RelativeLayout)findViewById(R.id.getting_started_overlay);
        overlay.setVisibility(View.VISIBLE);
        ImageView button = (ImageView)findViewById(R.id.ok_button);
        button.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                overlay.setVisibility(View.GONE);
                if(collegeList != null){
                    chooseFeedDialog();
                    TopPostFragment.reenableChooseFeedButton();
                }
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
            }
        });
    }
	
	private void showPermissionsToast() 
	{
        try{
            String collegeName = getCollegeByID(currentFeedCollegeID).getName();
            if(hasPermissions(currentFeedCollegeID))
            {
                Toast.makeText(this, "Since you are near " + collegeName + ", you can upvote, downvote, post, and comment", Toast.LENGTH_LONG).show();
            }
            else
            {
                Toast.makeText(this, "Since you aren't near " + collegeName + ", you can only upvote", Toast.LENGTH_LONG).show();
            }
        } catch (Exception e){
            e.printStackTrace();
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
	
	public void getLocation(){
        MyLog.i("Getting location normally");
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
                                        locationFound = true;
										permissionsProgress.setVisibility(View.GONE);
										newPostButton.setVisibility(View.GONE);
                                        if(chooseFeedDialog != null && chooseFeedDialog.isShowing()){
                                            chooseFeedDialog.populateNearYouList(true);
                                        }
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

    //return if successful
    public boolean setupTimeCrunchLocation(){

        permissionsProgress.setVisibility(View.GONE);
        newPostButton.setVisibility(View.VISIBLE);
        locationFound = true;
        userLocation = new Location("");
        College homeCollege = getCollegeByID(PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, 0));
        if(homeCollege != null){
            Toast.makeText(this, "Time Crunch is active, your location is set to " + homeCollege.getName(), Toast.LENGTH_LONG).show();
            userLocation.setLatitude(homeCollege.getLatitude());
            userLocation.setLongitude(homeCollege.getLongitude());
            permissions.clear();
            permissions.add(homeCollege.getID());

            if(chooseFeedDialog != null && chooseFeedDialog.isShowing()){
                chooseFeedDialog.populateNearYouList(true);
            }
            return true;
        } else {
            Toast.makeText(this, "Error retrieving Time Crunch college. Make a post to set your home college.", Toast.LENGTH_LONG).show();
            newPostButton.setVisibility(View.GONE);
            getLocation();
            return false;
        }
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

	public void determinePermissions(Location loc)
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
					newPostButton.setVisibility(View.INVISIBLE);
				}
                permissionsProgress.setVisibility(View.GONE);
                if(chooseFeedDialog != null && chooseFeedDialog.isShowing()){
                    chooseFeedDialog.populateNearYouList(true);
                }
                //only show toast if it isn't the very first time running app
                if(PrefManager.getInt(PrefManager.APP_RUN_COUNT, 0) > 1) {
                    Toast.makeText(this, "You aren't near a college, you can upvote but nothing else", Toast.LENGTH_LONG).show();
                }
			}
			else	//near a college
			{
				CommentsActivity.setNewPermissionsIfAvailable();
				if(permissions.size() == 1)
				{
                    //only show toast if it isn't the very first time running app
                    if(PrefManager.getInt(PrefManager.APP_RUN_COUNT, 0) > 1){
                        Toast.makeText(this, "You're near " + getCollegeByID(permissions.get(0)).getName(), Toast.LENGTH_LONG).show();
                        Toast.makeText(this, "You can upvote, downvote, post, and comment on that college's posts", Toast.LENGTH_LONG).show();
                    }
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
                    //only show toast if it isn't the very first time running app
                    if(PrefManager.getInt(PrefManager.APP_RUN_COUNT, 0) > 1) {
                        Toast.makeText(this, toastMessage, Toast.LENGTH_LONG).show();
                        Toast.makeText(this, "You can upvote, downvote, post, and comment on those colleges' posts", Toast.LENGTH_LONG).show();
                    }
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
	
    public void goToTopPostsAndScrollToTop() {
        selectedMenuItem = 0;
        menuItemSelected();
    }

	public void goToNewPostsAndScrollToTop(int feedID) {
        //if on another feed, switch to correct feed before going to New Posts
        if(currentFeedCollegeID != MainActivity.ALL_COLLEGES && currentFeedCollegeID != feedID){
            currentFeedCollegeID = feedID;
        }
        selectedMenuItem = 1;
        menuItemSelected();
        if(newPostFrag != null){
            newPostFrag.changeFeed(currentFeedCollegeID);
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
            if(topPostFrag != null){
                topPostFrag.updateList();
            } else if (newPostFrag != null){
                newPostFrag.updateList();
            }
		}
	}
	
	public void chooseFeedDialog() {
        Log.i("cfeed","Creating Choose Feed dialog from MainActivity");
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
                if(newPostDialog == null || !newPostDialog.isShowing()){
                    LayoutInflater inflater = getLayoutInflater();
                    View postDialogLayout = inflater.inflate(R.layout.dialog_post, null);
                    newPostDialog = new NewPostDialog(this, this, postDialogLayout);
                }
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

    public static String[] parseTagsWithRegex(String message) {
        List<String> returnList = new ArrayList<String>();
        Matcher m = Pattern.compile("#[A-Za-z0-9_]{3,139}").matcher(message);
        while (m.find()){
            returnList.add(m.group());
        }

        return returnList.toArray(new String[returnList.size()]);
    }

//    public static boolean containsSymbols(String text) {
//        if(text.contains("!") ||
//                text.contains("$") ||
//                text.contains("%") ||
//                text.contains("^") ||
//                text.contains("&") ||
//                text.contains("*") ||
//                text.contains("+") ||
//                text.contains(".") ||
//                text.contains(",") ||
//                text.contains("#")){
//            return true;
//        }
//        return false;
//    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent imageReturnedIntent){
        super.onActivityResult(requestCode, resultCode, imageReturnedIntent);

        switch(requestCode) {
            case SELECT_PHOTO_INTENT_CODE:
                if(resultCode == RESULT_OK && newPostDialog != null && newPostDialog.isShowing()){
                    final Uri imageUri = imageReturnedIntent.getData();
                    newPostDialog.setImageChosen(imageUri);
                } else if (resultCode != RESULT_CANCELED){
                    Toast.makeText(this, "Failed to upload image, please try again.", Toast.LENGTH_LONG).show();
                } else {    //user cancelled image picking
                    if(newPostDialog != null && newPostDialog.isShowing()){
                        newPostDialog.setViewsOnCancel();
                    }
                }
        }
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
        userLocation = loc;
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
