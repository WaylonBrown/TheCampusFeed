package com.appuccino.collegefeed.dialogs;

import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.extra.FontManager;

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
		
		TextView chooseTitleText = (TextView)layout.findViewById(R.id.chooseFeedDialogTitle);
    	TextView allCollegesText = (TextView)layout.findViewById(R.id.allCollegesText);
    	TextView nearYouTitle = (TextView)layout.findViewById(R.id.nearYouTitle);
    	TextView otherTitle = (TextView)layout.findViewById(R.id.otherTitle);
    	chooseTitleText.setTypeface(FontManager.light);
    	allCollegesText.setTypeface(FontManager.light);
    	nearYouTitle.setTypeface(FontManager.light);
    	otherTitle.setTypeface(FontManager.light);
    	
    	ListView nearYouList = (ListView)layout.findViewById(R.id.nearYouDialogList);
    	populateNearYouList(nearYouList);
	}
	
	private void populateNearYouList(ListView list) {
		String[] testCollegeString = {
				"Texas A&M University",
				"University of Texas in Austin"
		};
		
		
	}

}
