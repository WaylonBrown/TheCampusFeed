package com.appuccino.collegefeed.adapters;

import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.PostCommentsActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.adapters.PostListAdapter.PostHolder;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.utils.FontManager;

public class CommentListAdapter extends ArrayAdapter<Comment>{

	Context context; 
    int layoutResourceId;    
    List<Comment> commentList = null;
    
    public CommentListAdapter(Context context, int layoutResourceId, List<Comment> list) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        commentList = list;
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;	//this is listview_item_row
        CommentHolder commentHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	commentHolder = new CommentHolder();
        	commentHolder.scoreText = (TextView)row.findViewById(R.id.scoreText);
        	commentHolder.messageText = (TextView)row.findViewById(R.id.messageText);
        	commentHolder.timeText = (TextView)row.findViewById(R.id.timeText);
        	commentHolder.arrowUp = (ImageView)row.findViewById(R.id.arrowUp);
        	commentHolder.arrowDown = (ImageView)row.findViewById(R.id.arrowDown);
            
            commentHolder.scoreText.setTypeface(FontManager.bold);
            commentHolder.messageText.setTypeface(FontManager.light);
            commentHolder.timeText.setTypeface(FontManager.medium);
            
            row.setTag(commentHolder);
        }
        else
        	commentHolder = (CommentHolder)row.getTag();
        
        final Comment thisComment = commentList.get(position);
        commentHolder.scoreText.setText(String.valueOf(thisComment.getScore()));
        commentHolder.messageText.setText(thisComment.getMessage());
        commentHolder.timeText.setText(String.valueOf(thisComment.getHoursAgo()) + " hours ago");
        
        setMessageAndColorizeTags(thisComment.getMessage(), commentHolder);
        
      //arrow click listeners
        commentHolder.arrowUp.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already upvoted, un-upvote
				if(thisComment.getVote() == -1)
				{
					thisComment.setVote(1);
					thisComment.score += 2;
				}
				else if(thisComment.getVote() == 0)
				{
					thisComment.setVote(1);
					thisComment.score++;
				}
				else 
				{
					thisComment.setVote(0);
					thisComment.score--;
				}

				PostCommentsActivity.updateList();
			}        	
        });
        commentHolder.arrowDown.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				if(MainActivity.hasPermissions(thisComment.getCollegeID()))
				{
					//if already downvoted, un-downvote
					if(thisComment.getVote() == -1)
					{
						thisComment.setVote(0);
						thisComment.score++;
					}
					else if(thisComment.getVote() == 0)
					{
						thisComment.setVote(-1);
						thisComment.score--;
					}
					else 
					{
						thisComment.setVote(-1);
						thisComment.score -= 2;
					}
					PostCommentsActivity.updateList();
				}
				else
				{
					Toast.makeText(context, "You need to be near the college to downvote", Toast.LENGTH_LONG).show();
				}
			}        	
        });
        
        int vote = thisComment.getVote();
        if(vote == -1)
        {
        	commentHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdownred));
        	commentHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
        }
        else if (vote == 1)
        {
        	commentHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowupblue));
        	commentHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }
        else	//no votes
        {
        	commentHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
        	commentHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdown));
        }
        
        return row;
    }
    
    private void setMessageAndColorizeTags(String msg, CommentHolder commentHolder) 
    {
    	String tagColor = "#33B5E5";
    	String message = msg;
    	
    	String[] wordArray = message.split(" ");
    	//check for tags, colorize them
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		if(wordArray[i].length() > 0 && wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
    		{
    			wordArray[i] = "<font color='" + tagColor + "'>" + wordArray[i] + "</font>";
    		}
    	}
    	
    	message = "";
    	//combine back to string
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		message += wordArray[i] + " ";
    	}
    	
    	commentHolder.messageText.setText(Html.fromHtml(message));
		
	}
        
    static class CommentHolder
    {
    	TextView scoreText;
    	TextView messageText;
    	TextView timeText;
    	ImageView arrowUp;
    	ImageView arrowDown;
    }
}
