package com.appuccino.collegefeed.objects;

public class Tag {
	String name;
	int score;
	int id;
	
	public Tag()
	{
		name = "";
		score = 0;
	}
	
	public Tag(String n)
	{
		name = n;
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
	
	public int getID(){
		return id;
	}
}
