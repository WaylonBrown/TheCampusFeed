package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.TextView;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.listadapters.TagListAdapter;
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
		View rootView = inflater.inflate(R.layout.tag_fragment_layout,
				container, false);
		ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
		
		tagList = new ArrayList<Tag>();
		tagList.add(new Tag("#wwwwww", 5));
		tagList.add(new Tag("#wwwwwwwwwwwwwwwwwwwwwwwwwww", 5));
		tagList.add(new Tag("#wwwwwwww", 5));
		
		TagListAdapter adapter = new TagListAdapter(getActivity(), R.layout.list_row_card_tag, tagList);
		
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
	    Typeface light = Typeface.createFromAsset(getActivity().getAssets(), "fonts/Roboto-Light.ttf");
	    TextView tagSearchText = (TextView)rootView.findViewById(R.id.tagSearchText);
	    tagSearchText.setTypeface(light);
	    
		return rootView;
	}

	public static void tagClicked(Tag tag) 
	{
		Intent intent = new Intent(mainActivity, TagListActivity.class);
		intent.putExtra("TAG_ID", tag.getText());
		
		mainActivity.startActivity(intent);
		mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);			
	}
}
