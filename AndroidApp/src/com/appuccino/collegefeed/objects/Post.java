package com.appuccino.collegefeed.objects;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;

import android.util.JsonReader;

public class Post implements Votable{
	int score;
	String message;
	int hoursAgo;
	int id;
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	int vote = 0;		//-1 = downvote, 0 = nothing, 1 = upvote
	int collegeID;
	String collegeName;
	
	public Post()
	{
		score = 0;
		message = "";
		hoursAgo = 0;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		collegeID = 234234;
		collegeName = "Texas A&M University";
		
		int numberOfComments = (int)(Math.random() * 15);
		for(int i = 0; i < numberOfComments; i++)
			commentList.add(new Comment("test comment test comment test comment test comment test comment"));
	}
	
	public Post(String m)
	{
		message = m;
		score = 0;
		hoursAgo = 0;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		collegeID = 234234;
		collegeName = "Texas A&M University";
		
		int numberOfComments = (int)(Math.random() * 15);
		for(int i = 0; i < numberOfComments; i++)
			commentList.add(new Comment("test comment test comment test comment test comment test comment"));
	}
	
	public Post(int s, String m, int h)
	{
		score = s;
		message = m;
		hoursAgo = h;
		id = (int)(Math.random() * Integer.MAX_VALUE);
		collegeID = 234234;
		collegeName = "Texas A&M University";
		
		int numberOfComments = (int)(Math.random() * 15);
		for(int i = 0; i < numberOfComments; i++)
			commentList.add(new Comment("test comment test comment test comment test comment test comment"));
	}
	
	public static ArrayList<Post> postsFromJson(String json) throws IOException{
		ArrayList<Post> ret = new ArrayList<Post>();
		JsonReader reader = new JsonReader(new StringReader(json));
		
		try {
			reader.beginArray();
			while(reader.hasNext()){
				
				Integer id = null;
				String text = null;
				Integer score = null;
				
				reader.beginObject();
				while(reader.hasNext()){
					String name = reader.nextName(); //property name of next property.
					if(name.equals("id")){
						id = reader.nextInt();
					}
					else if(name.equals("text")){
						text = reader.nextString();
					}
					else{
						reader.skipValue();
					}
				}
				reader.endObject();
				
				ret.add(new Post(0,text,2));
			}
			reader.endArray();
		} finally{
			reader.close();
		}
		
		return ret;
	}
	
	public void setVote(int vote)
	{
		this.vote = vote;
	}
	
	public int getScore()
	{
		return score;
	}
	
	public String getMessage()
	{
		return message;
	}
	
	public String getCollegeName()
	{
		return collegeName;
	}
	
	public int getCollegeID()
	{
		return collegeID;
	}
	
	public int getHoursAgo()
	{
		return hoursAgo;
	}
	
	@Override
	public int getID()
	{
		return id;
	}
	
	public ArrayList<Comment> getCommentList()
	{
		return commentList;
	}
	
	public int getVote()
	{
		return vote;
	}
}
