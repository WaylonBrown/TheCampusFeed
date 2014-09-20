package com.appuccino.thecampusfeed.fragments;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
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
import com.appuccino.thecampusfeed.adapters.CommentListAdapter;
import com.appuccino.thecampusfeed.extra.QuickReturnListView;
import com.appuccino.thecampusfeed.objects.Comment;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.NetWorker;

import java.util.ArrayList;
import java.util.List;

public class MyCommentsFragment extends Fragment
{
    static MainActivity mainActivity;
    public static List<Comment> commentList = new ArrayList<Comment>();
    public static List<Post> parentPostList = new ArrayList<Post>();
    static CommentListAdapter listAdapter;
    static QuickReturnListView list;
    static TextView score;

    //library objects
    static ProgressBar loadingSpinner;
    View rootView;

    public MyCommentsFragment(){
        mainActivity = MainActivity.activity;
    }

    public MyCommentsFragment(MainActivity m)
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

        listAdapter = new CommentListAdapter(mainActivity, R.layout.list_row_collegepost, commentList, null);
        if(list != null)
            list.setAdapter(listAdapter);

        list.setOnItemClickListener(new OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1,
                                    int position, long arg3)
            {
                commentClicked(commentList.get(position - 1));
            }
        });

        pullListFromServer();

        return rootView;
    }

    private void pullListFromServer()
    {
        commentList = new ArrayList<Comment>();
        parentPostList = new ArrayList<Post>();
        ConnectivityManager cm = (ConnectivityManager)mainActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
        if(cm.getActiveNetworkInfo() != null) {
            new NetWorker.GetMyCommentsTask(this).execute(new NetWorker.PostSelector());
        } else {
            Toast.makeText(mainActivity, "You have no internet connection.", Toast.LENGTH_LONG).show();
            makeLoadingIndicator(false);
        }
    }

    public static void updateCommentParentList(ArrayList<Post> result) {
        parentPostList = new ArrayList<Post>();
        parentPostList.addAll(result);
    }

    private void commentClicked(Comment comment) {
        Post parentPost = getParentPostOfComment(comment);
        int index = getIndexOfParentPost(parentPost);
        Log.i("cfeed", "ID of parent post: " + parentPost.getID());
        Intent intent = new Intent(mainActivity, CommentsActivity.class);
        intent.putExtra("POST_INDEX", index);
        if(parentPost != null){
            intent.putExtra("POST_ID", parentPost.getID());
            intent.putExtra("COLLEGE_ID", parentPost.getCollegeID());
        }
        intent.putExtra("SECTION_NUMBER", 3);

        startActivity(intent);
        getActivity().overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private static Post getParentPostOfComment(Comment c){
        if(parentPostList == null || parentPostList.size() == 0){
            Toast.makeText(mainActivity, "Please give the comment list another second to load.", Toast.LENGTH_LONG).show();
        } else {
            for(Post p : parentPostList){
                if(p.getID() == c.getPostID()){
                    return p;
                }
            }
        }
        return null;
    }

    private static int getIndexOfParentPost(Post p){
        if(p != null && parentPostList != null && parentPostList.size() > 0){
            for(int i = 0; i < parentPostList.size(); i++){
                if(parentPostList.get(i).getID() == p.getID()){
                    return i;
                }
            }
        }
        return 0;
    }

    public static void updateList(ArrayList<Comment> result)
    {
        commentList = new ArrayList<Comment>();
        commentList.addAll(result);

        if(listAdapter != null)
        {
            listAdapter.clear();
            listAdapter.addAll(commentList);
            listAdapter.notifyDataSetChanged();
            updateUserScore();
        }

        //fetch comments parent IDs
        if(result != null && result.size() > 0){
            List<Integer> commentParentIDs = new ArrayList<Integer>();
            for(Comment c : commentList){
                commentParentIDs.add(c.getPostID());
            }
            new NetWorker.GetManyPostsTask(commentParentIDs).execute(new NetWorker.PostSelector());
        }
    }

    public static void updateListVotes(){
        if(listAdapter != null)
        {
            listAdapter.notifyDataSetChanged();
            updateUserScore();
        }
    }

    private static void updateUserScore() {
        if(score != null && commentList != null){
            int scoreCount = 0;
            for(Comment c : commentList){
                scoreCount += c.getDeltaScore();
            }
            score.setText("Comment Score: " + scoreCount);
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
}
