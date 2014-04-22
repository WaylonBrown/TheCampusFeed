package com.appuccino.postfeed.listadapters;

import java.util.List;

import com.appuccino.postfeed.MainActivity.SectionFragment;
import com.appuccino.postfeed.R;
import com.appuccino.postfeed.R.id;
import com.appuccino.postfeed.objects.Post;

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
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

public class PostListAdapter extends ArrayAdapter<Post>{

	Context context; 
    int layoutResourceId;    
    List<Post> postList = null;
    
    public PostListAdapter(Context context, int layoutResourceId, List<Post> list) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        postList = list;
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
        	postHolder.arrowUp = (ImageView)row.findViewById(R.id.arrowUp);
        	postHolder.arrowDown = (ImageView)row.findViewById(R.id.arrowDown);
            		
            Typeface light = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-Light.ttf");
            Typeface lightItalic = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-LightItalic.ttf");
            Typeface bold = Typeface.createFromAsset(context.getAssets(), "fonts/mplus-2c-bold.ttf");
            
            postHolder.scoreText.setTypeface(bold);
            postHolder.messageText.setTypeface(light);
            postHolder.timeText.setTypeface(lightItalic);
            
            row.setTag(postHolder);
        }
        else
        	postHolder = (PostHolder)row.getTag();
        
        final Post thisPost = postList.get(position);
        postHolder.scoreText.setText(String.valueOf(thisPost.getScore()));
        postHolder.messageText.setText(thisPost.getMessage());
        postHolder.timeText.setText(String.valueOf(thisPost.getHoursAgo()) + " hours ago");
        
        //arrow click listeners
        postHolder.arrowUp.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already upvoted, un-upvote
				if(thisPost.getVote() != 1)
					thisPost.setVote(1);
				else
					thisPost.setVote(0);
				SectionFragment.updateList();
			}        	
        });
        postHolder.arrowDown.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				//if already downvoted, un-downvote
				if(thisPost.getVote() != -1)
					thisPost.setVote(-1);
				else
					thisPost.setVote(0);
				SectionFragment.updateList();
			}        	
        });
        
        int vote = thisPost.getVote();
        if(vote == -1)
        {
        	postHolder.arrowDown.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowdownred));
        	postHolder.arrowUp.setImageDrawable(context.getResources().getDrawable(R.drawable.arrowup));
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
        
        return row;
    }
        
    static class PostHolder
    {
    	TextView scoreText;
    	TextView messageText;
    	TextView timeText;
    	ImageView arrowUp;
    	ImageView arrowDown;
    }
}
