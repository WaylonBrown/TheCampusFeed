package com.appuccino.collegefeed.fragments;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
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
import android.view.WindowManager;
import android.view.animation.TranslateAnimation;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.adapters.TagListAdapter;
import com.appuccino.collegefeed.extra.QuickReturnListView;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Tag;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.GetTagFragmentTask;
import com.appuccino.collegefeed.utils.NetWorker.PostSelector;
import com.appuccino.collegefeed.utils.PrefManager;

import java.util.ArrayList;

public class TagFragment extends Fragment
{
	static MainActivity mainActivity;
	public static final String ARG_SECTION_NUMBER = "section_number";
	public static final int MIN_TAGSEARCH_LENGTH = 4;
	public static ArrayList<Tag> tagList;
	static QuickReturnListView list;
	View rootView;
	private static int currentFeedID;
    private static ProgressBar progressSpinner;
    private static TagListAdapter listAdapter;
	
	//values for footer
	static LinearLayout footer;
	private static int mQuickReturnHeight;
	private static final int STATE_ONSCREEN = 0;
	private static final int STATE_OFFSCREEN = 1;
	private static final int STATE_RETURNING = 2;
	private static int mState = STATE_ONSCREEN;
	private static int mScrollY;
	private static int mMinRawY = 0;
	private static TranslateAnimation anim;
	static TextView collegeNameBottom;

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
			View headerFooter = new View(getActivity());
			headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addFooterView(headerFooter, null, false);
			list.addHeaderView(headerFooter, null, false);
		}
		
		if(tagList == null && mainActivity != null)
		{
			changeFeed(PrefManager.getInt(PrefManager.LAST_FEED, 0));
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
        makeLoadingIndicator(false);
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
        Log.i("cfeed","list scrollable2: " + willListScroll());
		if(willListScroll()){
			list.getViewTreeObserver().addOnGlobalLayoutListener(
				new ViewTreeObserver.OnGlobalLayoutListener() {
					@Override
					public void onGlobalLayout() {
						mQuickReturnHeight = footer.getHeight();
						list.computeScrollY();
					}
			});
			
			list.setOnScrollListener(new OnScrollListener() {
				@SuppressLint("NewApi")
				@Override
				public void onScroll(AbsListView view, int firstVisibleItem,
						int visibleItemCount, int totalItemCount) {

					mScrollY = 0;
					int translationY = 0;

					if (list.scrollYIsComputed()) {
						mScrollY = list.getComputedScrollY();
					}

					int rawY = mScrollY;

					switch (mState) {
					case STATE_OFFSCREEN:
						if (rawY >= mMinRawY) {
							mMinRawY = rawY;
						} else {
							mState = STATE_RETURNING;
						}
						translationY = rawY;
						break;

					case STATE_ONSCREEN:
						if (rawY > mQuickReturnHeight) {
							mState = STATE_OFFSCREEN;
							mMinRawY = rawY;
						}
						translationY = rawY;
						break;

					case STATE_RETURNING:

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

					/** this can be used if the build is below honeycomb **/
					if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.HONEYCOMB) {
						anim = new TranslateAnimation(0, 0, translationY,
								translationY);
						anim.setFillAfter(true);
						anim.setDuration(0);
						footer.startAnimation(anim);
					} else {
						footer.setTranslationY(translationY);
					}

				}

				@Override
				public void onScrollStateChanged(AbsListView view, int scrollState) {
				}
			});
		}else{			//don't let bottom part move if the list isn't scrollable
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
	
	private static boolean willListScroll() {
		if(tagList == null || list.getLastVisiblePosition() + 1 >= tagList.size() || tagList.size() == 0) {
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
    			if(text.length() < MIN_TAGSEARCH_LENGTH)
    				Toast.makeText(mainActivity, "Must be at least " + MIN_TAGSEARCH_LENGTH + " characters long.", Toast.LENGTH_LONG).show();
    			else if(!text.substring(0, 1).equals("#"))
    				Toast.makeText(mainActivity, "Must start with #", Toast.LENGTH_LONG).show();
    			else if(containsSymbols(text)){
    				Toast.makeText(mainActivity, "A search for a tag cannot include the symbols !, $, %, ^, &, *, +, or .", Toast.LENGTH_LONG).show();
    			}
    			else{
    				Intent intent = new Intent(mainActivity, TagListActivity.class);
    				intent.putExtra("TAG_ID", searchTagEditText.getText().toString());
    				
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
	
	protected boolean containsSymbols(String text) {
		if(text.contains("!") ||
				text.contains("$") ||
				text.contains("%") ||
				text.contains("^") ||
				text.contains("&") ||
				text.contains("*") ||
				text.contains("+") ||
				text.contains(".")){
			return true;
		}
		return false;
	}

	private static void pullListFromServer() 
	{
        if(tagList == null){
            tagList = new ArrayList<Tag>();
        }
		ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
		if(cm.getActiveNetworkInfo() != null){
			new GetTagFragmentTask(currentFeedID).execute(new PostSelector());
		} else {
            makeLoadingIndicator(false);
        }
	}
	
	public static void changeFeed(int id) {
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
        if(tagList != null){
            tagList.clear();
        }
        if(listAdapter != null) {
            listAdapter.clear();
        }
		pullListFromServer();
	}

	public static void updateList() {
		if(listAdapter != null)
		{
			listAdapter.clear();
			listAdapter.addAll(tagList);
			listAdapter.notifyDataSetChanged();
		}
	}

	public static void makeLoadingIndicator(boolean b) {
        if(b){
            progressSpinner.setVisibility(View.VISIBLE);
        }else{
            progressSpinner.setVisibility(View.GONE);
        }
	}
}
