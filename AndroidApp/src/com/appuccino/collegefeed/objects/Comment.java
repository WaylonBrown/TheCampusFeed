package com.appuccino.collegefeed.objects;

public class Comment {
	int score;
	int id;
	String message;
	int hoursAgo;
	int vote = 0;	//-1 = downvote, 0 = nothing, 1 = upvote
	
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
	
	public void setVote(int vote)
	{
		this.vote = vote;
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
	
	public int getVote()
	{
		return vote;
	}
}
