package com.appuccino.thecampusfeed.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.appuccino.thecampusfeed.objects.Vote;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

/*
 * This is used so that you don't have to set up the preference manager more than once throughout the app
 */
public class PrefManager {
	private static String defaultCheckSumString = "1";

	public static SharedPreferences prefs;
	public static final String POST_VOTE_LIST = "post_vote_list";
	public static final String COMMENT_VOTE_LIST = "comment_vote_list";
	public static final String FLAG_LIST = "flag_list";
    public static final String MY_POSTS_LIST = "my_votes_list";
    public static final String MY_COMMENTS_LIST = "my_comments_list";
	public static final String LAST_FEED = "last_feed";
    public static final String COLLEGE_LIST_CHECK_SUM = "college_list_check_sum";
    public static final String APP_RUN_COUNT = "app_run_count";
    public static final String FIRST_DIALOG_DISPLAYED = "first_displayed";
    public static final String SECOND_DIALOG_DISPLAYED = "second_displayed";
    public static final String LAST_POST_TIME = "last_post_time";
    public static final String LAST_COMMENT_TIME = "last_comment_time";
    public static final String TIME_CRUNCH_HOURS = "time_crunch_hours";
    public static final String TIME_CRUNCH_HOME_COLLEGE = "time_crunch_home_college";
    public static final String TIME_CRUNCH_ACTIVATED = "time_crunch_activated";
    public static final String TIME_CRUNCH_ACTIVATE_TIME = "time_crunch_activate_time";
	
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
	
	public static void putPostVoteList(List<Vote> list){
		String storage = "";
        //using iterator to get rid of concurrentmodificationexception
        for(Iterator<Vote> it = list.iterator(); it.hasNext();){
            Vote vote = it.next();
            storage += (vote.toSavableFormat() + ";");
        }

		//remove final ;
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(POST_VOTE_LIST, storage).apply();
	}
	
	public static List<Vote> getPostVoteList(){
		List<Vote> returnList = new ArrayList<Vote>();
		String retrieval = prefs.getString(POST_VOTE_LIST, "");
		if(retrieval != null && !retrieval.isEmpty()){
			String[] split = retrieval.split(";");
			for(String vote : split){
				try{
					returnList.add(new Vote(vote));
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return returnList;
	}
	
	public static void putCommentVoteList(List<Vote> list){
		String storage = "";
        //using iterator to get rid of concurrentmodificationexception
        for(Iterator<Vote> it = list.iterator(); it.hasNext();){
            Vote vote = it.next();
            storage += (vote.toSavableFormat() + ";");
        }

		//remove final ;
		if(storage.length() > 0){
			storage = storage.substring(0, storage.length()-1);
		}
		
		prefs.edit().putString(COMMENT_VOTE_LIST, storage).apply();
	}
	
	public static List<Vote> getCommentVoteList(){
		List<Vote> returnList = new ArrayList<Vote>();
		String retrieval = prefs.getString(COMMENT_VOTE_LIST, "");
		if(retrieval != null && !retrieval.isEmpty()){
			String[] split = retrieval.split(";");
			for(String vote : split){
				try{
					returnList.add(new Vote(vote));
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
	
	public static List<Integer> getFlagList() {
        List<Integer> returnList = new ArrayList<Integer>();
        String retrieval = prefs.getString(FLAG_LIST, "");
        if (retrieval != null && !retrieval.isEmpty()) {
            String[] split = retrieval.split(";");
            for (String id : split) {
                try {
                    returnList.add(Integer.valueOf(id));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return returnList;
    }

    public static String getCollegeListCheckSum(){
        return prefs.getString(COLLEGE_LIST_CHECK_SUM, defaultCheckSumString);
    }

    public static void putCollegeListCheckSum(String s){
        prefs.edit().putString(COLLEGE_LIST_CHECK_SUM, s).commit();
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

    public static Calendar getLastPostTime() {
        Calendar returnCal = Calendar.getInstance();
        String lastString = prefs.getString(LAST_POST_TIME, "");
        if(lastString.isEmpty()){
            return null;
        } else {
            //MM,DD,YYYY
            String[] splitString = lastString.split(",");
            returnCal.set(Calendar.SECOND, Integer.valueOf(splitString[0]));
            returnCal.set(Calendar.MINUTE, Integer.valueOf(splitString[1]));
            returnCal.set(Calendar.HOUR_OF_DAY, Integer.valueOf(splitString[2]));
            returnCal.set(Calendar.MONTH, Integer.valueOf(splitString[3]));
            returnCal.set(Calendar.DAY_OF_MONTH, Integer.valueOf(splitString[4]));
            returnCal.set(Calendar.YEAR, Integer.valueOf(splitString[5]));
            return returnCal;
        }
    }

    public static void putLastPostTime(Calendar c){
        String storage = String.valueOf(c.get(Calendar.SECOND)) +
                "," +
                String.valueOf(c.get(Calendar.MINUTE)) +
                "," +
                String.valueOf(c.get(Calendar.HOUR_OF_DAY)) +
                "," +
                String.valueOf(c.get(Calendar.MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.DAY_OF_MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.YEAR));
        prefs.edit().putString(LAST_POST_TIME, storage).apply();
    }

    public static Calendar getLastCommentTime() {
        Calendar returnCal = Calendar.getInstance();
        String lastString = prefs.getString(LAST_COMMENT_TIME, "");
        if(lastString.isEmpty()){
            return null;
        } else {
            //MM,DD,YYYY
            String[] splitString = lastString.split(",");
            returnCal.set(Calendar.SECOND, Integer.valueOf(splitString[0]));
            returnCal.set(Calendar.MINUTE, Integer.valueOf(splitString[1]));
            returnCal.set(Calendar.HOUR_OF_DAY, Integer.valueOf(splitString[2]));
            returnCal.set(Calendar.MONTH, Integer.valueOf(splitString[3]));
            returnCal.set(Calendar.DAY_OF_MONTH, Integer.valueOf(splitString[4]));
            returnCal.set(Calendar.YEAR, Integer.valueOf(splitString[5]));
            return returnCal;
        }
    }

    public static void putLastCommentTime(Calendar c){
        String storage = String.valueOf(c.get(Calendar.SECOND)) +
                "," +
                String.valueOf(c.get(Calendar.MINUTE)) +
                "," +
                String.valueOf(c.get(Calendar.HOUR_OF_DAY)) +
                "," +
                String.valueOf(c.get(Calendar.MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.DAY_OF_MONTH)) +
                "," +
                String.valueOf(c.get(Calendar.YEAR));
        prefs.edit().putString(LAST_COMMENT_TIME, storage).apply();
    }

    public static Calendar getTimeCrunchActivateTimestamp() {
        Calendar returnCal = Calendar.getInstance();
        String lastString = prefs.getString(TIME_CRUNCH_ACTIVATE_TIME, "");
        if(lastString.isEmpty()){
            return null;
        } else {
            //MM,DD,YYYY
            String[] splitString = lastString.split(",");
            returnCal.set(Calendar.SECOND, Integer.valueOf(splitString[0]));
            returnCal.set(Calendar.MINUTE, Integer.valueOf(splitString[1]));
            returnCal.set(Calendar.HOUR_OF_DAY, Integer.valueOf(splitString[2]));
            returnCal.set(Calendar.MONTH, Integer.valueOf(splitString[3]));
            returnCal.set(Calendar.DAY_OF_MONTH, Integer.valueOf(splitString[4]));
            returnCal.set(Calendar.YEAR, Integer.valueOf(splitString[5]));
            return returnCal;
        }
    }

    public static void putTimeCrunchActivateTimestamp(Calendar c){
        if(c != null){
            String storage = String.valueOf(c.get(Calendar.SECOND)) +
                    "," +
                    String.valueOf(c.get(Calendar.MINUTE)) +
                    "," +
                    String.valueOf(c.get(Calendar.HOUR_OF_DAY)) +
                    "," +
                    String.valueOf(c.get(Calendar.MONTH)) +
                    "," +
                    String.valueOf(c.get(Calendar.DAY_OF_MONTH)) +
                    "," +
                    String.valueOf(c.get(Calendar.YEAR));
            prefs.edit().putString(TIME_CRUNCH_ACTIVATE_TIME, storage).apply();
        } else {
            prefs.edit().putString(TIME_CRUNCH_ACTIVATE_TIME, "").apply();
        }
    }
}
