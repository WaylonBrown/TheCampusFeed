package com.appuccino.collegefeed.dialogs;

import java.util.ArrayList;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.CollegeListAdapter;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.utils.FontManager;

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
		ArrayList<College> nearYouList = new ArrayList<College>();
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

}
