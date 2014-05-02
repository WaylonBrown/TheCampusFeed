package com.appuccino.collegefeed.objects;

public class Tag implements Votable{
	String name;
	int score;
	int id;
	
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
	
	@Override
	public int getID(){
		return id;
	}
}
