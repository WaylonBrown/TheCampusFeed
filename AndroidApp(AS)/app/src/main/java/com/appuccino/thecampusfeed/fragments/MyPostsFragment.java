package com.appuccino.thecampusfeed.fragments;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.CommentsActivity;
import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.adapters.PostListAdapter;
import com.appuccino.thecampusfeed.extra.QuickReturnListView;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.NetWorker;

import java.util.ArrayList;
import java.util.List;

public class MyPostsFragment extends Fragment
{
    static MainActivity mainActivity;
    public static List<Post> postList = new ArrayList<Post>();
    static PostListAdapter listAdapter;
    static QuickReturnListView list;
    static TextView score;

    //library objects
    static ProgressBar loadingSpinner;
    View rootView;

    public MyPostsFragment()
    {
    }

    public MyPostsFragment(MainActivity m)
    {
        mainActivity = m;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_layout_my_content,
                container, false);
        list = (QuickReturnListView)rootView.findViewById(R.id.fragmentListView);
        loadingSpinner = (ProgressBar)rootView.findViewById(R.id.loadingSpinner);
        score = (TextView)rootView.findViewById(R.id.score);

        //if doesnt have header and footer, add them
        if(list.getHeaderViewsCount() == 0)
        {
            //for card UI
            View headerSpace = new View(getActivity());
            headerSpace.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
            list.addHeaderView(headerSpace, null, false);
            list.addFooterView(headerSpace, null, false);
        }

        listAdapter = new PostListAdapter(getActivity(), R.layout.list_row_collegepost, postList, 0, MainActivity.ALL_COLLEGES);
        if(list != null)
            list.setAdapter(listAdapter);

        list.setOnItemClickListener(new OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1,
                                    int position, long arg3)
            {
                postClicked(postList.get(position - 1), position - 1);
            }
        });

        pullListFromServer();

        return rootView;
    }

    private void pullListFromServer()
    {
        postList = new ArrayList<Post>();
        ConnectivityManager cm = (ConnectivityManager)mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
        if(cm.getActiveNetworkInfo() != null) {
            new NetWorker.GetManyPostsTask(MainActivity.myPostsList, this).execute(new NetWorker.PostSelector());
        } else {
            Toast.makeText(mainActivity, "You have no internet connection.", Toast.LENGTH_LONG).show();
            makeLoadingIndicator(false);
        }
    }

    protected void postClicked(Post post, int index)
    {
        Intent intent = new Intent(mainActivity, CommentsActivity.class);
        intent.putExtra("POST_ID", post.getID());
        intent.putExtra("COLLEGE_ID", post.getCollegeID());
        intent.putExtra("POST_INDEX", index);
        intent.putExtra("SECTION_NUMBER", 2);

        startActivity(intent);
        getActivity().overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public static void updateList(ArrayList<Post> result)
    {
        postList = new ArrayList<Post>();
        postList.addAll(result);

        if(listAdapter != null)
        {
            listAdapter.setCollegeFeedID(MainActivity.ALL_COLLEGES);
            listAdapter.clear();
            listAdapter.addAll(postList);
            listAdapter.notifyDataSetChanged();
            updateUserPostScore();
        }
    }

    private static void updateUserPostScore() {
        if(score != null && postList != null && postList.size() != 0){
            int scoreCount = 0;
            for(Post p : postList){
                scoreCount += p.getScore();
            }
            score.setText("Post Score: " + scoreCount);
        }
    }

    public static void makeLoadingIndicator(boolean makeLoading)
    {
        if(loadingSpinner != null){
            if(makeLoading)
            {
                list.setVisibility(View.INVISIBLE);
                loadingSpinner.setVisibility(View.VISIBLE);
            }
            else
            {
                list.setVisibility(View.VISIBLE);
                loadingSpinner.setVisibility(View.INVISIBLE);
            }
        }
    }

    public static void scrollToTop() {
        if(list != null){
            list.setSelectionAfterHeaderView();
        }
    }
}
