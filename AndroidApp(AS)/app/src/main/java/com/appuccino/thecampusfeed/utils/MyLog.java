package com.appuccino.thecampusfeed.utils;

import android.util.Log;

/**
 * Created by waylonbrown on 9/15/14.
 */
public class MyLog {
    private static String LOG_TAG = "cfeed";

    public static void i(String m){
        Log.i(LOG_TAG, m);
    }

    public static void e(String m){
        Log.e(LOG_TAG, m);
    }

    public static void d(String m){
        Log.d(LOG_TAG, m);
    }
}
