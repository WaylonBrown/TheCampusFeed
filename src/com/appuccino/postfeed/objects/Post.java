package com.appuccino.postfeed.objects;

import java.util.ArrayList;

public class Post {
	int score;
	String message;
	int hoursAgo;
	int id;
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	
	public Post()
	{
		score = 0;
		message = "";
		hoursAgo = 0;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		
		commentList.add(new Comment("test comment 1"));
		commentList.add(new Comment("test comment 2"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
	}
	
	public Post(String m)
	{
		message = m;
		score = 0;
		hoursAgo = 0;
		
		commentList.add(new Comment("test comment 1"));
		commentList.add(new Comment("test comment 2"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
	}
	
	public Post(int s, String m, int h)
	{
		score = s;
		message = m;
		hoursAgo = h;
		
		commentList.add(new Comment("test comment 1"));
		commentList.add(new Comment("test comment 2"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
		commentList.add(new Comment("test comment 3"));
	}
	
	public int getScore()
	{
		return score;
	}
	
	public String getMessage()
	{
		return message;
	}
	
	public int getHoursAgo()
	{
		return hoursAgo;
	}
	
	public int getID()
	{
		return id;
	}
	
	public ArrayList<Comment> getCommentList()
	{
		return commentList;
	}
}
