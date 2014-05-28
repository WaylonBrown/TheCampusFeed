package com.appuccino.collegefeed.dialogs;

import java.util.ArrayList;

import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.CollegeListAdapter;
import com.appuccino.collegefeed.extra.FontManager;
import com.appuccino.collegefeed.objects.College;

import android.app.AlertDialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

public class ChooseFeedDialog extends AlertDialog.Builder{
	
	Context context;
	
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
    	chooseTitleText.setTypeface(FontManager.light);
    	allCollegesText.setTypeface(FontManager.light);
    	nearYouTitle.setTypeface(FontManager.light);
    	otherTitle.setTypeface(FontManager.light);
    	
    	populateNearYouList(nearYouList);
	}
	
	private void populateNearYouList(ListView list) {
		ArrayList<College> collegeList = new ArrayList<College>();
		collegeList.add(new College("Texas A&M University"));
		collegeList.add(new College("University of Texas in Austin"));
		
		CollegeListAdapter adapter = new CollegeListAdapter(context, R.layout.list_row_choosefeed_college, collegeList);
		list.setAdapter(adapter);
	}

}
