package com.appuccino.collegefeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.CommentsActivity;
import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.MakeCommentTask;
import com.appuccino.collegefeed.utils.TimeManager;

public class FlagDialog extends AlertDialog.Builder{
	Context context;
	Post parentPost;
	AlertDialog dialog;
	
	public FlagDialog(final Context context, Post post) {
		super(context);
		this.context = context;
		parentPost = post;
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
		
		if(MainActivity.permissions != null && MainActivity.hasPermissions(parentPost.getCollegeID()))
		{
			createDialog();
		}
		
	}

	protected void yesButtonClicked() {
		
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