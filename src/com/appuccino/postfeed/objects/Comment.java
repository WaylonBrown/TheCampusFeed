package com.appuccino.postfeed.objects;

public class Comment {
	int score;
	int id;
	String message;
	int hoursAgo;
	
	public Comment()
	{
		score = 0;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		message = "";
		hoursAgo = 0;
	}
	
	public Comment(String m)
	{
		score = 0;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		message = m;
		hoursAgo = 0;
	}

	public int getScore() {
		return score;
	}

	public int getId() {
		return id;
	}

	public String getMessage() {
		return message;
	}

	public int getHoursAgo() {
		return hoursAgo;
	}
}
