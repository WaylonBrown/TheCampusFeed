//package com.appuccino.collegefeed;
//
//import android.app.ActionBar;
//import android.app.Activity;
//import android.content.Context;
//import android.content.Intent;
//import android.graphics.drawable.ColorDrawable;
//import android.net.ConnectivityManager;
//import android.os.Bundle;
//import android.util.Log;
//import android.view.View;
//import android.widget.AbsListView;
//import android.widget.AdapterView;
//import android.widget.ImageView;
//import android.widget.ListView;
//import android.widget.ProgressBar;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import com.appuccino.collegefeed.adapters.CommentListAdapter;
//import com.appuccino.collegefeed.adapters.PostListAdapter;
//import com.appuccino.collegefeed.objects.Comment;
//import com.appuccino.collegefeed.objects.Post;
//import com.appuccino.collegefeed.utils.FontManager;
//import com.appuccino.collegefeed.utils.NetWorker;
//
//import java.util.ArrayList;
//import java.util.List;
//
///**
//* Created by Waylon on 7/6/2014.
//*/
//public class MyContentActivity extends Activity{
//
//    private static MyContentActivity thisActivity;
//    static ListView myPostsListView;
//    static ListView myCommentsListView;
//    static TextView postScore;
//    static TextView commentScore;
//    static ProgressBar topLoadingSpinner;
//    static ProgressBar bottomLoadingSpinner;
//    public static PostListAdapter postListAdapter;
//    public static CommentListAdapter commentListAdapter;
//    public static List<Post> postList = new ArrayList<Post>();
//    public static List<Comment> commentList = new ArrayList<Comment>();
//    public static List<Post> commentParentList = new ArrayList<Post>();
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        thisActivity = this;
//        setContentView(R.layout.my_content);
//        setupActionbar();
//        setupViews();
//        setupListViews();
//        setupListClickListeners();
//        fetchLists();
//    }
//
//    private void setupListViews() {
//        postListAdapter = new PostListAdapter(this, R.layout.list_row_collegepost, postList, 0, MainActivity.ALL_COLLEGES);
//        commentListAdapter = new CommentListAdapter(this, R.layout.list_row_collegepost, commentList, null);
//        myPostsListView = (ListView)findViewById(R.id.myPostsListView);
//        myCommentsListView = (ListView)findViewById(R.id.myCommentsListView);
//        topLoadingSpinner = (ProgressBar)findViewById(R.id.topLoadingSpinner);
//        bottomLoadingSpinner = (ProgressBar)findViewById(R.id.bottomLoadingSpinner);
//        //if doesnt have footer, add it
//        if(myCommentsListView.getFooterViewsCount() == 0)
//        {
//            //for card UI
//            View footer = new View(this);
//            footer.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
//            myCommentsListView.addFooterView(footer, null, false);
//        }
//        if(myPostsListView != null)
//            myPostsListView.setAdapter(postListAdapter);
//        else
//            Log.e("cfeed", "MyContentPostList list adapter wasn't set.");
//        if(myCommentsListView != null)
//            myCommentsListView.setAdapter(commentListAdapter);
//        else
//            Log.e("cfeed", "MyContentCommentList list adapter wasn't set.");
//    }
//
//    public void setupListClickListeners(){
//        myPostsListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//            @Override
//            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
//                postClicked(postList.get(i), i);
//            }
//        });
//
//        myCommentsListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//            @Override
//            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
//                commentClicked(commentList.get(i));
//            }
//        });
//    }
//
//    private void postClicked(Post post, int index) {
//        Intent intent = new Intent(this, CommentsActivity.class);
//        intent.putExtra("POST_ID", post.getID());
//        intent.putExtra("COLLEGE_ID", post.getCollegeID());
//        intent.putExtra("POST_INDEX", index);
//        intent.putExtra("SECTION_NUMBER", 2);
//
//        startActivity(intent);
//        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
//    }
//
//    private void commentClicked(Comment comment) {
//        Post parentPost = getParentPostOfComment(comment);
//        int index = getIndexOfParentPost(parentPost);
//        Log.i("cfeed", "ID of parent post: " + parentPost.getID());
//        Intent intent = new Intent(this, CommentsActivity.class);
//        intent.putExtra("POST_INDEX", index);
//        if(parentPost != null){
//            intent.putExtra("POST_ID", parentPost.getID());
//            intent.putExtra("COLLEGE_ID", parentPost.getCollegeID());
//        }
//        intent.putExtra("SECTION_NUMBER", 3);
//
//        startActivity(intent);
//        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
//    }
//
//    private void fetchLists() {
//        postList = new ArrayList<Post>();
//        commentList = new ArrayList<Comment>();
//        commentParentList = new ArrayList<Post>();
//        ConnectivityManager cm = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
//        if(cm.getActiveNetworkInfo() != null) {
//            new NetWorker.GetManyPostsTask(MainActivity.myPostsList, 0).execute(new NetWorker.PostSelector());
//            new NetWorker.GetMyCommentsTask().execute(new NetWorker.PostSelector());
//        } else {
//            Toast.makeText(this, "You have no internet connection.", Toast.LENGTH_LONG).show();
//            makeTopLoadingIndicator(false);
//            makeBottomLoadingIndicator(false);
//        }
//    }
//
//    private static Post getParentPostOfComment(Comment c){
//        if(commentParentList == null || commentParentList.size() == 0){
//            Toast.makeText(thisActivity, "Please give the comment list another second to load.", Toast.LENGTH_LONG).show();
//        } else {
//            for(Post p : commentParentList){
//                if(p.getID() == c.getPostID()){
//                    return p;
//                }
//            }
//        }
//        return null;
//    }
//
//    private static int getIndexOfParentPost(Post p){
//        if(p != null && commentParentList != null && commentParentList.size() > 0){
//            for(int i = 0; i < commentParentList.size(); i++){
//                if(commentParentList.get(i).getID() == p.getID()){
//                    return i;
//                }
//            }
//        }
//        return 0;
//    }
//
//    public static void updatePostList(ArrayList<Post> result) {
//        postList = new ArrayList<Post>();
//        postList.addAll(result);
//
//        if(postListAdapter != null)
//        {
//            Log.i("cfeed", "TEST new post size: " + postList.size());
//            postListAdapter.setCollegeFeedID(MainActivity.ALL_COLLEGES);
//            postListAdapter.clear();
//            postListAdapter.addAll(postList);
//            Log.i("cfeed","TEST last post size: " + postListAdapter.getCount());
//            postListAdapter.notifyDataSetChanged();
//            updateUserPostScore();
//        }
//    }
//
//    public static void updateCommentList(ArrayList<Comment> result) {
//        commentList = new ArrayList<Comment>();
//        commentList.addAll(result);
//
//        if(commentListAdapter != null)
//        {
//            Log.i("cfeed", "TEST new comment size: " + commentList.size());
//            commentListAdapter.clear();
//            commentListAdapter.addAll(commentList);
//            Log.i("cfeed","TEST last comment size: " + commentListAdapter.getCount());
//            commentListAdapter.notifyDataSetChanged();
//            updateUserCommentScore();
//        }
//
//        //fetch comments parent IDs
//        if(result != null && result.size() > 0){
//            List<Integer> commentParentIDs = new ArrayList<Integer>();
//            for(Comment c : commentList){
//                commentParentIDs.add(c.getPostID());
//            }
//            new NetWorker.GetManyPostsTask(commentParentIDs, 1).execute(new NetWorker.PostSelector());
//        }
//    }
//
//    public static void updateCommentParentList(ArrayList<Post> result) {
//        commentParentList = new ArrayList<Post>();
//        commentParentList.addAll(result);
//    }
//
//    private static void updateUserPostScore() {
//        if(postScore != null && postList != null && postList.size() != 0){
//            int scoreCount = 0;
//            for(Post p : postList){
//                scoreCount += p.getScore();
//            }
//            postScore.setText("Post Score: " + scoreCount);
//        }
//    }
//
//    private static void updateUserCommentScore() {
//        if(commentScore != null && commentList != null && commentList.size() != 0){
//            int scoreCount = 0;
//            for(Comment c : commentList){
//                scoreCount += c.getScore();
//            }
//            commentScore.setText("Comment Score: " + scoreCount);
//        }
//    }
//
//    private void setupActionbar() {
//        ActionBar actionBar = getActionBar();
//        actionBar.setCustomView(R.layout.actionbar_tag_layout);
//        actionBar.setDisplayShowTitleEnabled(false);
//        actionBar.setDisplayShowCustomEnabled(true);
//        actionBar.setDisplayUseLogoEnabled(false);
//        actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
//        actionBar.setIcon(R.drawable.logofake);
//
//        ImageView backButton = (ImageView)findViewById(R.id.backButtonTag);
//        if(backButton != null){
//            backButton.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View view) {
//                    onBackPressed();
//                }
//            });
//        }
//    }
//
//    private void setupViews() {
//        TextView myPostsText = (TextView)findViewById(R.id.myPostsTextView);
//        TextView myCommentsText = (TextView)findViewById(R.id.myCommentsTextView);
//        postScore = (TextView)findViewById(R.id.postScore);
//        commentScore = (TextView)findViewById(R.id.commentScore);
//
//        myPostsText.setTypeface(FontManager.light);
//        myCommentsText.setTypeface(FontManager.light);
//        postScore.setTypeface(FontManager.light);
//        commentScore.setTypeface(FontManager.light);
//    }
//
//    public static void makeTopLoadingIndicator(boolean makeLoading){
//        if(topLoadingSpinner != null){
//            if(makeLoading)
//            {
//                myPostsListView.setVisibility(View.INVISIBLE);
//                topLoadingSpinner.setVisibility(View.VISIBLE);
//            }
//            else
//            {
//                myPostsListView.setVisibility(View.VISIBLE);
//                topLoadingSpinner.setVisibility(View.INVISIBLE);
//            }
//        }
//    }
//
//    public static void makeBottomLoadingIndicator(boolean makeLoading){
//        if(bottomLoadingSpinner != null){
//            if(makeLoading)
//            {
//                myCommentsListView.setVisibility(View.INVISIBLE);
//                bottomLoadingSpinner.setVisibility(View.VISIBLE);
//            }
//            else
//            {
//                myCommentsListView.setVisibility(View.VISIBLE);
//                bottomLoadingSpinner.setVisibility(View.INVISIBLE);
//            }
//        }
//    }
//
//    @Override
//    public void onBackPressed() {
//        super.onBackPressed();
//        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
//    }
//}