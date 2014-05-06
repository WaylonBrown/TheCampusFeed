package com.appuccino.collegefeed.fragments;

import java.util.ArrayList;

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
import com.appuccino.collegefeed.listadapters.CollegeListAdapter;
import com.appuccino.collegefeed.objects.College;

public class MostActiveCollegesFragment extends Fragment
{
	static MainActivity mainActivity;
	public static final String ARG_SECTION_NUMBER = "section_number";
	static ArrayList<College> collegeList;

	public MostActiveCollegesFragment()
	{
	}
	
	public MostActiveCollegesFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
		
		collegeList = new ArrayList<College>();
		collegeList.add(new College("Texas A&M University"));
		collegeList.add(new College("Harvard University"));
		collegeList.add(new College("University of Texas at Austin"));
		
		CollegeListAdapter adapter = new CollegeListAdapter(getActivity(), R.layout.list_row_college, collegeList);
		
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
	    
		return rootView;
	}

	public static void collegeClicked(College thisCollege) 
	{
//		Intent intent = new Intent(mainActivity, collegeListActivity.class);
//		intent.putExtra("TAG_ID", tag.getText());
//		
//		mainActivity.startActivity(intent);
//		mainActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);			
	}
}
