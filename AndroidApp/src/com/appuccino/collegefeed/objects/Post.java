package com.appuccino.collegefeed.objects;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;

import android.util.JsonWriter;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.utils.TimeManager;

public class Post extends AbstractPostComment{

	ArrayList<Comment> commentList = new ArrayList<Comment>();
	String collegeName;
	
	public Post(String m, int c)
	{
		score = 1;
		message = m;
		time = TimeManager.now();
		collegeID = c;
		collegeName = MainActivity.getCollegeByID(collegeID).getName();
		
//		int numberOfComments = (int)(Math.random() * 15);
//		for(int i = 0; i < numberOfComments; i++)
//			commentList.add(new Comment("test comment test comment test comment test comment test comment", this.id));
	}
	
	public Post(int id, String message, int score, int collegeID, String time)
	{
		this.score = score;
		this.message = message;
		this.time = time;
		this.id = id;
		this.collegeID = collegeID;
		College thisCollege = MainActivity.getCollegeByID(collegeID);
		if(thisCollege != null)	//in case college isn't in list
			collegeName = thisCollege.getName();
		else
		{
			//TODO: make call to get updated college list here
			collegeName = "";
		}
		
//		int numberOfComments = (int)(Math.random() * 15);
//		for(int i = 0; i < numberOfComments; i++)
//			commentList.add(new Comment("test comment test comment test comment test comment test comment", this.id));
	}
	
	public void addComment(Comment comment)
	{
		commentList.add(comment);
	}
	
	public String getCollegeName()
	{
		return collegeName;
	}
	
	public ArrayList<Comment> getCommentList()
	{
		return commentList;
	}

}
