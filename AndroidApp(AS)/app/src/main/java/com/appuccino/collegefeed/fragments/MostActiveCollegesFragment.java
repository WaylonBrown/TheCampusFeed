package com.appuccino.collegefeed.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.FragmentCollegeListAdapter;
import com.appuccino.collegefeed.objects.College;

import java.util.ArrayList;

public class MostActiveCollegesFragment extends Fragment
{
	static MainActivity mainActivity;
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
		
		disableFooter(rootView);
		
		collegeList = new ArrayList<College>();
		collegeList.add(new College("Texas A&M University", 1422));
		collegeList.add(new College("Harvard University", 1066));
		collegeList.add(new College("University of Texas at Austin", 1423));
		
		FragmentCollegeListAdapter adapter = new FragmentCollegeListAdapter(getActivity(), R.layout.list_row_college, collegeList, true);
		
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

	private void disableFooter(View root) {
		LinearLayout footer = (LinearLayout)root.findViewById(R.id.footer);
		footer.setVisibility(View.GONE);
	}

	public static void collegeClicked(College thisCollege) 
	{
        mainActivity.goToTopPostsAndScrollToTop();
        mainActivity.changeFeed(thisCollege.getID());
	}
}
