package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.utils.FontManager;

public class ChangeTimeCrunchCollegeDialog extends AlertDialog.Builder{
	Context context;
	AlertDialog dialog;

	public ChangeTimeCrunchCollegeDialog(final Context context, String title, String message, boolean multiButton) {
		super(context);
		this.context = context;
		setCancelable(true);

        if(multiButton){
            setPositiveButton("Yes", new DialogInterface.OnClickListener()
            {
                @Override
                public void onClick(DialogInterface dialog, int which)
                {
                    //start time crunch
                }
            }).setNegativeButton("No", new DialogInterface.OnClickListener()
            {
                @Override
                public void onClick(DialogInterface dialog, int which)
                {
                    //do nothing
                }
            });
        } else {
            setPositiveButton("Okay", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    //do nothing
                }
            });
        }
		setTitle(title).setMessage(message);
		
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