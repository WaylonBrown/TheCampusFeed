package com.appuccino.thecampusfeed.fragments;

import android.content.Context;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.adapters.FragmentCollegeListAdapter;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.utils.NetWorker;

import java.util.ArrayList;

public class MostActiveCollegesFragment extends Fragment
{
	static MainActivity mainActivity;
	public static ArrayList<College> collegeList;
    private static ProgressBar progressSpinner;
    static FragmentCollegeListAdapter adapter;

    public MostActiveCollegesFragment(){
        mainActivity = MainActivity.activity;
    }
	
	public MostActiveCollegesFragment(MainActivity m) 
	{
		mainActivity = m;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
        if(mainActivity == null){
            mainActivity = MainActivity.activity;
        }
		View rootView = inflater.inflate(R.layout.fragment_layout,
				container, false);
		ListView fragList = (ListView)rootView.findViewById(R.id.fragmentListView);
        progressSpinner = (ProgressBar)rootView.findViewById(R.id.loadingSpinner);

		disableFooter(rootView);
		
		collegeList = new ArrayList<College>();
		
		adapter = new FragmentCollegeListAdapter(getActivity(), R.layout.list_row_college, collegeList, true);

        if(fragList != null) {
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
        }

        pullListFromServer();

		return rootView;
	}

    private static void pullListFromServer()
    {
        if(collegeList == null){
            collegeList = new ArrayList<College>();
        }
        ConnectivityManager cm = (ConnectivityManager) mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
        if(cm.getActiveNetworkInfo() != null){
            new NetWorker.GetCollegeFragmentTask().execute(new NetWorker.PostSelector());
        } else {
            makeLoadingIndicator(false);
        }
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

    public static void updateList() {
        if(adapter != null)
        {
            appendNumbersToCollegeList();
            adapter.clear();
            adapter.addAll(collegeList);
            adapter.notifyDataSetChanged();
        }
    }

    private static void appendNumbersToCollegeList() {
        if(collegeList != null && collegeList.size() != 0){
            for(int i = 0; i < collegeList.size(); i++){
                collegeList.get(i).setName(String.valueOf(i+1) + ". " + collegeList.get(i).getName());
            }
        }
    }

    public static void makeLoadingIndicator(boolean b) {
        if(progressSpinner != null){
            if(b){
                progressSpinner.setVisibility(View.VISIBLE);
            }else{
                progressSpinner.setVisibility(View.GONE);
            }
        }
    }
}
