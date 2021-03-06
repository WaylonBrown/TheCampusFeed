package com.appuccino.thecampusfeed.fragments;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.CommentsActivity;
import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.adapters.PostListAdapter;
import com.appuccino.thecampusfeed.extra.QuickReturnListView;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.MyLog;
import com.appuccino.thecampusfeed.utils.NetWorker.GetPostsTask;
import com.appuccino.thecampusfeed.utils.NetWorker.PostSelector;
import com.appuccino.thecampusfeed.utils.PrefManager;

import java.util.ArrayList;
import java.util.List;

import uk.co.senab.actionbarpulltorefresh.library.ActionBarPullToRefresh;
import uk.co.senab.actionbarpulltorefresh.library.PullToRefreshLayout;
import uk.co.senab.actionbarpulltorefresh.library.listeners.OnRefreshListener;

public class TopPostFragment extends Fragment implements OnRefreshListener
{
	static MainActivity mainActivity;
	public static List<Post> postList;
	public static PostListAdapter listAdapter;
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
    private static boolean endOfListFooterReplaced = false;
	static View lazyFooterView;
	static View footerSpace;
    public static TextView pullDownText;
    static LinearLayout blueFooter;
	static LinearLayout scrollAwayBottomView;
	public static TextView collegeNameBottom;

    public TopPostFragment(){
        mainActivity = MainActivity.activity;
    }

	public TopPostFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
        if(mainActivity == null){
            mainActivity = (MainActivity)getActivity();
        }
        MyLog.d("College list count: " + MainActivity.collegeList.size());
		rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		list = (QuickReturnListView)rootView.findViewById(R.id.fragmentListView);
		loadingSpinner = (ProgressBar)rootView.findViewById(R.id.loadingSpinner);
        //set progressbar as blue
        //loadingSpinner.getIndeterminateDrawable().setColorFilter(new LightingColorFilter(getResources().getColor(R.color.alphablue), getResources().getColor(R.color.alphablue)));
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
		listAdapter = new PostListAdapter(getActivity(), R.layout.list_row_post, postList, 0, currentFeedID);
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
        if(mainActivity == null){
            mainActivity = MainActivity.activity;
        }

		if(list.getFooterViewsCount() == 0){
			lazyFooterView =  ((LayoutInflater)mainActivity.getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.list_lazy_loading_footer, null, false);
	        list.addFooterView(lazyFooterView);
	        lazyLoadingFooterSpinner = (ProgressBar)lazyFooterView.findViewById(R.id.lazyFooterSpinner);
		}
	}

    public static void disableChooseFeedButton(){
        if(blueFooter != null){
            blueFooter.setOnClickListener(null);
        }
    }

    public static void reenableChooseFeedButton(){
        if(blueFooter != null){
            blueFooter.setOnClickListener(new OnClickListener(){

                @Override
                public void onClick(View v) {
                    mainActivity.chooseFeedDialog();
                }
            });
        }
    }

	private void setupBottomViewUI() {
		collegeNameBottom = (TextView)rootView.findViewById(R.id.collegeNameBottomText);
		TextView showingText = (TextView)rootView.findViewById(R.id.showingFeedText);
        blueFooter = (LinearLayout)rootView.findViewById(R.id.footer);
		TextView chooseText = (TextView)rootView.findViewById(R.id.chooseText);
		
		collegeNameBottom.setTypeface(FontManager.light);
		showingText.setTypeface(FontManager.medium);
		chooseText.setTypeface(FontManager.light);

        blueFooter.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				mainActivity.chooseFeedDialog();
			}
		});
		
	}

    /**
     * Un-comment the commented code in here for the scroll away bottom view
     */
	//for slide away footer
    public void setupFooterListView() {
        Log.i("cfeed","list scrollable1: " + willListScroll());
		if(willListScroll()){
//
			list.setOnScrollListener(new AbsListView.OnScrollListener() {
				@SuppressLint("NewApi")
				@Override
				public void onScroll(AbsListView view, int firstVisibleItem,
						int visibleItemCount, int totalItemCount) {

					if (list.getLastVisiblePosition() >= list.getAdapter().getCount() -3 &&
							!endOfListReached && !isLoadingMorePosts)
					{
						loadMorePosts();
					}else if (endOfListReached && !endOfListFooterReplaced){
						replaceFooterBecauseEndOfList();
					}
				}

				@Override
				public void onScrollStateChanged(AbsListView view, int scrollState) {
				}
			});
		}else{
			list.setOnScrollListener(new AbsListView.OnScrollListener() {
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

	public static void replaceFooterBecauseEndOfList() {
        endOfListFooterReplaced = true;
        Log.i("cfeed","end");
        isLoadingMorePosts = false;
        if(list.getFooterViewsCount() > 0 && lazyFooterView != null){
            list.removeFooterView(lazyFooterView);
        }
        if(list.getFooterViewsCount() > 0 && footerSpace != null){
            list.removeFooterView(footerSpace);
        }
		if(list.getFooterViewsCount() == 0){		//so there's no duplicate
			//for card UI
			footerSpace = new View(mainActivity);
			footerSpace.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 160));
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

	protected void loadMorePosts() {
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

	private static boolean willListScroll() {
		if(postList == null || list.getLastVisiblePosition() + 1 == postList.size() || postList.size() == 0) {
			return false;
		}
		return true; 
	}

	private void pullListFromServer(boolean wasPullToRefresh)
	{
		if(postList == null){
			postList = new ArrayList<Post>();
		}
		ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);		
		if(cm.getActiveNetworkInfo() != null)
			new GetPostsTask(this, 0, currentFeedID, currentPageNumber, wasPullToRefresh).execute(new PostSelector());
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

	public void updateList()
	{	
		if(listAdapter != null)
		{
			listAdapter.setCollegeFeedID(currentFeedID);
			listAdapter.notifyDataSetChanged();
//            UpdateListThread update = new UpdateListThread();
//            update.run();
            setupFooterListView();
		}
	}

//    /**
//     * Notify the list adapter of new items on a separate thread
//     */
//    private class UpdateListThread extends Thread {
//        @Override
//        public void run() {
//            mainActivity.runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                    //listAdapter.notifyDataSetChanged();
//                }
//            });
//        }
//    }

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
                        //this happens if new list has been retrieved
                        if(collegeNameBottom.getText() == ""){
                            pullDownText.setText("An updated college list has been found, please reselect the feed you want to view by clicking Choose below");
                        }
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
        if(listAdapter != null){
            listAdapter.idList.clear();
        }
		replaceFooterBecauseNewLazyList();
		pullListFromServer(true);
	}

	public void changeFeed(int id) {
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
			else
				collegeNameBottom.setText("");
		}
        if(postList != null){
            postList.clear();
        }
        if(listAdapter != null){
            listAdapter.idList.clear();
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
