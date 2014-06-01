package com.appuccino.collegefeed.dialogs;

import java.util.ArrayList;
import java.util.List;

import android.app.AlertDialog;
import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.AutoCompleteDropdownAdapter;
import com.appuccino.collegefeed.adapters.CollegeListAdapter;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.utils.FontManager;

public class ChooseFeedDialog extends AlertDialog.Builder{
	
	MainActivity main;
	ArrayList<College> otherColleges;
	ArrayList<College> nearYouList;
	AlertDialog dialog;
	
	public ChooseFeedDialog(MainActivity main, View layout) {
		super(main);
		this.main = main;
		setCancelable(true);
		setView(layout);
		
		dialog = create();
		dialog.show();
		
		ListView nearYouList = (ListView)layout.findViewById(R.id.nearYouDialogList);
		TextView chooseTitleText = (TextView)layout.findViewById(R.id.chooseFeedDialogTitle);
    	TextView allCollegesText = (TextView)layout.findViewById(R.id.allCollegesText);
    	TextView nearYouTitle = (TextView)layout.findViewById(R.id.nearYouTitle);
    	TextView otherTitle = (TextView)layout.findViewById(R.id.otherTitle);
    	TextView otherCollegesText = (TextView)layout.findViewById(R.id.otherCollegesButtonText);
    	LinearLayout searchColleges = (LinearLayout)layout.findViewById(R.id.searchCollegesButton);
    	
    	chooseTitleText.setTypeface(FontManager.light);
    	allCollegesText.setTypeface(FontManager.light);
    	nearYouTitle.setTypeface(FontManager.light);
    	otherTitle.setTypeface(FontManager.light);
    	otherCollegesText.setTypeface(FontManager.light);
    	
    	populateNearYouList(nearYouList);
    	setupClickListeners(searchColleges);
	}
	
	private void setupClickListeners(LinearLayout searchColleges) {
		searchColleges.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				new SearchCollegesDialog(main, dialog);
			}
		});
	}

	private void populateNearYouList(ListView list) {
		nearYouList = new ArrayList<College>();
		boolean enableListClicking = true;	//false if no colleges so that the item can't be clicked
		
		if(MainActivity.permissions != null)
		{
			if(MainActivity.permissions.size() > 0)
			{
				for(int id : MainActivity.permissions)
				{
					nearYouList.add(MainActivity.getCollegeByID(id));
				}
			}
			else
			{
				nearYouList.add(new College("(none)"));
				enableListClicking = false;
			}
		}
		else
		{
			nearYouList.add(new College("(none)"));
			enableListClicking = false;
		}
		
		CollegeListAdapter adapter = new CollegeListAdapter(main, R.layout.list_row_choosefeed_college, nearYouList, enableListClicking);
		list.setAdapter(adapter);
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
					main.changeFeed(MainActivity.getIdByCollegeName(s.toString()));
					dialog.dismiss();
					previousDialog.dismiss();
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
}
