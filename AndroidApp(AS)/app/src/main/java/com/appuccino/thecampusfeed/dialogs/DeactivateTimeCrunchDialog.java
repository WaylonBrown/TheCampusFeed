package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.fragments.TimeCrunchFragment;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.PrefManager;

public class DeactivateTimeCrunchDialog extends AlertDialog.Builder{
	MainActivity main;
	AlertDialog dialog;

	public DeactivateTimeCrunchDialog(final MainActivity main, final TimeCrunchFragment frag) {
		super(main);
		this.main = main;
		setCancelable(true);

        setPositiveButton("Yes", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //start time crunch
                PrefManager.putBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false);
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1);
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOURS, 0);
                main.getLocation();
                frag.updateActivationState(false);
            }
        }).setNegativeButton("No", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing
            }
        }).setTitle("Turn off Time Crunch?").setMessage("WARNING: This will set your Time Crunch hours to zero. Are you sure you wish to do this?");
		
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