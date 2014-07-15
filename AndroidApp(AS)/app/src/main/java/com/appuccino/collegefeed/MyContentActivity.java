package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.appuccino.collegefeed.adapters.CommentListAdapter;
import com.appuccino.collegefeed.adapters.PostListAdapter;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Waylon on 7/6/2014.
 */
public class MyContentActivity extends Activity{

    ListView myPostsListView;
    ListView myCommentsListView;
    static TextView postScore;
    static TextView commentScore;
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
        setupLists();
        fetchLists();
        //TODO: remove these
        updatePostList();
        updateCommentList();
    }

    private void setupLists() {
        postListAdapter = new PostListAdapter(this, R.layout.list_row_collegepost, postList, 0, MainActivity.ALL_COLLEGES);
        commentListAdapter = new CommentListAdapter(this, R.layout.list_row_collegepost, commentList, null);
        myPostsListView = (ListView)findViewById(R.id.myPostsListView);
        myCommentsListView = (ListView)findViewById(R.id.myCommentsListView);
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
        //TODO: fetch from server here

    }

    public static void updatePostList() {
        //TODO: remove these manual lists
        List<Post> testList = new ArrayList<Post>();
        testList.add(new Post("test", 1));
        testList.add(new Post("test", 1));
        testList.add(new Post("test", 1));
        testList.add(new Post("test", 1));
        postList = new ArrayList<Post>();
        postList.addAll(testList);

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

    public static void updateCommentList() {
        //TODO: remove these manual lists
        List<Comment> testList = new ArrayList<Comment>();
        testList.add(new Comment(1));
        testList.add(new Comment(2));
        testList.add(new Comment(0));
        testList.add(new Comment(6));
        testList.add(new Comment(4));
        commentList = new ArrayList<Comment>();
        commentList.addAll(testList);

        if(commentListAdapter != null)
        {
            Log.i("cfeed", "TEST new post size: " + postList.size());
            //commentListAdapter.setCollegeFeedID(MainActivity.ALL_COLLEGES);
            commentListAdapter.clear();
            commentListAdapter.addAll(commentList);
            Log.i("cfeed","TEST last post size: " + commentListAdapter.getCount());
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

    public static void makeLoadingIndicator(boolean makeLoading){
        //TODO
    }
}
