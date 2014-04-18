package com.appuccino.postfeed;

public class Post {
	int score;
	String message;
	int hoursAgo;
	
	public Post()
	{
		score = 0;
		message = "";
		hoursAgo = 0;
	}
	
	public Post(int s, String m, int h)
	{
		score = s;
		message = m;
		hoursAgo = h;
	}
	
	int getScore()
	{
		return score;
	}
	
	String getMessage()
	{
		return message;
	}
	
	int getHoursAgo()
	{
		return hoursAgo;
	}
}
