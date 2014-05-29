package com.appuccino.collegefeed.dialogs;

import java.util.ArrayList;
import java.util.List;

import android.app.AlertDialog;
import android.content.Context;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.CollegeListAdapter;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.utils.FontManager;

public class ChooseFeedDialog extends AlertDialog.Builder{
	
	Context context;
	ArrayList<College> otherColleges;
	ArrayList<College> nearYouList;
	
	public ChooseFeedDialog(Context context, View layout) {
		super(context);
		this.context = context;
		setCancelable(true);
		setView(layout);
		
		final AlertDialog dialog = create();
		dialog.show();
		
		ListView nearYouList = (ListView)layout.findViewById(R.id.nearYouDialogList);
		TextView chooseTitleText = (TextView)layout.findViewById(R.id.chooseFeedDialogTitle);
    	TextView allCollegesText = (TextView)layout.findViewById(R.id.allCollegesText);
    	TextView nearYouTitle = (TextView)layout.findViewById(R.id.nearYouTitle);
    	TextView otherTitle = (TextView)layout.findViewById(R.id.otherTitle);
    	AutoCompleteTextView otherCollegesText = (AutoCompleteTextView)layout.findViewById(R.id.otherCollegesText);
    	
    	chooseTitleText.setTypeface(FontManager.light);
    	allCollegesText.setTypeface(FontManager.light);
    	nearYouTitle.setTypeface(FontManager.light);
    	otherTitle.setTypeface(FontManager.light);
    	
    	populateNearYouList(nearYouList);
    	setupAutoCompleteTextView(otherCollegesText);
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
		
		CollegeListAdapter adapter = new CollegeListAdapter(context, R.layout.list_row_choosefeed_college, nearYouList, enableListClicking);
		list.setAdapter(adapter);
	}

	private void setupAutoCompleteTextView(AutoCompleteTextView textView) {
		//CODE FROM WHEN IT WAS A SPINNER, LEAVE FOR NOW IN CASE CHANGING BACK
//		otherColleges = new ArrayList<College>();
//		List<String> otherCollegesStringList = new ArrayList<String>();
//		otherCollegesStringList.add("Choose...");
//		
//		//add colleges that aren't already nearby
//		if(MainActivity.collegeList != null)
//		{
//			for(College c : MainActivity.collegeList)
//			{
//				if(MainActivity.permissions != null)
//				{
//					if(!MainActivity.permissions.contains(c.getID()))
//						otherColleges.add(c);
//				}
//				else
//					otherColleges.add(c);
//			}
//		}
//		
//		//make list into strings for spinner
//		if(otherColleges.size() > 0)
//		{
//			for(College c : otherColleges)
//			{
//				otherCollegesStringList.add(c.getName());
//			}
//		}
//		
//		//populate spinner
//		ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, R.layout.list_row_spinner, otherCollegesStringList);
//	    adapter.setDropDownViewResource(R.layout.list_row_spinner);
//	    otherCollegesSpinner.setAdapter(adapter);
		
		List<String> allCollegesList = new ArrayList<String>();
		for(College c : MainActivity.collegeList)
		{
			allCollegesList.add(c.getName());
		}
		
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, android.R.layout.simple_dropdown_item_1line, allCollegesList);
        textView.setAdapter(adapter);
	}
}
