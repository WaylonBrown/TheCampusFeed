package com.appuccino.collegefeed.utils;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/*
 * This is used so that you don't have to set up the preference manager more than once throughout the app
 */
public class PrefManager {
	
	public static SharedPreferences prefs;
	public static final String UPVOTE_LIST = "upvote_list";
	public static final String DOWNVOTE_LIST = "downvote_list";
	public static final String COMMENT_UPVOTE_LIST = "comment_upvote_list";
	public static final String COMMENT_DOWNVOTE_LIST = "comment_downvote_list";
	
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
	
	public static void putPostUpvoteList(List<Integer> list){
		String storage = "";
		for(int id : list){
			storage += (id + ";");
		}
		//remove final ;
		storage = storage.substring(0, storage.length()-1);
		
		prefs.edit().putString(UPVOTE_LIST, storage).commit();
	}
	
	public static List<Integer> getPostUpvoteList(){
		List<Integer> returnList = new ArrayList<Integer>();
		String retrieval = prefs.getString(UPVOTE_LIST, "");
		if(retrieval != null && !retrieval.isEmpty()){
			String[] split = retrieval.split(";");
			for(String id : split){
				try{
					returnList.add(Integer.valueOf(id));
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return returnList;
	}
	
	public static void putPostDownvoteList(List<Integer> list){
		String storage = "";
		for(int id : list){
			storage += (id + ";");
		}
		//remove final ;
		storage = storage.substring(0, storage.length()-1);
		
		prefs.edit().putString(DOWNVOTE_LIST, storage).commit();
	}
	
	public static List<Integer> getPostDownvoteList(){
		List<Integer> returnList = new ArrayList<Integer>();
		String retrieval = prefs.getString(DOWNVOTE_LIST, "");
		if(retrieval != null && !retrieval.isEmpty()){
			String[] split = retrieval.split(";");
			for(String id : split){
				try{
					returnList.add(Integer.valueOf(id));
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return returnList;
	}
	
	public static void putCommentUpvoteList(List<Integer> list){
		String storage = "";
		for(int id : list){
			storage += (id + ";");
		}
		//remove final ;
		storage = storage.substring(0, storage.length()-1);
		
		prefs.edit().putString(COMMENT_UPVOTE_LIST, storage).commit();
	}
	
	public static List<Integer> getCommentUpvoteList(){
		List<Integer> returnList = new ArrayList<Integer>();
		String retrieval = prefs.getString(COMMENT_UPVOTE_LIST, "");
		if(retrieval != null && !retrieval.isEmpty()){
			String[] split = retrieval.split(";");
			for(String id : split){
				try{
					returnList.add(Integer.valueOf(id));
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return returnList;
	}
	
	public static void putCommentDownvoteList(List<Integer> list){
		String storage = "";
		for(int id : list){
			storage += (id + ";");
		}
		//remove final ;
		storage = storage.substring(0, storage.length()-1);
		
		prefs.edit().putString(COMMENT_DOWNVOTE_LIST, storage).commit();
	}
	
	public static List<Integer> getCommentDownvoteList(){
		List<Integer> returnList = new ArrayList<Integer>();
		String retrieval = prefs.getString(COMMENT_DOWNVOTE_LIST, "");
		if(retrieval != null && !retrieval.isEmpty()){
			String[] split = retrieval.split(";");
			for(String id : split){
				try{
					returnList.add(Integer.valueOf(id));
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return returnList;
	}
}
