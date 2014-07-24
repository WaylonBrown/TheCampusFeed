package com.appuccino.collegefeed.objects;

public class Vote 
{
	public int id;
    public int parentID;    //only used for comment votes
	public boolean upvote;
	
	public Vote(int id, boolean upvote)
	{
		this.id = id;
		this.upvote = upvote;
	}

    public Vote(int id, int parentID, boolean upvote)
    {
        this.id = id;
        this.parentID = parentID;
        this.upvote = upvote;
    }
}
