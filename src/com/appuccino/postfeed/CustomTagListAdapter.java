package com.appuccino.postfeed;

import java.util.List;

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
import android.view.ViewGroup.LayoutParams;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ToggleButton;

public class CustomTagListAdapter extends ArrayAdapter<Tag>{

	Context context; 
    int layoutResourceId;    
    List<Tag> tagList = null;
    
    public CustomTagListAdapter(Context context, int layoutResourceId, List<Tag> list) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        tagList = list;
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;	//this is listview_item_row
        TagHolder tagHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	tagHolder = new TagHolder();
        	tagHolder.text = (TextView)row.findViewById(R.id.tagText);
            		
            Typeface light = Typeface.createFromAsset(context.getAssets(), "fonts/Roboto-Light.ttf");
            
            tagHolder.text.setTypeface(light);
            
            row.setTag(tagHolder);
        }
        else
        	tagHolder = (TagHolder)row.getTag();
        
        Tag thisTag = tagList.get(position);
        tagHolder.text.setText(thisTag.getText());
        tagHolder.text.setSelected(true);
        
        
        return row;
    }
        
    static class TagHolder
    {
    	TextView text;
    }
}
