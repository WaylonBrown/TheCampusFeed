package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.utils.FontManager;

public class GettingStartedDialog extends AlertDialog.Builder{
	Context context;
	AlertDialog dialog;

	public GettingStartedDialog(final Context context, String title) {
		super(context);
		this.context = context;
		setCancelable(true);
		setPositiveButton("OK", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                dialog.dismiss();
            }
        }).setTitle(title).setMessage(context.getResources().getString(R.string.gettingStartedMessage));
		
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
    	noButton.setTypeface(FontManager.light);

        messageText.setTextColor(context.getResources().getColor(R.color.darkgray));
	}
}