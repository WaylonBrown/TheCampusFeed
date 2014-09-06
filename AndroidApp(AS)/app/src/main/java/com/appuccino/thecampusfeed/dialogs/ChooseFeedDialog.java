package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AutoCompleteTextView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.adapters.AutoCompleteDropdownAdapter;
import com.appuccino.thecampusfeed.adapters.DialogCollegeListAdapter;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.utils.FontManager;

import java.util.ArrayList;
import java.util.List;

public class ChooseFeedDialog extends AlertDialog.Builder{
	
	static MainActivity main;
	static ArrayList<College> nearYouListArray;
	AlertDialog dialog;
	ListView nearYouListView;
    static DialogCollegeListAdapter adapter;
    public static boolean isVisible = false;

    public ChooseFeedDialog(MainActivity main, View layout) {
		super(main);
        isVisible = true;
		this.main = main;
		setCancelable(true);
		setView(layout);
		
		dialog = create();
		dialog.show();
		
		nearYouListView = (ListView)layout.findViewById(R.id.nearYouDialogList);
		TextView chooseTitleText = (TextView)layout.findViewById(R.id.chooseFeedDialogTitle);
        TextView allCollegesTitle = (TextView)layout.findViewById(R.id.allCollegesTitle);
    	TextView allCollegesText = (TextView)layout.findViewById(R.id.allCollegesText);
    	TextView nearYouTitle = (TextView)layout.findViewById(R.id.nearYouTitle);
    	TextView otherTitle = (TextView)layout.findViewById(R.id.otherTitle);
    	TextView otherCollegesText = (TextView)layout.findViewById(R.id.otherCollegesButtonText);
    	LinearLayout searchColleges = (LinearLayout)layout.findViewById(R.id.searchCollegesButton);
    	LinearLayout allColleges = (LinearLayout)layout.findViewById(R.id.allCollegesButton);
    	
    	chooseTitleText.setTypeface(FontManager.light);
        allCollegesTitle.setTypeface(FontManager.light);
    	allCollegesText.setTypeface(FontManager.light);
    	nearYouTitle.setTypeface(FontManager.light);
    	otherTitle.setTypeface(FontManager.light);
    	otherCollegesText.setTypeface(FontManager.light);
    	
    	populateNearYouList(MainActivity.locationFound);
    	setupClickListeners(searchColleges, allColleges);
	}
	
	private void setupClickListeners(LinearLayout searchColleges, LinearLayout allColleges) {
		searchColleges.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				new SearchCollegesDialog(main, dialog);
			}
		});
		
		allColleges.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				dialog.dismiss();
				main.changeFeed(MainActivity.ALL_COLLEGES);
			}
		});
	}

	public void populateNearYouList(boolean locationFound) {
		if(nearYouListView != null){
            nearYouListView.requestLayout();
			nearYouListArray = new ArrayList<College>();
			boolean enableListClicking = true;	//false if no colleges so that the item can't be clicked
			
			if(MainActivity.permissions != null)
			{
				if(MainActivity.permissions.size() > 0)
				{
                    for(int id : MainActivity.permissions)
                    {
                        nearYouListArray.add(MainActivity.getCollegeByID(id));
                    }
				}
				else
				{
                    if(locationFound){
                        nearYouListArray.add(new College("(none)"));
                    } else {
                        nearYouListArray.add(new College("Loading..."));
                    }
					enableListClicking = false;
				}
			}
			else
			{
                if(locationFound){
                    nearYouListArray.add(new College("(none)"));
                } else {
                    nearYouListArray.add(new College("Loading..."));
                }
				enableListClicking = false;
			}
			
			adapter = new DialogCollegeListAdapter(main, R.layout.list_row_choosefeed_college, nearYouListArray, enableListClicking);
			nearYouListView.setAdapter(adapter);

            //don't let Near You list push bottom buttons off screen, so set a max height
            nearYouListView.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                @Override
                public void onLayoutChange(View view, int i, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
                    if(nearYouListView.getHeight() > 800)
                    {
                        nearYouListView.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, 800));
                    }
                }
            });

			nearYouListView.setOnItemClickListener(new OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view,
                                        int position, long id) {
                    dialog.dismiss();
                    main.changeFeed(nearYouListArray.get(position).getID());
                }
            });
		}
	}

    public static void recalculateNearYouList(MainActivity main){
        nearYouListArray = new ArrayList<College>();
        boolean enableListClicking = true;	//false if no colleges so that the item can't be clicked

        if(MainActivity.permissions != null)
        {
            if(MainActivity.permissions.size() > 0)
            {
                for(int id : MainActivity.permissions)
                {
                    nearYouListArray.add(MainActivity.getCollegeByID(id));
                }
            }
        }
        if(adapter != null){
            adapter.notifyDataSetChanged();
        } else {
            adapter = new DialogCollegeListAdapter(main, R.layout.list_row_choosefeed_college, new ArrayList<College>(), enableListClicking);
            adapter.notifyDataSetChanged();
        }
    }

	public class SearchCollegesDialog extends AlertDialog.Builder{
		
		AlertDialog dialog;
		AlertDialog previousDialog;
		
		public SearchCollegesDialog(MainActivity main, AlertDialog previousDialog) {
			super(main);
			this.previousDialog = previousDialog;
			setCancelable(true);
			LayoutInflater inflater = main.getLayoutInflater();
			View layout = inflater.inflate(R.layout.dialog_searchcolleges, null);
			setView(layout);
			
			dialog = create();
			dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		    WindowManager.LayoutParams wmlp = dialog.getWindow().getAttributes();

		    wmlp.gravity = Gravity.TOP;
			dialog.show();
			
			AutoCompleteTextView otherCollegesText = (AutoCompleteTextView)layout.findViewById(R.id.otherCollegesText);
			otherCollegesText.setTypeface(FontManager.light);
			setupAutoCompleteTextView(dialog, otherCollegesText);
		}
		
		protected void checkCollegeNameEntered(CharSequence s) {
			for(College c : MainActivity.collegeList)
			{
				if(s.toString().equals(c.getName()))
				{
					dialog.dismiss();
					previousDialog.dismiss();
					main.changeFeed(MainActivity.getIdByCollegeName(s.toString()));
					break;
				}
			}
		}

		private void setupAutoCompleteTextView(final AlertDialog dialog, AutoCompleteTextView textView) {
			//show keyboard automatically
			textView.setOnFocusChangeListener(new View.OnFocusChangeListener() {
			    @Override
			    public void onFocusChange(View v, boolean hasFocus) {
			        if (hasFocus) {
			            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
			        }
			    }
			});
			
			//detect if college has been clicked
			textView.addTextChangedListener(new TextWatcher(){
				@Override
				public void beforeTextChanged(CharSequence s, int start,
						int count, int after) {
				}
				
				@Override
				public void onTextChanged(CharSequence s, int start,
						int before, int count) {
					if(s.length() > 8)
					{
						checkCollegeNameEntered(s);
					}
				}
				
				@Override
				public void afterTextChanged(Editable s) {
				}
			});
			
			//setup filter
			List<String> allCollegesList = new ArrayList<String>();
			for(College c : MainActivity.collegeList)
			{
				allCollegesList.add(c.getName());
			}
			AutoCompleteDropdownAdapter adapter = new AutoCompleteDropdownAdapter(main, R.layout.list_row_dropdown, allCollegesList);
	        textView.setAdapter(adapter);
		}
	}

	public boolean isShowing() {
		if(dialog != null && dialog.isShowing()){
			return true;
		}
		return false;
	}
}
