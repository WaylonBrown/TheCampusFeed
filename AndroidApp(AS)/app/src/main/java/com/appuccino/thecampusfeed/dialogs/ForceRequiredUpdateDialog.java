package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.utils.FontManager;

public class ForceRequiredUpdateDialog extends AlertDialog.Builder{
    Context context;
    AlertDialog dialog;

    public ForceRequiredUpdateDialog(final Context context) {
        super(context);
        this.context = context;
        setCancelable(false);
        setPositiveButton("Update App", null)   //set click listener later so it doesn't dismiss dialog
                .setTitle("Required Update").setMessage(context.getResources().getString(R.string.forceUpdateMessage));

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

        messageText.setTextColor(context.getResources().getColor(R.color.darkgray));

        yesButton.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View view) {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=com.workoutfree"));
                context.startActivity(browserIntent);
            }
        });
    }
}
