package com.appuccino.thecampusfeed.objects;

import com.appuccino.thecampusfeed.utils.TimeManager;

public class Comment extends AbstractPostComment{

	int postID;
	
	public Comment()
    {
        score = 0;
        id = (int)(Math.random() * Integer.MAX_VALUE);
        message = "";
        time = TimeManager.now();
        collegeID = 234234;
    }

    public Comment(int s)
    {
        score = s;
        id = (int)(Math.random() * Integer.MAX_VALUE);
        message = "";
        time = TimeManager.now();
        collegeID = 234234;
    }
	
	public Comment(String message, int id, int parentID, int score, int deltaScore, int collegeID, String time, int d)
	{
        defaultVoteID = d;
		this.message = message;
		this.id = id;
		this.postID = parentID;
		this.score = score;
		this.collegeID = collegeID;
		this.time = time;
        this.deltaScore = deltaScore;
	}
	
	public int getPostID()
	{
		return postID;
	}
}
