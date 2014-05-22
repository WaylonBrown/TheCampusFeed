package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.adapters.TagListAdapter;
import com.appuccino.collegefeed.extra.FontFetcher;
import com.appuccino.collegefeed.extra.NetWorker.MakePostTask;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Tag;

public class TagFragment extends Fragment
{
	static MainActivity mainActivity;
	public static final String ARG_SECTION_NUMBER = "section_number";
	static ArrayList<Tag> tagList;

	public TagFragment()
	{
	}
	
	public TagFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_layout_tag,
				container, false);
		ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
		
		tagList = new ArrayList<Tag>();
		tagList.add(new Tag("#YOLO", 5));
		tagList.add(new Tag("#bieberfever", 5));
		tagList.add(new Tag("#tbt", 5));
		
		TagListAdapter adapter = new TagListAdapter(getActivity(), R.layout.list_row_tag, tagList);
		
		//if doesnt have header and footer, add them
		if(fragList.getHeaderViewsCount() == 0)
		{
			//for card UI
			View headerFooter = new View(getActivity());
			headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
			fragList.addFooterView(headerFooter, null, false);
			fragList.addHeaderView(headerFooter, null, false);
		}
	    fragList.setAdapter(adapter);
	    fragList.setItemsCanFocus(true);
	    
	    //set bottom text typeface
	    TextView tagSearchText = (TextView)rootView.findViewById(R.id.tagSearchText);
	    tagSearchText.setTypeface(FontFetcher.light);
	    
	    tagSearchText.setOnClickListener(new OnClickListener()
	    {
			@Override
			public void onClick(View v) 
			{
				searchTagsClicked();
			}
	    });
	    
		return rootView;
	}

	public static void tagClicked(Tag tag) 
	{
		Intent intent = new Intent(mainActivity, TagListActivity.class);
		intent.putExtra("TAG_ID", tag.getText());
		
		mainActivity.startActivity(intent);
		mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);			
	}
	
	public void searchTagsClicked() 
	{
		LayoutInflater inflater = mainActivity.getLayoutInflater();
		View searchDialogLayout = inflater.inflate(R.layout.dialog_tag_search, null);
		final EditText searchTagEditText = (EditText)searchDialogLayout.findViewById(R.id.searchTagEditText);
		
		AlertDialog.Builder builder = new AlertDialog.Builder(mainActivity);
    	builder.setCancelable(true);
    	builder.setView(searchDialogLayout)
    	.setPositiveButton("Search", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing here since overridden below to be able to click button and not dismiss dialog
            }
        });
    	    	
    	final AlertDialog dialog = builder.create();
    	dialog.show();
    	
    	Button searchButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
    	searchButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{				
    			if(searchTagEditText.getText().toString().length() >= 3)
    			{
    				Intent intent = new Intent(mainActivity, TagListActivity.class);
    				intent.putExtra("TAG_ID", searchTagEditText.getText().toString());
    				
    				mainActivity.startActivity(intent);
    				mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        			dialog.dismiss();
    			}
    			else
    			{
    				Toast.makeText(mainActivity, "Must be 3 characters long.", Toast.LENGTH_LONG).show();
    			}
			}
    	});
    	
    	searchTagEditText.setTypeface(FontFetcher.light);
    	searchButton.setTypeface(FontFetcher.light);
    	
    	searchTagEditText.setSelection(1);	//start cursor after #
    	//ensure keyboard is brought up when dialog shows
    	searchTagEditText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
    	    @Override
    	    public void onFocusChange(View v, boolean hasFocus) {
    	        if (hasFocus) {
    	            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    	        }
    	    }
    	});
	}
}
