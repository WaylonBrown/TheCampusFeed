package com.appuccino.collegefeed.objects;

import android.util.JsonWriter;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.utils.TimeManager;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;

public class Post extends AbstractPostComment{

	private ArrayList<Comment> commentList = new ArrayList<Comment>();
    private String collegeName;
    private int commentCount = 0;
    private String webURL;
    private String appURL;
    private String phoneNumber;
	
	public Post(String m, int c, String p)
	{
		score = 1;
		message = m;
		time = TimeManager.now();
		collegeID = c;
		try{
			collegeName = MainActivity.getCollegeByID(collegeID).getName();
		}catch(Exception e){
		}
        webURL = "";
        appURL = "";
        phoneNumber = p;
	}
	
	public Post(int id, String message, int score, int collegeID, String time)
	{
		this.score = score;
		this.message = message;
		this.time = time;
		this.id = id;
		this.collegeID = collegeID;
		College thisCollege = MainActivity.getCollegeByID(collegeID);
		if(thisCollege != null){	//in case college isn't in list
			try{
				collegeName = MainActivity.getCollegeByID(collegeID).getName();
			}catch(Exception e){
			}
		}
		else
		{
			//TODO: make call to get updated college list here
			collegeName = "";
		}
        //webURL = "www.thecampusfeed.com/posttest/" + id;
        webURL = "http://cfeed.herokuapp.com/webapp";
        appURL = "thecampusfeed://posts/" + id;
	}
	
	public Post(int id, String message, int score, int collegeID, String time, int commentCount)
	{
		this.score = score;
		this.message = message;
		this.time = time;
		this.id = id;
		this.collegeID = collegeID;
		this.commentCount = commentCount;
		College thisCollege = MainActivity.getCollegeByID(collegeID);
		if(thisCollege != null){	//in case college isn't in list
			try{
				collegeName = MainActivity.getCollegeByID(collegeID).getName();
			}catch(Exception e){
			}
		}
		else
		{
			//TODO: make call to get updated college list here
			collegeName = "";
		}
        //webURL = "www.thecampusfeed.com/posttest/" + id;
        webURL = "http://cfeed.herokuapp.com/webapp";
        appURL = "thecampusfeed://posts/" + id;
	}

	
	public int getCommentCount() {
		return commentCount;
	}
	
	public String getCollegeName()
	{
		return collegeName;
	}

    public void setCollegeID(int id)
    {
        collegeID = id;
    }

    public void setCollegeName(String n)
    {
        collegeName = n;
    }
	
	public ArrayList<Comment> getCommentList()
	{
		return commentList;
	}

    public String getWebURL(){
        return webURL;
    }

    public String getAppURL(){
        return appURL;
    }

    public String getPhoneNumber(){
        return phoneNumber;
    }

    @Override
    public ByteArrayOutputStream toJSONString() throws IOException {
        ByteArrayOutputStream ret = new ByteArrayOutputStream();
        JsonWriter writer = new JsonWriter(new OutputStreamWriter(ret, "UTF-8"));

        writer.setIndent("  ");
        writer.beginObject();
        writer.name("text"); writer.value(message);
        writer.name("user_token"); writer.value(phoneNumber);
        writer.endObject();
        writer.close();

        return ret;
    }
}
