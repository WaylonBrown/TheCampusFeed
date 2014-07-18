package com.appuccino.collegefeed.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/*
 * This is used so that you don't have to set up the preference manager more than once throughout the app
 */
public class PrefManager {
	
	public static SharedPreferences prefs;
	public static final String UPVOTE_LIST = "upvote_list";
	public static final String DOWNVOTE_LIST = "downvote_list";
	public static final String COMMENT_UPVOTE_LIST = "comment_upvote_list";
	public static final String COMMENT_DOWNVOTE_LIST = "comment_downvote_list";
	public static final String FLAG_LIST = "flag_list";
    public static final String MY_POSTS_LIST = "my_votes_list";
    public static final String MY_COMMENTS_LIST = "my_comments_list";
	public static final String LAST_FEED = "last_feed";
    public static final String LAST_COLLEGE_UPDATE = "last_college_update";
	
	public static void setup(Context c) 
	{
		prefs = PreferenceManager.getDefaultSharedPreferences(c);
	}
	
	public static void putBoolean(String key, boolean value)
	{
		prefs.edit().putBoolean(key, value).apply();
	}
	
	public static boolean getBoolean(String key, boolean defaultVal)
	{
		return prefs.getBoolean(key, defaultVal);
	}
	
	public static void putInt(String key, int value)
	{
		prefs.edit().putInt(key, value).apply();
	}
	
	public static int getInt(String key, int defaultVal)
	{
		return prefs.getInt(key, defaultVal);
	}
	
	public static void putString(String key, String value)
	{
		prefs.edit().putString(key, value).apply();
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
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(UPVOTE_LIST, storage).apply();
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
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(DOWNVOTE_LIST, storage).apply();
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
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(COMMENT_UPVOTE_LIST, storage).apply();
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
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(COMMENT_DOWNVOTE_LIST, storage).apply();
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
	
	public static void putFlagList(List<Integer> list){
		String storage = "";
		for(int id : list){
			storage += (id + ";");
		}
		//remove final ;
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(FLAG_LIST, storage).apply();
	}
	
	public static List<Integer> getFlagList(){
		List<Integer> returnList = new ArrayList<Integer>();
		String retrieval = prefs.getString(FLAG_LIST, "");
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

    public static Calendar getLastCollegeListUpdate() {
        Calendar returnCal = Calendar.getInstance();
        String lastUpdateString = prefs.getString(LAST_COLLEGE_UPDATE, "");
        if(lastUpdateString.isEmpty()){
            return null;
        } else {
            //MM,DD,YYYY
            String[] splitString = lastUpdateString.split(",");
            returnCal.set(Calendar.WEEK_OF_MONTH, Integer.valueOf(splitString[0]));
            returnCal.set(Calendar.MONTH, Integer.valueOf(splitString[1]));
            returnCal.set(Calendar.DAY_OF_MONTH, Integer.valueOf(splitString[2]));
            returnCal.set(Calendar.YEAR, Integer.valueOf(splitString[3]));
            return returnCal;
        }
    }

    public static void putLastCollegeListUpdate(Calendar c){
        String storage = String.valueOf(c.get(Calendar.WEEK_OF_MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.DAY_OF_MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.YEAR));
        prefs.edit().putString(LAST_COLLEGE_UPDATE, storage).apply();
    }

    public static void putMyPosttList(){

    }

    public static ArrayList<Integer> getMyPostsList(){
        ArrayList<Integer> returnList = new ArrayList<Integer>();
        String stringList = prefs.getString(MY_POSTS_LIST, "");
        if(stringList.isEmpty()){
            return returnList;
        } else {
            String[] splitList = stringList.split(",");
            for(String s : splitList){
                try {
                    returnList.add(Integer.parseInt(s));
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
        return returnList;
    }

    public static ArrayList<Integer> getMyCommentsList(){
        ArrayList<Integer> returnList = new ArrayList<Integer>();
        String stringList = prefs.getString(MY_COMMENTS_LIST, "");
        if(stringList.isEmpty()){
            return returnList;
        } else {
            String[] splitList = stringList.split(",");
            for(String s : splitList){
                try {
                    returnList.add(Integer.parseInt(s));
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
        return returnList;
    }

    public static void putMyPostsList(List<Integer> list){
        String storage = "";
        if(list != null && list.size() > 0){
            for(int n : list){
                storage += (n + ",");
            }
            //remove final ,
            if(storage.length() > 0){
                storage = storage.substring(0, storage.length()-1);
            }
        }
        prefs.edit().putString(MY_POSTS_LIST, storage).apply();
    }

    public static void putMyCommentsList(List<Integer> list){
        String storage = "";
        if(list != null && list.size() > 0){
            for(int n : list){
                storage += (n + ",");
            }
            //remove final ,
            if(storage.length() > 0){
                storage = storage.substring(0, storage.length()-1);
            }
        }
        prefs.edit().putString(MY_COMMENTS_LIST, storage).apply();
    }
}
