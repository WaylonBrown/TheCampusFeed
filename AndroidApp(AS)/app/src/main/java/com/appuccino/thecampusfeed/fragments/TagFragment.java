package com.appuccino.thecampusfeed.fragments;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.TagListActivity;
import com.appuccino.thecampusfeed.adapters.TagListAdapter;
import com.appuccino.thecampusfeed.extra.QuickReturnListView;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.objects.Tag;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.NetWorker.GetTagFragmentTask;
import com.appuccino.thecampusfeed.utils.NetWorker.PostSelector;
import com.appuccino.thecampusfeed.utils.PrefManager;

import java.util.ArrayList;

public class TagFragment extends Fragment
{
	static MainActivity mainActivity;
	public static final int MIN_TAGSEARCH_LENGTH = 4;
	public static ArrayList<Tag> tagList;
	static QuickReturnListView list;
	View rootView;
	private static int currentFeedID;
    private static ProgressBar progressSpinner;
    public static TagListAdapter listAdapter;
    public static boolean endOfListReached = false;
    private static boolean isLoadingMorePosts = false;
    private static boolean endOfListFooterReplaced = false;
    static View lazyFooterView;
    static View footerSpace;
    private static ProgressBar lazyLoadingFooterSpinner;
    public static int currentPageNumber = 1;
	static LinearLayout footer;
	static TextView collegeNameBottom;

	public TagFragment()
	{
        mainActivity = MainActivity.activity;
    }
	
	public TagFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		rootView = inflater.inflate(R.layout.fragment_layout_tag,
				container, false);
		list = (QuickReturnListView)rootView.findViewById(R.id.fragmentListView);
		footer = (LinearLayout)rootView.findViewById(R.id.footer);
        progressSpinner = (ProgressBar)rootView.findViewById(R.id.progressSpinner);
		setupBottomViewUI();
		
		//if doesnt have header and footer, add them
		if(list.getHeaderViewsCount() == 0)
		{
			//for card UI
            View header = new View(getActivity());
            View footer = new View(getActivity());
            footer.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 310));
            header.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addFooterView(footer, null, false);
			list.addHeaderView(header, null, false);
		}
		
		if(mainActivity != null)
		{
            if(MainActivity.currentFeedCollegeID == 0){
                changeFeed(PrefManager.getInt(PrefManager.LAST_FEED, 0));
            } else {
                changeFeed(MainActivity.currentFeedCollegeID);
            }

		}
		listAdapter = new TagListAdapter(getActivity(), R.layout.list_row_tag, tagList);
		if(list != null)
			list.setAdapter(listAdapter);	
		else
			Log.e("cfeed", "TagFragment list adapter wasn't set.");
		list.setItemsCanFocus(true);
	    
	    //set bottom text typeface
	    TextView tagSearchText = (TextView)rootView.findViewById(R.id.tagSearchText);
	    tagSearchText.setTypeface(FontManager.light);
	    
	    tagSearchText.setOnClickListener(new OnClickListener()
	    {
			@Override
			public void onClick(View v) 
			{
				searchTagsClicked();
			}
	    });
	    
		return rootView;
	}

    public void onResume(){
        super.onResume();
        setupFooterListView();
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
	
	public void setupFooterListView() {
        Log.i("cfeed","list scrollable2: " + willListScroll());
		if(willListScroll()){
			
			list.setOnScrollListener(new OnScrollListener() {
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

    private static void addLazyFooterView() {
        if(list.getFooterViewsCount() == 0){
            lazyFooterView =  ((LayoutInflater)mainActivity.getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.list_lazy_loading_footer, null, false);
            list.addFooterView(lazyFooterView);
            lazyLoadingFooterSpinner = (ProgressBar)lazyFooterView.findViewById(R.id.lazyFooterSpinner);
        }
    }

    protected void loadMorePosts() {
        isLoadingMorePosts = true;
        if(lazyLoadingFooterSpinner != null){
            lazyLoadingFooterSpinner.setVisibility(View.VISIBLE);
        }
        pullListFromServer();
    }

    public static void removeFooterSpinner() {
        isLoadingMorePosts = false;
        if(lazyLoadingFooterSpinner != null){
            lazyLoadingFooterSpinner.setVisibility(View.INVISIBLE);
        }
    }

    private static boolean willListScroll() {
		if(tagList == null || list.getLastVisiblePosition() + 1 == tagList.size() || tagList.size() == 0) {
			return false;
		}
		return true; 
	}

	public static void tagClicked(Tag tag) 
	{
		Intent intent = new Intent(mainActivity, TagListActivity.class);
		intent.putExtra("TAG_ID", tag.getText());
		
		mainActivity.startActivity(intent);
		mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);			
	}
	
	public void searchTagsClicked() 
	{
		LayoutInflater inflater = mainActivity.getLayoutInflater();
		View searchDialogLayout = inflater.inflate(R.layout.dialog_tag_search, null);
		final EditText searchTagEditText = (EditText)searchDialogLayout.findViewById(R.id.searchTagEditText);
		
		AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity);
    	builder.setCancelable(true);
    	builder.setView(searchDialogLayout)
    	.setPositiveButton("Search", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing here since overridden below to be able to click button and not dismiss dialog
            }
        });
    	    	
    	final AlertDialog dialog = builder.create();
    	dialog.show();
    	
    	Button searchButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
    	searchButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{		
    			String text = searchTagEditText.getText().toString().trim();
                String[] tagListFromRegex = MainActivity.parseTagsWithRegex(text);
                String tag = "";
                if(tagListFromRegex.length > 0){
                    tag = tagListFromRegex[0];
                }
    			if(text.length() < MIN_TAGSEARCH_LENGTH)
    				Toast.makeText(mainActivity, "Must be at least " + MIN_TAGSEARCH_LENGTH + " characters long.", Toast.LENGTH_LONG).show();
    			else if(!text.substring(0, 1).equals("#"))
    				Toast.makeText(mainActivity, "Must start with #", Toast.LENGTH_LONG).show();
    			else if(tag.isEmpty()){
    				Toast.makeText(mainActivity, "A search for a tag cannot include the symbols !, $, %, ^, &, *, +, ',', ., or another #", Toast.LENGTH_LONG).show();
    			} else {
    				Intent intent = new Intent(mainActivity, TagListActivity.class);
    				intent.putExtra("TAG_ID", tag);
    				
    				mainActivity.startActivity(intent);
    				mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        			dialog.dismiss();
    			}
			}
    	});
    	
    	searchTagEditText.setTypeface(FontManager.light);
    	searchButton.setTypeface(FontManager.light);
    	
    	searchTagEditText.setSelection(1);	//start cursor after #
    	//ensure keyboard is brought up when dialog shows
    	searchTagEditText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
    	    @Override
    	    public void onFocusChange(View v, boolean hasFocus) {
    	        if (hasFocus) {
    	            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    	        }
    	    }
    	});
	}

	private void pullListFromServer()
	{
        if(tagList == null){
            tagList = new ArrayList<Tag>();
        }
		ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
		if(cm.getActiveNetworkInfo() != null){
			new GetTagFragmentTask(this, currentFeedID, currentPageNumber).execute(new PostSelector());
		} else {
            makeLoadingIndicator(false);
        }
	}
	
	public void changeFeed(int id) {
        endOfListReached = false;
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
			//TODO: IGNORE load college list here
			else
				collegeNameBottom.setText("");
		}
        if(tagList != null){
            tagList.clear();
        }
        if(listAdapter != null) {
            listAdapter.clear();
        }
		pullListFromServer();
        scrollToTop();
	}

	public void updateList() {
		if(listAdapter != null)
		{
			listAdapter.notifyDataSetChanged();
            setupFooterListView();
		}
	}



	public static void makeLoadingIndicator(boolean makeLoading) {
        if(progressSpinner != null){
            if(makeLoading)
            {
                isLoadingMorePosts = true;
                list.setVisibility(View.INVISIBLE);
                progressSpinner.setVisibility(View.VISIBLE);
            }
            else
            {
                isLoadingMorePosts = false;
                list.setVisibility(View.VISIBLE);
                progressSpinner.setVisibility(View.INVISIBLE);
            }
        }
	}

    public static void scrollToTop() {
        if(list != null){
            list.setSelectionAfterHeaderView();
        }
    }
}
