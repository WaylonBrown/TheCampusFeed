package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.animation.TranslateAnimation;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AbsListView.OnScrollListener;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.adapters.TagListAdapter;
import com.appuccino.collegefeed.extra.QuickReturnListView;
import com.appuccino.collegefeed.extra.NetWorker.MakePostTask;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Tag;
import com.appuccino.collegefeed.utils.FontManager;

public class TagFragment extends Fragment
{
	static MainActivity mainActivity;
	public static final String ARG_SECTION_NUMBER = "section_number";
	static ArrayList<Tag> tagList;
	QuickReturnListView list;
	View rootView;
	
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
		setupBottomViewUI();
		
		tagList = new ArrayList<Tag>();
		tagList.add(new Tag("#YOLO", 5));
		tagList.add(new Tag("#bieberfever", 5));
		tagList.add(new Tag("#tbt", 5));
		tagList.add(new Tag("#YOLO", 5));
		tagList.add(new Tag("#bieberfever", 5));
		tagList.add(new Tag("#tbt", 5));
		tagList.add(new Tag("#YOLO", 5));
		tagList.add(new Tag("#bieberfever", 5));
		tagList.add(new Tag("#tbt", 5));
		tagList.add(new Tag("#YOLO", 5));
		tagList.add(new Tag("#bieberfever", 5));
		tagList.add(new Tag("#tbt", 5));
		
		TagListAdapter adapter = new TagListAdapter(getActivity(), R.layout.list_row_tag, tagList);
		
		//if doesnt have header and footer, add them
		if(list.getHeaderViewsCount() == 0)
		{
			//for card UI
			View headerFooter = new View(getActivity());
			headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			list.addFooterView(headerFooter, null, false);
			list.addHeaderView(headerFooter, null, false);
		}
		if(list != null)
			list.setAdapter(adapter);	
		else
			Log.e("cfeed", "TopPostFragment list adapter wasn't set.");
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
	    
	    //when implementing NetWorking with the list, make sure to call this from that, 
	    //not from here
	    setupFooterListView();
	    
		return rootView;
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
	
	private void setupFooterListView() {
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

					System.out.println(translationY);
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
    			if(searchTagEditText.getText().toString().length() >= 3)
    			{
    				Intent intent = new Intent(mainActivity, TagListActivity.class);
    				intent.putExtra("TAG_ID", searchTagEditText.getText().toString());
    				
    				mainActivity.startActivity(intent);
    				mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        			dialog.dismiss();
    			}
    			else
    			{
    				Toast.makeText(mainActivity, "Must be at least 3 characters long.", Toast.LENGTH_LONG).show();
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
	
	public static void changeFeed(int id) {
		College newFeed = MainActivity.getCollegeByID(id);
		if(collegeNameBottom != null)
		{
			//chose an actual college
			if(newFeed != null)
				collegeNameBottom.setText(newFeed.getName());
			else
				collegeNameBottom.setText(mainActivity.getResources().getString(R.string.allColleges));
		}
	}
}
