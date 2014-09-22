package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.fragments.TimeCrunchFragment;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.PrefManager;

import java.util.Calendar;

public class ActivateTimeCrunchDialog extends AlertDialog.Builder{
	MainActivity main;
	AlertDialog dialog;

	public ActivateTimeCrunchDialog(final MainActivity main, final TimeCrunchFragment frag, final int collegeID, String title, String message, boolean multiButton) {
		super(main);
		this.main = main;
		setCancelable(true);

        if(multiButton){
            setPositiveButton("Yes", new DialogInterface.OnClickListener()
            {
                @Override
                public void onClick(DialogInterface dialog, int which)
                {
                    //start time crunch
                    PrefManager.putBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, true);
                    PrefManager.putInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, collegeID);
                    PrefManager.putTimeCrunchActivateTimestamp(Calendar.getInstance());
                    main.setupTimeCrunchLocation();
                    frag.updateActivationState(true);
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
		
		TextView titleText = (TextView) dialog.findViewById(main.getResources().getIdentifier("alertTitle", "id", "android"));
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