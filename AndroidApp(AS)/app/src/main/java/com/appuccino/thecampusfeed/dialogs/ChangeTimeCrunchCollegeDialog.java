package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.PrefManager;

public class ChangeTimeCrunchCollegeDialog extends AlertDialog.Builder{
	Context context;
	AlertDialog dialog;

	public ChangeTimeCrunchCollegeDialog(final Context context, final int collegeID) {
		super(context);
		this.context = context;
		setCancelable(true);

        setPositiveButton("Yes", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, collegeID);
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOURS, 0);
                PrefManager.putBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false);
            }
        }).setNegativeButton("No", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing
            }
        }).setTitle("Change home college for Time Crunch?").setMessage("You posted to a college that isn't your Time Crunch college, meaning no hours were added to your Time Crunch. " +
                "Want to switch your college to this one? All current Time Crunch hours will be wiped.");
		
		createDialog();
	}

	private void createDialog() {
		dialog = create();
		dialog.show();
		
		TextView titleText = (TextView) dialog.findViewById(context.getResources().getIdentifier("alertTitle", "id", "android"));
		TextView messageText = (TextView)dialog.findViewById(android.R.id.message);
        Button yesButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
        Button noButton = dialog.getButton(AlertDialog.BUTTON_NEGATIVE);

		titleText.setTypeface(FontManager.light);
		messageText.setTypeface(FontManager.light);
    	yesButton.setTypeface(FontManager.light);
        if(noButton != null){
            noButton.setTypeface(FontManager.light);
        }
	}
}