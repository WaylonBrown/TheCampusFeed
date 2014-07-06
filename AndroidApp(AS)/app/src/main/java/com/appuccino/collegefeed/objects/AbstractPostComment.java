package com.appuccino.collegefeed.objects;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

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
	
	public ByteArrayOutputStream toJSONString() throws IOException{
		ByteArrayOutputStream ret = new ByteArrayOutputStream();
		JsonWriter writer = new JsonWriter(new OutputStreamWriter(ret, "UTF-8"));
		
		writer.setIndent("  ");
		writer.beginObject();
		writer.name("text"); writer.value(message);
		writer.endObject();
		writer.close();
		
		return ret;
	}
}
