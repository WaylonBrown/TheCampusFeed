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
import com.appuccino.collegefeed.fragments.MostActiveCollegesFragment;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.utils.FontManager;

public class DialogCollegeListAdapter extends ArrayAdapter<College>{

	Context context; 
    int layoutResourceId;    
    List<College> collegeList = null;
    boolean enableListClicking;
    
    public DialogCollegeListAdapter(Context context, int layoutResourceId, List<College> list, boolean enableListClicking) {
        super(context, layoutResourceId, list);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        collegeList = list;
        this.enableListClicking = enableListClicking;
    }
    
    @Override
    public boolean isEnabled(int position) {
        return enableListClicking;
    }
    
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;	//this is listview_item_row
        CollegeHolder collegeHolder = null;
        
        //first pass
        if(row == null)
        {
        	LayoutInflater inflater = ((Activity)context).getLayoutInflater();
        	row = inflater.inflate(layoutResourceId, parent, false);        	
        	
        	collegeHolder = new CollegeHolder();
        	collegeHolder.text = (TextView)row.findViewById(R.id.collegeText);
            collegeHolder.text.setTypeface(FontManager.light);
            
            row.setTag(collegeHolder);
        }
        else
        	collegeHolder = (CollegeHolder)row.getTag();
        
        final College thisCollege = collegeList.get(position);
        collegeHolder.text.setText(thisCollege.getName());
        return row;
    }
        
    static class CollegeHolder
    {
    	TextView text;
    }
}
