package com.appuccino.collegefeed.fragments;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.animation.TranslateAnimation;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.CommentsActivity;
import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.PostListAdapter;
import com.appuccino.collegefeed.extra.QuickReturnListView;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.GetPostsTask;
import com.appuccino.collegefeed.utils.NetWorker.PostSelector;
import com.appuccino.collegefeed.utils.PrefManager;

import java.util.ArrayList;
import java.util.List;

import uk.co.senab.actionbarpulltorefresh.library.ActionBarPullToRefresh;
import uk.co.senab.actionbarpulltorefresh.library.PullToRefreshLayout;
import uk.co.senab.actionbarpulltorefresh.library.listeners.OnRefreshListener;

public class TopPostFragment extends Fragment implements OnRefreshListener
{
	static MainActivity mainActivity;
	public static List<Post> postList;
	static PostListAdapter listAdapter;
	static QuickReturnListView list;
	private static int currentFeedID;
	//library objects
	static ProgressBar loadingSpinner;
	private static PullToRefreshLayout pullToRefresh;
	View rootView;
	private static ProgressBar lazyLoadingFooterSpinner;
	public static int currentPageNumber = 1;
	public static boolean endOfListReached = false;
    private static boolean isLoadingMorePosts = false;
	static View lazyFooterView;
	static View footerSpace;
    static TextView pullDownText;
	
	//values for footer
	static LinearLayout scrollAwayBottomView;
	private static int mQuickReturnHeight;
	private static final int STATE_ONSCREEN = 0;
	private static final int STATE_OFFSCREEN = 1;
	private static final int STATE_RETURNING = 2;
	private static int mState = STATE_ONSCREEN;
	private static int mScrollY;
	private static int mMinRawY = 0;
	private static TranslateAnimation anim;
	static TextView collegeNameBottom;

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
		rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		list = (QuickReturnListView)rootView.findViewById(R.id.fragmentListView);
		loadingSpinner = (ProgressBar)rootView.findViewById(R.id.loadingSpinner);
		scrollAwayBottomView = (LinearLayout)rootView.findViewById(R.id.footer);
        pullDownText = (TextView)rootView.findViewById(R.id.pullDownText);

        pullDownText.setTypeface(FontManager.light);
		setupBottomViewUI();
					
		// Now give the find the PullToRefreshLayout and set it up
        pullToRefresh = (PullToRefreshLayout) rootView.findViewById(R.id.pullToRefresh);
        ActionBarPullToRefresh.from(getActivity())
//                .options(Options.create()
//                        .headerLayout(R.layout.pull_to_refresh_header)
//                        .headerTransformer(new CustomisedHeaderTransformer())
//                        .build())
                .allChildrenArePullable()
                .listener(this)
                .setup(pullToRefresh);
		
		//if doesnt have header and footer, add them
		if(list.getHeaderViewsCount() == 0)
		{
			//for card UI
			View headerSpace = new View(getActivity());
			headerSpace.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addHeaderView(headerSpace, null, false);
		}
		
		addLazyFooterView();
		
		if(mainActivity != null)
		{
            if(MainActivity.currentFeedCollegeID == 0){
                int lastViewedFeed = PrefManager.getInt(PrefManager.LAST_FEED, -1);
                if(lastViewedFeed == -1){
                    mainActivity.showFirstTimeMessages();
                    lastViewedFeed = 0;
                    PrefManager.putInt(PrefManager.LAST_FEED, 0);
                }
                changeFeed(lastViewedFeed);
            } else {
                changeFeed(MainActivity.currentFeedCollegeID);
            }
		}
		listAdapter = new PostListAdapter(getActivity(), R.layout.list_row_collegepost, postList, 0, currentFeedID);
		if(list != null)
			list.setAdapter(listAdapter);	
		else
			Log.e("cfeed", "TopPostFragment list adapter wasn't set.");

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

    public void onResume(){
        super.onResume();
        setupFooterListView();
    }
	
	private static void addLazyFooterView() {
		if(list.getFooterViewsCount() == 0){
			lazyFooterView =  ((LayoutInflater)mainActivity.getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.list_lazy_loading_footer, null, false);
	        list.addFooterView(lazyFooterView);
	        lazyLoadingFooterSpinner = (ProgressBar)lazyFooterView.findViewById(R.id.lazyFooterSpinner);
		}
	}

	private void setupBottomViewUI() {
		collegeNameBottom = (TextView)rootView.findViewById(R.id.collegeNameBottomText);
		TextView showingText = (TextView)rootView.findViewById(R.id.showingFeedText);
		TextView chooseText = (TextView)rootView.findViewById(R.id.chooseText);
		
		collegeNameBottom.setTypeface(FontManager.light);
		showingText.setTypeface(FontManager.medium);
		chooseText.setTypeface(FontManager.light);
		
		chooseText.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				mainActivity.chooseFeedDialog();
			}
		});
		
	}

	public static void setupFooterListView() {
        Log.i("cfeed","list scrollable1: " + willListScroll());
		if(willListScroll()){
			list.getViewTreeObserver().addOnGlobalLayoutListener(
				new ViewTreeObserver.OnGlobalLayoutListener() {
					@Override
					public void onGlobalLayout() {
						mQuickReturnHeight = scrollAwayBottomView.getHeight();
						list.computeScrollY();
					}
			});
			
			list.setOnScrollListener(new OnScrollListener() {
				@SuppressLint("NewApi")
				@Override
				public void onScroll(AbsListView view, int firstVisibleItem,
						int visibleItemCount, int totalItemCount) {

					handleScrollAwayBottomViewOnScroll();
					if (list.getLastVisiblePosition() == list.getAdapter().getCount() -3 &&
							!endOfListReached && !isLoadingMorePosts)
					{
						loadMorePosts();
					}else if (endOfListReached){
						replaceFooterBecauseEndOfList();
					}
				}

				@Override
				public void onScrollStateChanged(AbsListView view, int scrollState) {
				}
			});
		}else{				//don't let bottom part move if the list isn't scrollable
			list.getViewTreeObserver().addOnGlobalLayoutListener(
				new ViewTreeObserver.OnGlobalLayoutListener() {
					@Override
					public void onGlobalLayout() {
						//do nothing
					}
			});
			
			list.setOnScrollListener(new OnScrollListener() {
				@SuppressLint("NewApi")
				@Override
				public void onScroll(AbsListView view, int firstVisibleItem,
						int visibleItemCount, int totalItemCount) {
					//do nothing
				}
				@Override
				public void onScrollStateChanged(AbsListView view, int scrollState) {
				}
			});
		}
		
	}

	protected static void replaceFooterBecauseEndOfList() {
        isLoadingMorePosts = false;
		if(list.getFooterViewsCount() > 0 && lazyFooterView != null){
			list.removeFooterView(lazyFooterView);
		}
		if(list.getFooterViewsCount() == 0){		//so there's no duplicate
			//for card UI
			footerSpace = new View(mainActivity);
			footerSpace.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addFooterView(footerSpace, null, false);
		}
	}
	
	protected static void replaceFooterBecauseNewLazyList() {
		if(list.getFooterViewsCount() > 0 && footerSpace != null){
			list.removeFooterView(footerSpace);
		}
		if(list.getFooterViewsCount() == 0){		//so there's no duplicate
			addLazyFooterView();
		}
	}

	protected static void loadMorePosts() {
        isLoadingMorePosts = true;
		if(lazyLoadingFooterSpinner != null){
			lazyLoadingFooterSpinner.setVisibility(View.VISIBLE);
		}
		pullListFromServer(false);
	}
	
	public static void removeFooterSpinner() {
        isLoadingMorePosts = false;
		if(lazyLoadingFooterSpinner != null){
			lazyLoadingFooterSpinner.setVisibility(View.INVISIBLE);
		}
	}

	protected static void handleScrollAwayBottomViewOnScroll() {
		mScrollY = 0;
		int translationY = 0;

		if (list.scrollYIsComputed()) {
			mScrollY = list.getComputedScrollY();
		}

		int rawY = mScrollY;
        //Log.i("cfeed","QUICKRETURN rawY: " + rawY + " mScrollY " + mScrollY);

		switch (mState) {
		case STATE_OFFSCREEN:
            //Log.i("cfeed","QUICKRETURN state_offscreen");
			if (rawY >= mMinRawY) {
				mMinRawY = rawY;
			} else {
				mState = STATE_RETURNING;
			}
			translationY = rawY;
			break;

		case STATE_ONSCREEN:
            //Log.i("cfeed","QUICKRETURN onscreen");
			if (rawY > mQuickReturnHeight) {
				mState = STATE_OFFSCREEN;
				mMinRawY = rawY;
			}
			translationY = rawY;
			break;

		case STATE_RETURNING:
           // Log.i("cfeed","QUICKRETURN returning with rawY " + rawY + " mMinRawY " + mMinRawY + " mQuickReturnHeight " + mQuickReturnHeight);
			translationY = (rawY - mMinRawY) + mQuickReturnHeight;

			if (translationY < 0) {
				translationY = 0;
				mMinRawY = rawY + mQuickReturnHeight;
			}

			if (rawY == 0) {
				mState = STATE_ONSCREEN;
				translationY = 0;
			}

			if (translationY > mQuickReturnHeight) {
				mState = STATE_OFFSCREEN;
				mMinRawY = rawY;
			}
			break;
		}

        //Log.i("cfeed","QUICKRETURN translationY is " + translationY);

		/** this can be used if the build is below honeycomb **/
		if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.HONEYCOMB) {
			anim = new TranslateAnimation(0, 0, translationY,
					translationY);
			anim.setFillAfter(true);
			anim.setDuration(0);
			scrollAwayBottomView.startAnimation(anim);
		} else {
			scrollAwayBottomView.setTranslationY(translationY);
		}

	}

	private static boolean willListScroll() {
		if(postList == null || list.getLastVisiblePosition() + 1 == postList.size() || postList.size() == 0) {
			return false;
		}
		return true; 
	}

	private static void pullListFromServer(boolean wasPullToRefresh) 
	{
		if(postList == null){
			postList = new ArrayList<Post>();
		}
		ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);		
		if(cm.getActiveNetworkInfo() != null)
			new GetPostsTask(0, currentFeedID, currentPageNumber, wasPullToRefresh).execute(new PostSelector());
		else{
			Toast.makeText(mainActivity, "You have no internet connection. Pull down to refresh and try again.", Toast.LENGTH_LONG).show();
			removeFooterSpinner();
			makeLoadingIndicator(false);
		}			
	}

	protected void postClicked(Post post) 
	{
		Intent intent = new Intent(getActivity(), CommentsActivity.class);
		intent.putExtra("POST_ID", post.getID());
		intent.putExtra("COLLEGE_ID", post.getCollegeID());
        intent.putExtra("SECTION_NUMBER", 0);
		
		startActivity(intent);
		getActivity().overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
	}
	
	public static Post getPostByID(int id)
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
			Log.i("cfeed","TEST new post size: " + postList.size());
			listAdapter.setCollegeFeedID(currentFeedID);
            listAdapter.clear();
            listAdapter.addAll(postList);
            Log.i("cfeed","TEST last post size: " + listAdapter.getCount());
			listAdapter.notifyDataSetChanged();
		}
	}

	public static void makeLoadingIndicator(boolean makeLoading) 
	{
        if(loadingSpinner != null){
            if(makeLoading)
            {
                isLoadingMorePosts = true;
                list.setVisibility(View.INVISIBLE);
                loadingSpinner.setVisibility(View.VISIBLE);

                if(pullDownText != null){
                    pullDownText.setVisibility(View.GONE);
                }
            }
            else
            {
                isLoadingMorePosts = false;
                list.setVisibility(View.VISIBLE);
                loadingSpinner.setVisibility(View.INVISIBLE);

                if(pullToRefresh != null)
                {
                    // Notify PullToRefreshLayout that the refresh has finished
                    pullToRefresh.setRefreshComplete();
                }

                if(pullDownText != null){
                    if(postList.size() == 0){
                        pullDownText.setVisibility(View.VISIBLE);
                    } else {
                        pullDownText.setVisibility(View.GONE);
                    }
                }
            }
        }
	}

	@Override
	public void onRefreshStarted(View arg0) 
	{
		endOfListReached = false;
		//go back to first page
		currentPageNumber = 1;
		//reset list
		postList.clear();
		replaceFooterBecauseNewLazyList();
		pullListFromServer(true);
	}

	public static void changeFeed(int id) {
		endOfListReached = false;
        //go back to first page
        currentPageNumber = 1;
		currentFeedID = id;
		College currentCollege = MainActivity.getCollegeByID(id);
		if(collegeNameBottom != null)
		{
			//chose an actual college
			if(currentCollege != null)
				collegeNameBottom.setText(currentCollege.getName());
			else if(id == MainActivity.ALL_COLLEGES)
				collegeNameBottom.setText(mainActivity.getResources().getString(R.string.allColleges));
			//TODO: load college list here
			else
				collegeNameBottom.setText("");
		}
        if(postList != null){
            postList.clear();
        }
		pullListFromServer(true);
        scrollToTop();
	}

	public static void scrollToTop() {
		if(list != null){
			list.setSelectionAfterHeaderView();
		}
	}

//    /**
//     * Here's a customised header transformer which displays the scroll progress as text.
//     */
//    static class CustomisedHeaderTransformer extends HeaderTransformer {
//
//        private View mHeaderView;
//        private TextView mMainTextView;
//        private TextView mProgressTextView;
//
//        @Override
//        public void onViewCreated(Activity activity, View headerView) {
//            mHeaderView = headerView;
//            mMainTextView = (TextView) headerView.findViewById(R.id.ptr_text);
//            mMainTextView.setTextColor(mainActivity.getResources().getColor(R.color.white));
//        }
//
//        @Override
//        public boolean showHeaderView() {
//            return super.showHeaderView();
//        }
//
//        @Override
//        public boolean hideHeaderView() {
//            return true;
//        }
//
//
//    }
}
