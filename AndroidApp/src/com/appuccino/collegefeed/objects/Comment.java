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
	
	public Comment(String m, int parentID)
	{
		score = (int)(Math.random() * 100);;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		message = m;
		time = TimeManager.now();
		collegeID = 234234;
		this.postID = parentID;
	}
	
	public int getPostID()
	{
		return postID;
	}
}
