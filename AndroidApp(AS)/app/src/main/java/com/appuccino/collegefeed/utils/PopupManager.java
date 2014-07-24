package com.appuccino.collegefeed.utils;

import android.util.Log;

/**
 * Created by Waylon on 7/23/2014.
 */
public class PopupManager {

    public static void run(){
        int runCount = PrefManager.getInt(PrefManager.APP_RUN_COUNT, 0);
        boolean firstDialogPrevDisplayed = PrefManager.getBoolean(PrefManager.FIRST_DIALOG_DISPLAYED, false);
        boolean secondDialogPrevDisplayed = PrefManager.getBoolean(PrefManager.SECOND_DIALOG_DISPLAYED, false);

        PrefManager.putInt(PrefManager.APP_RUN_COUNT, runCount + 1);

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
    }

    private static void displaySecondDialog() {
        Log.i("cfeed", "Displaying second dialog");
    }
}
