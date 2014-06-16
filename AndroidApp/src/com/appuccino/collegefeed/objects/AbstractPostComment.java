package com.appuccino.collegefeed.objects;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.util.ArrayList;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.utils.TimeManager;

import android.util.JsonReader;
import android.util.JsonWriter;

public class AbstractPostComment {
	public int score = 0;
	String message = "";
	String time = "";
	int id = 0;
	int vote = 0;		//-1 = downvote, 0 = nothing, 1 = upvote
	int collegeID = 0;
	
	public void setVote(int vote)
	{
		this.vote = vote;
	}
	
	public int getScore()
	{
		return score;
	}
	
	public String getMessage()
	{
		return message;
	}
	
	public int getCollegeID()
	{
		return collegeID;
	}
	
	public String getTime()
	{
		return time;
	}
	
	public int getID()
	{
		return id;
	}
	
	public int getVote()
	{
		return vote;
	}
}
