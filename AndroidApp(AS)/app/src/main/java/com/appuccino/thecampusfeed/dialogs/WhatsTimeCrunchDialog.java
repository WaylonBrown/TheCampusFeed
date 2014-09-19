package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.FontManager;

public class WhatsTimeCrunchDialog extends AlertDialog.Builder{
	Context context;
	Post post;
	AlertDialog dialog;

	public WhatsTimeCrunchDialog(final Context context) {
		super(context);
		this.context = context;
		setCancelable(true);
		setPositiveButton("Got it", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
            }
        }).setTitle("What is Time Crunch?").setMessage(context.getResources().getString(R.string.whatsTimeCrunch));
		
		createDialog();
	}

	private void createDialog() {
		dialog = create();
		dialog.show();
		
		TextView titleText = (TextView) dialog.findViewById(context.getResources().getIdentifier("alertTitle", "id", "android"));
		TextView messageText = (TextView)dialog.findViewById(android.R.id.message);
		Button yesButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
		
		titleText.setTypeface(FontManager.light);
		messageText.setTypeface(FontManager.light);
    	yesButton.setTypeface(FontManager.light);
	}
}