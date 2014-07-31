package com.appuccino.collegefeed.objects;

public class Vote 
{
    public int id;
	public int postID;
    public int commentID;    //only used for comment votes
	public boolean upvote;

	public Vote(int id, int postID, boolean upvote)
	{
		this.id = id;
        this.postID = id;
		this.upvote = upvote;
        this.commentID = 0;
	}

    //only used for comment votes
    public Vote(int id, int postID, int commentID, boolean upvote)
    {
        this.id = id;
        this.postID = postID;
        this.commentID = commentID;
        this.upvote = upvote;
    }

    //from savable format
    public Vote(String formatting){
        String[] split = formatting.split(",");
        try{
            this.id = Integer.valueOf(split[0]);
            this.postID = Integer.valueOf(split[1]);
            this.commentID = Integer.valueOf(split[2]);
            if(split[3].equals("1")){
                upvote = true;
            } else {
                upvote = false;
            }
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    public String toSavableFormat(){
        String upvoteString = "";
        if(upvote)
            upvoteString = "1";
        else
            upvoteString = "0";
        return id + "," + postID + "," + commentID + "," + upvoteString;
    }
}
