package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.adapters.CommentListAdapter;
import com.appuccino.collegefeed.adapters.PostListAdapter;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Waylon on 7/6/2014.
 */
public class MyContentActivity extends Activity{

    static ListView myPostsListView;
    static ListView myCommentsListView;
    static TextView postScore;
    static TextView commentScore;
    static ProgressBar topLoadingSpinner;
    static ProgressBar bottomLoadingSpinner;
    public static PostListAdapter postListAdapter;
    public static CommentListAdapter commentListAdapter;
    public static List<Post> postList = new ArrayList<Post>();
    public static List<Comment> commentList = new ArrayList<Comment>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_content);
        setupActionbar();
        setupViews();
        setupListViews();
        fetchLists();
    }

    private void setupListViews() {
        postListAdapter = new PostListAdapter(this, R.layout.list_row_collegepost, postList, 0, MainActivity.ALL_COLLEGES);
        commentListAdapter = new CommentListAdapter(this, R.layout.list_row_collegepost, commentList, null);
        myPostsListView = (ListView)findViewById(R.id.myPostsListView);
        myCommentsListView = (ListView)findViewById(R.id.myCommentsListView);
        topLoadingSpinner = (ProgressBar)findViewById(R.id.topLoadingSpinner);
        bottomLoadingSpinner = (ProgressBar)findViewById(R.id.bottomLoadingSpinner);
        //if doesnt have footer, add it
        if(myCommentsListView.getFooterViewsCount() == 0)
        {
            //for card UI
            View footer = new View(this);
            footer.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
            myCommentsListView.addFooterView(footer, null, false);
        }
        if(myPostsListView != null)
            myPostsListView.setAdapter(postListAdapter);
        else
            Log.e("cfeed", "MyContentPostList list adapter wasn't set.");
        if(myCommentsListView != null)
            myCommentsListView.setAdapter(commentListAdapter);
        else
            Log.e("cfeed", "MyContentCommentList list adapter wasn't set.");

        myPostsListView.setOnItemClickListener(new AdapterView.OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1,
                                    int position, long arg3)
            {
                postClicked(postList.get(position - 1));
            }
        });
        myCommentsListView.setOnItemClickListener(new AdapterView.OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1,
                                    int position, long arg3)
            {
                commentClicked(commentList.get(position - 1));
            }
        });
    }

    private void postClicked(Post post) {
    }

    private void commentClicked(Comment comment) {
    }

    private void fetchLists() {
        postList = new ArrayList<Post>();
        commentList = new ArrayList<Comment>();
        ConnectivityManager cm = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        if(cm.getActiveNetworkInfo() != null) {
            new NetWorker.GetMyPostsTask().execute(new NetWorker.PostSelector());
            new NetWorker.GetMyCommentsTask().execute(new NetWorker.PostSelector());
        } else {
            Toast.makeText(this, "You have no internet connection.", Toast.LENGTH_LONG).show();
            makeTopLoadingIndicator(false);
            makeBottomLoadingIndicator(false);
        }
    }

    public static void updatePostList(ArrayList<Post> result) {
        postList = new ArrayList<Post>();
        postList.addAll(result);

        if(postListAdapter != null)
        {
            Log.i("cfeed", "TEST new post size: " + postList.size());
            postListAdapter.setCollegeFeedID(MainActivity.ALL_COLLEGES);
            postListAdapter.clear();
            postListAdapter.addAll(postList);
            Log.i("cfeed","TEST last post size: " + postListAdapter.getCount());
            postListAdapter.notifyDataSetChanged();
            updateUserPostScore();
        }
    }

    public static void updateCommentList(ArrayList<Comment> result) {
        commentList = new ArrayList<Comment>();
        commentList.addAll(result);

        if(commentListAdapter != null)
        {
            Log.i("cfeed", "TEST new comment size: " + commentList.size());
            commentListAdapter.clear();
            commentListAdapter.addAll(commentList);
            Log.i("cfeed","TEST last comment size: " + commentListAdapter.getCount());
            commentListAdapter.notifyDataSetChanged();
            updateUserCommentScore();
        }
    }

    private static void updateUserPostScore() {
        if(postScore != null && postList != null && postList.size() != 0){
            int scoreCount = 0;
            for(Post p : postList){
                scoreCount += p.getScore();
            }
            postScore.setText("Post Score: " + scoreCount);
        }
    }

    private static void updateUserCommentScore() {
        if(commentScore != null && commentList != null && commentList.size() != 0){
            int scoreCount = 0;
            for(Comment c : commentList){
                scoreCount += c.getScore();
            }
            commentScore.setText("Comment Score: " + scoreCount);
        }
    }

    private void setupActionbar() {
        ActionBar actionBar = getActionBar();
        actionBar.setCustomView(R.layout.actionbar_main);
        actionBar.setDisplayShowTitleEnabled(false);
        actionBar.setDisplayShowCustomEnabled(true);
        actionBar.setDisplayUseLogoEnabled(false);
        actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
        actionBar.setIcon(R.drawable.logofake);

        ImageView postButton = (ImageView)findViewById(R.id.newPostButton);
        postButton.setVisibility(View.GONE);
    }

    private void setupViews() {
        TextView myPostsText = (TextView)findViewById(R.id.myPostsTextView);
        TextView myCommentsText = (TextView)findViewById(R.id.myCommentsTextView);
        postScore = (TextView)findViewById(R.id.postScore);
        commentScore = (TextView)findViewById(R.id.commentScore);

        myPostsText.setTypeface(FontManager.light);
        myCommentsText.setTypeface(FontManager.light);
        postScore.setTypeface(FontManager.light);
        commentScore.setTypeface(FontManager.light);
    }

    public static void makeTopLoadingIndicator(boolean makeLoading){
        if(topLoadingSpinner != null){
            if(makeLoading)
            {
                myPostsListView.setVisibility(View.INVISIBLE);
                topLoadingSpinner.setVisibility(View.VISIBLE);
            }
            else
            {
                myPostsListView.setVisibility(View.VISIBLE);
                topLoadingSpinner.setVisibility(View.INVISIBLE);
            }
        }
    }

    public static void makeBottomLoadingIndicator(boolean makeLoading){
        if(bottomLoadingSpinner != null){
            if(makeLoading)
            {
                myCommentsListView.setVisibility(View.INVISIBLE);
                bottomLoadingSpinner.setVisibility(View.VISIBLE);
            }
            else
            {
                myCommentsListView.setVisibility(View.VISIBLE);
                bottomLoadingSpinner.setVisibility(View.INVISIBLE);
            }
        }
    }
}
