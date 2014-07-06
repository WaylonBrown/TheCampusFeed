package com.appuccino.collegefeed.objects;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

import android.util.JsonWriter;

import com.appuccino.collegefeed.utils.TimeManager;

public class Comment extends AbstractPostComment{

	int postID;
	
	public Comment()
	{
		score = 0;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		message = "";
		time = TimeManager.now();
		collegeID = 234234;
	}
	
	public Comment(String message, int id, int parentID, int score, int collegeID, String time)
	{
		this.message = message;
		this.id = id;
		this.postID = parentID;
		this.score = score;
		this.collegeID = collegeID;
		this.time = time;
	}
	
	public int getPostID()
	{
		return postID;
	}
}