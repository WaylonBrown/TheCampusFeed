package com.appuccino.postfeed;

public class Tag {
	String name;
	int score;
	
	public Tag()
	{
		name = "";
		score = 0;
	}
	
	public Tag(String n, int s)
	{
		name = n;
		score = s;
	}
	
	String getText()
	{
		return name;
	}
	
	int getScore()
	{
		return score;
	}
}
