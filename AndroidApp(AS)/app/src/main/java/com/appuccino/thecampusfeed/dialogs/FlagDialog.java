package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.NetWorker.MakeFlagTask;

public class FlagDialog extends AlertDialog.Builder{
	Context context;
	Post post;
	AlertDialog dialog;
	
	public FlagDialog(final Context context, Post post) {
		super(context);
		this.context = context;
		this.post = post;
		setCancelable(true);
		setPositiveButton("Yes", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                yesButtonClicked();
            }
        }).setNegativeButton("No", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                dialog.dismiss();
            }
        }).setTitle("Flag as Inappropriate?").setMessage(context.getResources().getString(R.string.flagMessage));
		
		if(MainActivity.permissions != null && MainActivity.hasPermissions(post.getCollegeID()))
		{
			createDialog();
		}
		
	}

	protected void yesButtonClicked() {
		new MakeFlagTask(context).execute(post.getID());
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
	}
}