package com.appuccino.postfeed.objects;

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
	
	public String getText()
	{
		return name;
	}
	
	int getScore()
	{
		return score;
	}
}
