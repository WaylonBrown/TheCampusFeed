package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

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
    public static PostListAdapter listAdapter;
    public static List<Post> postList = new ArrayList<Post>();
    public static List<Comment> commentList = new ArrayList<Comment>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_content);
        setupActionbar();
        setupViews();
        setupList();
        fetchLists();
        //TODO: remove this
        updateLists();
    }

    private void setupList() {
        listAdapter = new PostListAdapter(this, R.layout.list_row_collegepost, postList, 0, MainActivity.ALL_COLLEGES);
        myPostsListView = (ListView)findViewById(R.id.myPostsListView);
        if(myPostsListView != null)
            myPostsListView.setAdapter(listAdapter);
        else
            Log.e("cfeed", "MyContentPostList list adapter wasn't set.");

        myPostsListView.setOnItemClickListener(new AdapterView.OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1,
                                    int position, long arg3)
            {
                postClicked(postList.get(position - 1));
            }
        });
    }

    private void postClicked(Post post) {
    }

    private void fetchLists() {
        //TODO: fetch from server here

    }

    public static void updateLists() {
        //TODO: remove these manual lists
        List<Post> testList = new ArrayList<Post>();
        testList.add(new Post("test", 1));
        testList.add(new Post("test", 1));
        testList.add(new Post("test", 1));
        testList.add(new Post("test", 1));
        postList = new ArrayList<Post>(postList);
        postList.addAll(testList);

        if(listAdapter != null)
        {
            Log.i("cfeed", "TEST new post size: " + postList.size());
            listAdapter.setCollegeFeedID(MainActivity.ALL_COLLEGES);
            listAdapter.clear();
            listAdapter.addAll(postList);
            Log.i("cfeed","TEST last post size: " + listAdapter.getCount());
            listAdapter.notifyDataSetChanged();
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
        //ListView myPostsListView = (ListView)findViewById()

        myPostsText.setTypeface(FontManager.light);
        myCommentsText.setTypeface(FontManager.light);
    }

    public static void makeLoadingIndicator(boolean makeLoading){
        //TODO
    }
}
