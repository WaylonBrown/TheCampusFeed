package com.appuccino.thecampusfeed.adapters;

import android.app.Activity;
import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.objects.Vote;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.NetWorker.MakePostVoteDeleteTask;
import com.appuccino.thecampusfeed.utils.NetWorker.MakePostVoteTask;
import com.appuccino.thecampusfeed.utils.TimeManager;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class PostListAdapter extends ArrayAdapter<Post>{

	Context context; 
    int layoutResourceId;    
    List<Post> postList = null;
    public List<Integer> idList = new ArrayList<Integer>();
    int whichList = 0;	//0 = toppostfrag, 1 = newpostfrag, 2 = mypostfrag
    int currentFeedID;
    
    public PostListAdapter(Context context, int layoutResourceId, List<Post> list, int whichList, int currentFeedID) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        postList = list;
        this.whichList = whichList;
        this.currentFeedID = currentFeedID;
    }

    public void addIfNotAdded(Post p){
        if(!idList.contains(p.getID())){
            add(p);
            idList.add(p.getID());
        }
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;	//this is listview_item_row
        PostHolder postHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	postHolder = new PostHolder();
        	postHolder.scoreText = (TextView)row.findViewById(R.id.scoreText);
        	postHolder.messageText = (TextView)row.findViewById(R.id.messageText);
        	postHolder.timeText = (TextView)row.findViewById(R.id.timeText);
        	postHolder.commentText = (TextView)row.findViewById(R.id.commentText);
        	postHolder.arrowUp = (ImageView)row.findViewById(R.id.arrowUp);
        	postHolder.arrowDown = (ImageView)row.findViewById(R.id.arrowDown);
        	postHolder.collegeName = (TextView)row.findViewById(R.id.collegeNameText);
        	postHolder.gpsImage = (ImageView)row.findViewById(R.id.gpsImage);
        	postHolder.gpsImageGap = row.findViewById(R.id.gpsImageGapFiller);
        	postHolder.bottomDivider = row.findViewById(R.id.bottomDivider);
        	postHolder.bottomPadding = row.findViewById(R.id.bottomPadding);
        	postHolder.bottomLayout = (LinearLayout)row.findViewById(R.id.bottomLayout);
            
            postHolder.scoreText.setTypeface(FontManager.bold);
            postHolder.messageText.setTypeface(FontManager.light);
            postHolder.timeText.setTypeface(FontManager.medium);
            postHolder.commentText.setTypeface(FontManager.medium);
            if(postHolder.collegeName != null)
            	postHolder.collegeName.setTypeface(FontManager.italic);
            
            row.setTag(postHolder);
        }
        else
        	postHolder = (PostHolder)row.getTag();
        
        final Post thisPost = postList.get(position);
        postHolder.scoreText.setText(String.valueOf(thisPost.getDeltaScore()));
        if(postHolder.scoreText.getText().toString().length() > 3){
            postHolder.scoreText.setTextSize(14f);
        }

        if(postHolder.collegeName != null)
        	postHolder.collegeName.setText(thisPost.getCollegeName());
        if(postHolder.gpsImage != null){
        	setGPSImageVisibility(postHolder, thisPost);
        }
        
        String commentString = thisPost.getCommentCount() + " comment";
        if(thisPost.getCommentCount() != 1)
        	commentString += "s";
        postHolder.commentText.setText(commentString);
        
        //dont show bottom part of post
        if(currentFeedID != MainActivity.ALL_COLLEGES){
        	postHolder.bottomDivider.setVisibility(View.GONE);
        	postHolder.bottomLayout.setVisibility(View.GONE);
        	postHolder.bottomPadding.setVisibility(View.VISIBLE);
        	postHolder.collegeName.setVisibility(View.GONE);
        }else{
        	postHolder.bottomDivider.setVisibility(View.VISIBLE);
        	postHolder.bottomLayout.setVisibility(View.VISIBLE);
        	postHolder.bottomPadding.setVisibility(View.GONE);
        	postHolder.collegeName.setVisibility(View.VISIBLE);
        }
        
        setMessageAndColorizeTags(thisPost.getMessage(), postHolder);
        try {
			setTime(thisPost, postHolder.timeText);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        
        //arrow click listeners
        final PostHolder finalPostHolder = postHolder;
        final View finalRow = row;
        postHolder.arrowUp.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
                int currentVote = MainActivity.getVoteByPostId(thisPost.getID());

				//if already upvoted, un-upvote
				if(currentVote == -1)
				{
					thisPost.setVote(1);
					thisPost.score += 2;
                    thisPost.deltaScore += 2;
                    updateRowViews(finalRow, finalPostHolder, 1, thisPost);
                    new MakePostVoteDeleteTask(context).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                    new MakePostVoteTask(context).execute(new Vote(0, thisPost.getID(), true));
				}
				else if(currentVote == 0)
				{
					thisPost.setVote(1);
					thisPost.score++;
                    thisPost.deltaScore++;
                    updateRowViews(finalRow, finalPostHolder, 1, thisPost);
                    new MakePostVoteTask(context).execute(new Vote(0, thisPost.getID(), true));
				}
				else 
				{
					thisPost.setVote(0);
					thisPost.score--;
                    thisPost.deltaScore--;
                    updateRowViews(finalRow, finalPostHolder, 0, thisPost);
                    new MakePostVoteDeleteTask(context).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                }
			}
        });
        postHolder.arrowDown.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) 
			{
				if(MainActivity.hasPermissions(thisPost.getCollegeID()))
				{
                    int currentVote = MainActivity.getVoteByPostId(thisPost.getID());

					//if already downvoted, un-downvote
					if(currentVote == -1)
					{
						thisPost.setVote(0);
                        thisPost.score++;
                        thisPost.deltaScore++;
                        updateRowViews(finalRow, finalPostHolder, 0, thisPost);
                        new MakePostVoteDeleteTask(context).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                    }
					else if(currentVote == 0)
					{
						thisPost.setVote(-1);
						thisPost.score--;
                        thisPost.deltaScore--;
                        updateRowViews(finalRow, finalPostHolder, -1, thisPost);
                        new MakePostVoteTask(context).execute(new Vote(0, thisPost.getID(), false));
                    }
					else 
					{
						thisPost.setVote(-1);
						thisPost.score -= 2;
                        thisPost.deltaScore -= 2;
                        updateRowViews(finalRow, finalPostHolder, -1, thisPost);
                        new MakePostVoteDeleteTask(context).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                        new MakePostVoteTask(context).execute(new Vote(0, thisPost.getID(), false));
                    }
				}
				else
				{
					Toast.makeText(context, "You need to be near the college to downvote", Toast.LENGTH_LONG).show();
				}
			}        	
        });
        
        thisPost.setVote(MainActivity.getVoteByPostId(thisPost.getID()));
        int vote = thisPost.getVote();

        updateRowViews(finalRow, postHolder, vote, thisPost);

        return row;
    }

    private void updateRowViews(View row, PostHolder postHolder, int vote, Post post) {
        int score = post.getDeltaScore();

        if(vote == -1)
        {
            postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
            postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdownred));
        }
        else if (vote == 1)
        {
            postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowupblue));
            postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }
        else	//no votes
        {
            postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
            postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }

        postHolder.scoreText.setText(String.valueOf(score));

        row.invalidate();
    }

    private void setTime(Post thisPost, TextView timeText) throws ParseException {
    	Calendar thisPostTime = TimeManager.toCalendar(thisPost.getTime());
    	Calendar now = Calendar.getInstance();

//        int timeZoneDifferenceinMS = TimeZone.getTimeZone("GMT-6").getOffset(Calendar.ZONE_OFFSET) - TimeZone.getDefault().getOffset(Calendar.ZONE_OFFSET);
//        Double timeZoneDifferenceinS = timeZoneDifferenceinMS / 1000.0;
//        Double timeZoneDifferenceinH = timeZoneDifferenceinS / 3600.0;
//        Log.i("cfeed", "timezone: " + timeZoneDifferenceinH);
    	
    	int yearsDiff;
    	int monthsDiff;
    	int weeksDiff;
    	int daysDiff;
    	int hoursDiff;
    	int minutesDiff;
    	int secondsDiff;
    	
    	yearsDiff = now.get(Calendar.YEAR) - thisPostTime.get(Calendar.YEAR);
    	monthsDiff = now.get(Calendar.MONTH) - thisPostTime.get(Calendar.MONTH);
    	weeksDiff = now.get(Calendar.WEEK_OF_YEAR) - thisPostTime.get(Calendar.WEEK_OF_YEAR);
    	daysDiff = now.get(Calendar.DAY_OF_YEAR) - thisPostTime.get(Calendar.DAY_OF_YEAR);
    	hoursDiff = now.get(Calendar.HOUR_OF_DAY) - thisPostTime.get(Calendar.HOUR_OF_DAY);
    	minutesDiff = now.get(Calendar.MINUTE) - thisPostTime.get(Calendar.MINUTE);
    	secondsDiff = now.get(Calendar.SECOND) - thisPostTime.get(Calendar.SECOND);

//    	Log.i("cfeed","Time difference for post " + thisPost.getMessage().substring(0, 10) + ": Years: " + yearsDiff + " Months: " + monthsDiff +
//    			" Weeks: " + weeksDiff + " Days: " + daysDiff + " Hours: " + hoursDiff + " Minutes: " + minutesDiff + " Seconds: " + secondsDiff);
    	
    	String timeOutputText = "";
    	if(yearsDiff > 0){
    		timeOutputText = yearsDiff + " year";
    		if(yearsDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(monthsDiff > 0){
    		timeOutputText = monthsDiff + " month";
    		if(monthsDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(weeksDiff > 0){
    		timeOutputText = weeksDiff + " week";
    		if(weeksDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(daysDiff > 0){
    		timeOutputText = daysDiff + " day";
    		if(daysDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(hoursDiff > 0){
    		timeOutputText = hoursDiff + " hour";
    		if(hoursDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(minutesDiff > 0){
    		timeOutputText = minutesDiff + " minute";
    		if(minutesDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else if(secondsDiff > 0){
    		timeOutputText = secondsDiff + " second";
    		if(secondsDiff > 1){
    			timeOutputText += "s";
    		}
    		timeOutputText += " ago";
    	}
    	else{
    		timeOutputText = "Just now";
    	}
    	
    	timeText.setText(timeOutputText);
	}

	private void setGPSImageVisibility(PostHolder holder, Post thisPost) 
    {
		if(MainActivity.permissions == null)
		{
			holder.gpsImage.setVisibility(View.GONE);
			holder.gpsImageGap.setVisibility(View.GONE);
		}
		else if(!MainActivity.hasPermissions(thisPost.getCollegeID()))
		{
			holder.gpsImage.setVisibility(View.GONE);
			holder.gpsImageGap.setVisibility(View.GONE);
		}
		else
		{
			holder.gpsImage.setVisibility(View.VISIBLE);
			holder.gpsImageGap.setVisibility(View.VISIBLE);
		}
	}

    void setMessageAndColorizeTags(String msg, PostHolder postHolder)
    {
        String tagColor = "#33B5E5";
        String message = msg;

        String[] tagArray = MainActivity.parseTagsWithRegex(message);
        for(int i = 0; i < tagArray.length; i++){
            int foundIndex = message.indexOf(tagArray[i]);
            int messageCharLength = message.length();
            //if tag from tagArray is in the message
            if(foundIndex != -1){
                //add HTML coloring to where the tag is
                message = message.substring(0, foundIndex) + "<font color='" + tagColor + "'>" + message.substring(foundIndex, foundIndex + tagArray[i].length()) + "</font>" + message.substring(foundIndex + tagArray[i].length(), messageCharLength);
            }
        }

//    	String[] wordArray = message.split(" ");
//    	//check for tags, colorize them
//    	for(int i = 0; i < wordArray.length; i++)
//    	{
//    		if(wordArray[i].length() > 0)	//in case empty, doesn't throw nullpointer
//    		{
//    			if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1 && !MainActivity.containsSymbols(wordArray[i].substring(1, wordArray[i].length())))
//        		{
//        			wordArray[i] = "<font color='" + tagColor + "'>" + wordArray[i] + "</font>";
//        		}
//    		}
//    	}
//
//    	message = "";
//    	//combine back to string
//    	for(int i = 0; i < wordArray.length; i++)
//    	{
//    		message += wordArray[i] + " ";
//    	}

        postHolder.messageText.setText(Html.fromHtml(message));
    }
    
    public void setCollegeFeedID(int id){
    	currentFeedID = id;
    }

	static class PostHolder
    {
    	TextView scoreText;
    	TextView messageText;
    	TextView timeText;
    	TextView commentText;
    	TextView collegeName;
    	ImageView arrowUp;
    	ImageView arrowDown;
    	ImageView gpsImage;
    	View gpsImageGap;
    	View bottomDivider;
    	View bottomPadding;
    	LinearLayout bottomLayout;
    }
}
