package com.appuccino.thecampusfeed.objects;

import android.net.Uri;
import android.util.JsonWriter;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.utils.TimeManager;

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
    private Uri imageUri;
    private int imageID;

    public Post(String m, int c)
    {
        score = 1;
        deltaScore = 1;
        message = m;
        time = TimeManager.now();
        collegeID = c;
        try{
            collegeName = MainActivity.getCollegeByID(collegeID).getName();
        }catch(Exception e){
        }
        webURL = "";
        appURL = "";
    }

    public Post(String m, int c, Uri imgUri)
    {
        score = 1;
        deltaScore = 1;
        message = m;
        time = TimeManager.now();
        collegeID = c;
        try{
            collegeName = MainActivity.getCollegeByID(collegeID).getName();
        }catch(Exception e){
        }
        webURL = "";
        appURL = "";
        imageUri = imgUri;
    }
	
	public Post(int id, String message, int score, int collegeID, String time)
	{
		this.score = score;
        deltaScore = 1;
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
			//TODO: IGNORE make call to get updated college list here
			collegeName = "";
		}
        //webURL = "www.thecampusfeed.com/posttest/" + id;
        webURL = "http://thecampusfeed.com/post/" + id;
        appURL = "thecampusfeed://posts/" + id;
	}
	
	public Post(int id, String message, int score, int deltaScore, int collegeID, String time, int commentCount, Uri uri, int d)
	{
        defaultVoteID = d;
		this.score = score;
        this.deltaScore = deltaScore;
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
			collegeName = "";
		}

        webURL = "http://thecampusfeed.com/post/" + id;
        appURL = "thecampusfeed://posts/" + id;
        if(uri != null && !uri.toString().isEmpty())
            this.imageUri = uri;
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

    public void setImageID(int id){
        imageID = id;
    }

    public void setImageUri(Uri uri){
        imageUri = uri;
    }
	
	public ArrayList<Comment> getCommentList()
	{
		return commentList;
	}

    public String getWebURL(){
        return webURL;
    }

    public Uri getImageUri(){
        return imageUri;
    }

    public String getAppURL(){
        return appURL;
    }

    @Override
    public ByteArrayOutputStream toJSONString() throws IOException {
        ByteArrayOutputStream ret = new ByteArrayOutputStream();
        JsonWriter writer = new JsonWriter(new OutputStreamWriter(ret, "UTF-8"));

        writer.setIndent("  ");
        writer.beginObject();
        writer.name("text"); writer.value(message);
        writer.name("user_token"); writer.value(0);
        writer.name("image_id"); writer.value(imageID);
        writer.endObject();
        writer.close();

        return ret;
    }
}
