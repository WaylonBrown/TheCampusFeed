package com.appuccino.postfeed.objects;

public class Vote 
{
	public int id;
	public boolean upvote;
	public Vote(int id, boolean upvote){
		this.id = id;
		this.upvote = upvote;
	}
}
