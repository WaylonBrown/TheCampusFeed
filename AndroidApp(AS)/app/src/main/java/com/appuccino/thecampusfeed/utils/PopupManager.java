package com.appuccino.thecampusfeed.utils;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;

/**
 * Created by Waylon on 7/23/2014.
 */
public class PopupManager {

    static Context context;

    public static void run(Context c){
        context = c;

        int runCount = PrefManager.getInt(PrefManager.APP_RUN_COUNT, 0);
        boolean firstDialogPrevDisplayed = PrefManager.getBoolean(PrefManager.FIRST_DIALOG_DISPLAYED, false);
        boolean secondDialogPrevDisplayed = PrefManager.getBoolean(PrefManager.SECOND_DIALOG_DISPLAYED, false);

        runCount++;
        PrefManager.putInt(PrefManager.APP_RUN_COUNT, runCount);

        Log.i("cfeed", "App run count: " + runCount);

        //never display one of these dialog on the very first run
        if(runCount != 0){
            //every 5 times
            if(runCount % 5 == 0){
                if(!firstDialogPrevDisplayed){
                    displayFirstDialog();
                    PrefManager.putBoolean(PrefManager.FIRST_DIALOG_DISPLAYED, true);
                } else if (!secondDialogPrevDisplayed) {
                    displaySecondDialog();
                    PrefManager.putBoolean(PrefManager.SECOND_DIALOG_DISPLAYED, true);
                }
            }
        }
    }

    private static void displayFirstDialog() {
        Log.i("cfeed", "Displaying first dialog");
        AlertDialog.Builder dialog = new AlertDialog.Builder(context)
                .setTitle("Follow TheCampusFeed on Twitter!")
                .setMessage(R.string.twitterMessage)
                .setPositiveButton("Follow on Twitter", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        goToTwitter();
                        dialogInterface.dismiss();
                    }
                })
                .setNegativeButton("No thanks", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });
        AlertDialog alertDialog = dialog.create();
        alertDialog.show();

        TextView titleText = (TextView) alertDialog.findViewById(context.getResources().getIdentifier("alertTitle", "id", "android"));
        TextView messageText = (TextView)alertDialog.findViewById(android.R.id.message);
        Button yesButton = alertDialog.getButton(AlertDialog.BUTTON_POSITIVE);
        Button noButton = alertDialog.getButton(AlertDialog.BUTTON_NEGATIVE);

        titleText.setTypeface(FontManager.light);
        messageText.setTypeface(FontManager.light);
        yesButton.setTypeface(FontManager.light);
        noButton.setTypeface(FontManager.light);
    }

    private static void displaySecondDialog() {
        Log.i("cfeed", "Displaying second dialog");
        LayoutInflater inflater = ((MainActivity)context).getLayoutInflater();
        View dialogLayout = inflater.inflate(R.layout.web_dialog_layout, null);

        AlertDialog.Builder dialog = new AlertDialog.Builder(context)
                .setTitle("Don't forget TheCampusFeed is also on the web!")
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });
        dialog.setView(dialogLayout);
        AlertDialog alertDialog = dialog.create();
        alertDialog.show();

        TextView titleText = (TextView) alertDialog.findViewById(context.getResources().getIdentifier("alertTitle", "id", "android"));
        TextView messageText = (TextView)dialogLayout.findViewById(R.id.webDialogMessage);
        Button yesButton = alertDialog.getButton(AlertDialog.BUTTON_POSITIVE);

        titleText.setTypeface(FontManager.light);
        messageText.setTypeface(FontManager.light);
        yesButton.setTypeface(FontManager.light);
    }

    private static void goToTwitter(){
        Intent browse = new Intent( Intent.ACTION_VIEW , Uri.parse("https://twitter.com/The_Campus_Feed") );
        context.startActivity(browse);
    }
}
