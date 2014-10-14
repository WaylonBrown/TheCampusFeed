package com.appuccino.thecampusfeed.adapters;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.text.Html;
import android.util.Log;
import android.util.TypedValue;
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
import com.squareup.picasso.Picasso;

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
            postHolder.postImage = (ImageView)row.findViewById(R.id.postImage);
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

        //set image if images are enabled
        if(MainActivity.PICTURE_MODE && thisPost.getImageUri() != null){
//            try {
//                final InputStream imageStream = context.getContentResolver().openInputStream(thisPost.getImageUri());
//                final Bitmap selectedImage = BitmapFactory.decodeStream(imageStream);
//                postHolder.postImage.setImageBitmap(selectedImage);
//                postHolder.postImage.setVisibility(View.VISIBLE);
//                if(thisPost.getMessage() == null || thisPost.getMessage().isEmpty()){
//                    postHolder.messageText.setVisibility(View.GONE);
//                } else {
//                    postHolder.messageText.setVisibility(View.VISIBLE);
//                }
//
//            } catch (FileNotFoundException e) {
//                e.printStackTrace();
//            }

            Picasso.with(context).load(thisPost.getImageUri()).into(postHolder.postImage);
            postHolder.postImage.setVisibility(View.VISIBLE);
            if(thisPost.getMessage() == null || thisPost.getMessage().isEmpty()){
                postHolder.messageText.setVisibility(View.GONE);
            } else {
                postHolder.messageText.setVisibility(View.VISIBLE);
            }
            postHolder.postImage.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    //new
                }
            });

            //dont need minimum height with image, so just set to 1
            Resources r = context.getResources();
            float px = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 1, r.getDisplayMetrics());
            postHolder.messageText.setMinimumHeight(Math.round(px));
        } else {
            postHolder.postImage.setVisibility(View.GONE);
            //set the minimum height to 60 so that it pushes down bottom part of post
            Resources r = context.getResources();
            float px = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50, r.getDisplayMetrics());
            postHolder.messageText.setMinimumHeight(Math.round(px));
        }

        //TESTING: use to make every post have an image
        Resources r = context.getResources();
        float px = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 1, r.getDisplayMetrics());
        postHolder.messageText.setMinimumHeight(Math.round(px));
        Picasso.with(context).load(R.drawable.harleytest).into(postHolder.postImage);
        postHolder.postImage.setVisibility(View.VISIBLE);

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
                Log.i("cfeed","Clicked arrow when vote was " + currentVote + ", list size was " + MainActivity.postVoteList.size());
				//if already upvoted, un-upvote
				if(currentVote == -1)
				{
					thisPost.setVote(1);
					thisPost.score += 2;
                    thisPost.deltaScore += 2;
                    updateRowViews(finalRow, finalPostHolder, 1, thisPost);
                    new MakePostVoteDeleteTask(context, MainActivity.voteObjectFromPostID(thisPost.getID()).id, thisPost.getID()).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                    new MakePostVoteTask(context).execute(new Vote(-1, thisPost.getID(), true));
				}
				else if(currentVote == 0)
				{
					thisPost.setVote(1);
					thisPost.score++;
                    thisPost.deltaScore++;
                    updateRowViews(finalRow, finalPostHolder, 1, thisPost);
                    new MakePostVoteTask(context).execute(new Vote(-1, thisPost.getID(), true));
				}
				else 
				{
					thisPost.setVote(0);
					thisPost.score--;
                    thisPost.deltaScore--;
                    updateRowViews(finalRow, finalPostHolder, 0, thisPost);
                    new MakePostVoteDeleteTask(context, MainActivity.voteObjectFromPostID(thisPost.getID()).id, thisPost.getID()).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
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
                    Log.i("cfeed","Clicked arrow when vote was " + currentVote + ", list size was " + MainActivity.postVoteList.size());

					//if already downvoted, un-downvote
					if(currentVote == -1)
					{
						thisPost.setVote(0);
                        thisPost.score++;
                        thisPost.deltaScore++;
                        updateRowViews(finalRow, finalPostHolder, 0, thisPost);
                        new MakePostVoteDeleteTask(context, MainActivity.voteObjectFromPostID(thisPost.getID()).id, thisPost.getID()).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                    }
					else if(currentVote == 0)
					{
						thisPost.setVote(-1);
						thisPost.score--;
                        thisPost.deltaScore--;
                        updateRowViews(finalRow, finalPostHolder, -1, thisPost);
                        new MakePostVoteTask(context).execute(new Vote(-1, thisPost.getID(), false));
                    }
					else 
					{
						thisPost.setVote(-1);
						thisPost.score -= 2;
                        thisPost.deltaScore -= 2;
                        updateRowViews(finalRow, finalPostHolder, -1, thisPost);
                        new MakePostVoteDeleteTask(context, MainActivity.voteObjectFromPostID(thisPost.getID()).id, thisPost.getID()).execute(MainActivity.voteObjectFromPostID(thisPost.getID()));
                        new MakePostVoteTask(context).execute(new Vote(-1, thisPost.getID(), false));
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

        int yearsDiff;
        int monthsDiff;
        int weeksDiff;
        int daysDiff;
        int hoursDiff;
        int minutesDiff;
        int secondsDiff;


        double nowMillis = now.getTimeInMillis();
        double postMillis = thisPostTime.getTimeInMillis();
        double nowSeconds = nowMillis / 1000.0;
        double postSeconds = postMillis / 1000.0;
        secondsDiff = (int)Math.round(nowSeconds - postSeconds);
        minutesDiff = secondsDiff / 60;
        hoursDiff = minutesDiff / 60;
        daysDiff = hoursDiff / 24;
        weeksDiff = daysDiff / 7;
        monthsDiff = daysDiff / 30;
        yearsDiff = daysDiff / 365;
    	
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
        ImageView postImage;
    	View gpsImageGap;
    	View bottomDivider;
    	View bottomPadding;
    	LinearLayout bottomLayout;
    }
}
