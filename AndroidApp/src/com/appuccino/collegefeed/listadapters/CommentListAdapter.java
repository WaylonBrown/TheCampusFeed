package com.appuccino.collegefeed.listadapters;

import java.util.List;

import com.appuccino.collegefeed.PostCommentsActivity;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.postfeed.R;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.Shader;
import android.preference.PreferenceManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ToggleButton;

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
        commentHolder commentHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	commentHolder = new commentHolder();
        	commentHolder.scoreText = (TextView)row.findViewById(R.id.scoreText);
        	commentHolder.messageText = (TextView)row.findViewById(R.id.messageText);
        	commentHolder.timeText = (TextView)row.findViewById(R.id.timeText);
        	commentHolder.arrowUp = (ImageView)row.findViewById(R.id.arrowUp);
        	commentHolder.arrowDown = (ImageView)row.findViewById(R.id.arrowDown);
            		
            Typeface light = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-Light.ttf");
            Typeface lightItalic = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-LightItalic.ttf");
            Typeface bold = Typeface.createFromAsset(context.getAssets(), "fonts/mplus-2c-bold.ttf");
            
            commentHolder.scoreText.setTypeface(bold);
            commentHolder.messageText.setTypeface(light);
            commentHolder.timeText.setTypeface(lightItalic);
            
            row.setTag(commentHolder);
        }
        else
        	commentHolder = (commentHolder)row.getTag();
        
        final Comment thiscomment = commentList.get(position);
        commentHolder.scoreText.setText(String.valueOf(thiscomment.getScore()));
        commentHolder.messageText.setText(thiscomment.getMessage());
        commentHolder.timeText.setText(String.valueOf(thiscomment.getHoursAgo()) + " hours ago");
        
      //arrow click listeners
        commentHolder.arrowUp.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already upvoted, un-upvote
				if(thiscomment.getVote() != 1)
					thiscomment.setVote(1);
				else
					thiscomment.setVote(0);
				PostCommentsActivity.updateList();
			}        	
        });
        commentHolder.arrowDown.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already downvoted, un-downvote
				if(thiscomment.getVote() != -1)
					thiscomment.setVote(-1);
				else
					thiscomment.setVote(0);
				PostCommentsActivity.updateList();
			}        	
        });
        
        int vote = thiscomment.getVote();
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
        
    static class commentHolder
    {
    	TextView scoreText;
    	TextView messageText;
    	TextView timeText;
    	ImageView arrowUp;
    	ImageView arrowDown;
    }
}
