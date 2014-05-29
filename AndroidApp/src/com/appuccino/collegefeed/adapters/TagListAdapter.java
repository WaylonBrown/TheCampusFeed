package com.appuccino.collegefeed.adapters;

import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.fragments.TagFragment;
import com.appuccino.collegefeed.objects.Tag;
import com.appuccino.collegefeed.utils.FontManager;

public class TagListAdapter extends ArrayAdapter<Tag>{

	Context context; 
    int layoutResourceId;    
    List<Tag> tagList = null;
    
    public TagListAdapter(Context context, int layoutResourceId, List<Tag> list) {
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
            tagHolder.text.setTypeface(FontManager.light);
            
            row.setTag(tagHolder);
        }
        else
        	tagHolder = (TagHolder)row.getTag();
        
        final Tag thisTag = tagList.get(position);
        tagHolder.text.setText(thisTag.getText());
        tagHolder.text.setSelected(true);
        
        row.setClickable(true);
        row.setFocusable(true);
        row.setOnClickListener(new OnClickListener()
        {
			@Override
			public void onClick(View arg0) 
			{
				TagFragment.tagClicked(thisTag);
			}
        });
        
        return row;
    }
        
    static class TagHolder
    {
    	TextView text;
    }
}
