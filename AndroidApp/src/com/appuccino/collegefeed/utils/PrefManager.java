package com.appuccino.collegefeed.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/*
 * This is used so that you don't have to set up the preference manager more than once throughout the app
 */
public class PrefManager {
	
	public static SharedPreferences prefs;
	
	public static void setup(Context c) 
	{
		prefs = PreferenceManager.getDefaultSharedPreferences(c);
	}
	
	public static void putBoolean(String key, boolean value)
	{
		prefs.edit().putBoolean(key, value).commit();
	}
	
	public static boolean getBoolean(String key, boolean defaultVal)
	{
		return prefs.getBoolean(key, defaultVal);
	}
	
	public static void putInt(String key, int value)
	{
		prefs.edit().putInt(key, value).commit();
	}
	
	public static int getInt(String key, int defaultVal)
	{
		return prefs.getInt(key, defaultVal);
	}
	
	public static void putString(String key, String value)
	{
		prefs.edit().putString(key, value).commit();
	}
	
	public static String getString(String key, String defaultVal)
	{
		return prefs.getString(key, defaultVal);
	}
}
