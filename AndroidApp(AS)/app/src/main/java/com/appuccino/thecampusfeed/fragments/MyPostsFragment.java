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
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.CommentsActivity;
import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.adapters.PostListAdapter;
import com.appuccino.thecampusfeed.dialogs.AchievementsDialog;
import com.appuccino.thecampusfeed.extra.QuickReturnListView;
import com.appuccino.thecampusfeed.objects.Achievement;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.NetWorker;
import com.appuccino.thecampusfeed.utils.PrefManager;

import java.util.ArrayList;
import java.util.List;

public class MyPostsFragment extends Fragment
{
    static MainActivity mainActivity;
    public static List<Post> postList = new ArrayList<Post>();
    static PostListAdapter listAdapter;
    static QuickReturnListView list;
    static TextView score;
    private static int scoreCount;

    //library objects
    static ProgressBar loadingSpinner;
    View rootView;

    public MyPostsFragment(){
        mainActivity = MainActivity.activity;
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
            LayoutInflater headerInflater = mainActivity.getLayoutInflater();
            LinearLayout header = (LinearLayout)headerInflater.inflate(R.layout.list_row_trophy_button, null);
            list.addHeaderView(header);

            //for card UI
            View footerSpace = new View(getActivity());
            footerSpace.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
            list.addFooterView(footerSpace, null, false);
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

        ImageButton trophyButton = (ImageButton)rootView.findViewById(R.id.trophyButton);
        trophyButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new AchievementsDialog(mainActivity);
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

        checkForAchievements();
    }

    private static void checkForAchievements() {
        int highestPostScore = 0;
        for(Post p : postList){
            if (p.deltaScore > highestPostScore){
                highestPostScore = p.deltaScore;
            }
        }

        if(postList != null){
            //go through full achievements list
            for(Achievement ach : AchievementsDialog.achievementList){
                if(ach.section == 1){   //quantities of posts
                    if(postList.size() >= ach.numToAchieve){
                        AchievementsDialog.unlockAchievement(mainActivity, ach.ID);
                    }
                } else if (ach.section == 2){   //total post score
                    if(scoreCount >= ach.numToAchieve){
                        AchievementsDialog.unlockAchievement(mainActivity, ach.ID);
                    }
                } else if (ach.section == 3){
                    if(highestPostScore >= ach.numToAchieve){
                        AchievementsDialog.unlockAchievement(mainActivity, ach.ID);
                    }
                } else if (ach.section == 4){
                    //100 pts for a post in 3 words or less
                    if(ach.ID == 32 && postExistsWith100PtsIn3Words()){
                        AchievementsDialog.unlockAchievement(mainActivity, ach.ID);
                    } else if (ach.ID == 33){   //2000+ timecrunch hours
                        if(PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0) >= 2000){
                            AchievementsDialog.unlockAchievement(mainActivity, ach.ID);
                        }
                    }
                }
            }

        }
    }

    private static boolean postExistsWith100PtsIn3Words() {
        for(Post p : postList){
            if(p.deltaScore >= 100 && p.getMessage().split(" ").length <= 3)
                return true;
        }
        return false;
    }

    public static void updateListVotes(){
        if(listAdapter != null)
        {
            listAdapter.setCollegeFeedID(MainActivity.ALL_COLLEGES);
            listAdapter.notifyDataSetChanged();
            updateUserPostScore();
        }
    }

    private static void updateUserPostScore() {
        if(score != null && postList != null && postList.size() != 0){
            scoreCount = 0;
            for(Post p : postList){
                scoreCount += p.getDeltaScore();
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
