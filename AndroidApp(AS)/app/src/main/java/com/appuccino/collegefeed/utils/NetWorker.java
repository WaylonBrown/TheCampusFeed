package com.appuccino.collegefeed.utils;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import com.appuccino.collegefeed.CommentsActivity;
import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.fragments.MostActiveCollegesFragment;
import com.appuccino.collegefeed.fragments.MyCommentsFragment;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TagFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Tag;
import com.appuccino.collegefeed.objects.Vote;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class NetWorker {

     public final static String SERVER_URL = "http://cfeed.herokuapp.com/api/";
     public final static String API_VERSION = "v1/";
     public final static String REQUEST_URL = SERVER_URL + API_VERSION;
     public final static String LOG_TAG = "NETWORK: ";

     public static HttpClient client = new DefaultHttpClient();

     public static class PostSelector{

     }

     public static class GetPostsTask extends AsyncTask<PostSelector, Void, ArrayList<Post> >
     {
         int whichFrag = 0;
         int feedID = 0;
         int pageNumber;
         boolean wasPullToRefresh;
         final int POSTS_PER_PAGE = 20;

         public GetPostsTask()
         {
         }

         public GetPostsTask(int whichFrag, int feedID, int pageNumber, boolean wasPullToRefresh)
         {
             this.whichFrag = whichFrag;
             this.feedID = feedID;
             this.pageNumber = pageNumber;
             this.wasPullToRefresh = wasPullToRefresh;
         }

         @Override
         protected void onPreExecute() {
             if(wasPullToRefresh){
                 if(whichFrag == 0)			//top posts
                     TopPostFragment.makeLoadingIndicator(true);
                 else                        //new posts
                     NewPostFragment.makeLoadingIndicator(true);
             }
             super.onPreExecute();
         }

         @Override
         protected ArrayList<Post> doInBackground(PostSelector... arg0) {
             String paginationString = "?page=" + pageNumber + "&per_page=" + POSTS_PER_PAGE;
             switch(whichFrag){
             case 0:
                 return fetchTopPostsFrag(paginationString);
             case 1:
                 return fetchNewPostsFrag(paginationString);
             default:
                 return fetchMyPostsFrag();
             }
         }

         private ArrayList<Post> fetchTopPostsFrag(String paginationString) {
             HttpGet request = null;
             if(feedID == MainActivity.ALL_COLLEGES)
                 request = new HttpGet(REQUEST_URL + "posts/trending" + paginationString);
             else
                 request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/posts/trending" + paginationString);

             return getPostsFromURLRequest(request);
         }

         private ArrayList<Post> fetchNewPostsFrag(String paginationString) {
             HttpGet request = null;
             if(feedID == MainActivity.ALL_COLLEGES)
                 request = new HttpGet(REQUEST_URL + "posts/recent" + paginationString);
             else
                 request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/posts/recent" + paginationString);

             return getPostsFromURLRequest(request);
         }

         private ArrayList<Post> fetchMyPostsFrag() {
             ArrayList<Post> ret = new ArrayList<Post>();
             return ret;
         }

         private ArrayList<Post> getPostsFromURLRequest(HttpGet request) {
             ArrayList<Post> ret = new ArrayList<Post>();
             ResponseHandler<String> responseHandler = new BasicResponseHandler();
             String response = null;
             try {
                 response = client.execute(request, responseHandler);
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
             } catch (IOException e) {
                 e.printStackTrace();
             }

             if(response != null)
                 Log.d("cfeed", LOG_TAG + response);

             try {
                 ret = JSONParser.postListFromJSON(response);
             } catch (IOException e) {
                 e.printStackTrace();
             }
             return ret;
         }

         @Override
         protected void onPostExecute(ArrayList<Post> result) {
             if(whichFrag == 0)		//top posts
             {
                 if(result != null && result.size() != 0){
                     //I have zero idea why this first line is needed, but without it the listadapter doesn't load the new list
                     TopPostFragment.postList = new ArrayList<Post>(TopPostFragment.postList);
                     TopPostFragment.postList.addAll(result);
                     //NewPostFragment.postList = new ArrayList<Post>(result);
                 }else{
                     TopPostFragment.endOfListReached = true;
                 }

                 //use these 2 test lines if you want to show the "pull down to load posts" test
                 /*
                 TopPostFragment.endOfListReached = true;
                 TopPostFragment.postList = new ArrayList<Post>();
                 */
                 TopPostFragment.updateList();
                 TopPostFragment.makeLoadingIndicator(false);
                 TopPostFragment.setupFooterListView();
                 TopPostFragment.currentPageNumber++;
                 TopPostFragment.removeFooterSpinner();
             }
             else	//new posts
             {
                 if(result != null && result.size() != 0){
                     //I have zero idea why this first line is needed, but without it the listadapter doesn't load the new list
                     NewPostFragment.postList = new ArrayList<Post>(NewPostFragment.postList);
                     NewPostFragment.postList.addAll(result);
                     //NewPostFragment.postList = new ArrayList<Post>(result);
                 }else{
                     NewPostFragment.endOfListReached = true;
                 }

                 NewPostFragment.updateList();
                 NewPostFragment.makeLoadingIndicator(false);
                 NewPostFragment.setupFooterListView();
                 NewPostFragment.currentPageNumber++;
                 NewPostFragment.removeFooterSpinner();
             }
         }
     }

     public static class GetCommentsTask extends AsyncTask<PostSelector, Void, ArrayList<Comment>>
     {
         int postID = 0;
         CommentsActivity activity;

         public GetCommentsTask()
         {
         }

         public GetCommentsTask(CommentsActivity activity, int postID)
         {
             this.postID = postID;
             this.activity = activity;
         }

         @Override
         protected void onPreExecute() {
             activity.makeLoadingIndicator(true);
             super.onPreExecute();
         }

         @Override
         protected ArrayList<Comment> doInBackground(PostSelector... arg0) {
             HttpGet request = new HttpGet(REQUEST_URL + "posts/" + postID + "/comments");
             ArrayList<Comment> ret = new ArrayList<Comment>();
             ResponseHandler<String> responseHandler = new BasicResponseHandler();
             String response = null;
             try {
                 response = client.execute(request, responseHandler);
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
             } catch (IOException e) {
                 e.printStackTrace();
             }

             if(response != null)
                 Log.d("cfeed", LOG_TAG + "Server response: " + response);

             try {
                 ret = JSONParser.commentListFromJSON(response, postID);
             } catch (IOException e) {
                 e.printStackTrace();
             }
             return ret;
         }

         @Override
         protected void onPostExecute(ArrayList<Comment> result) {
             CommentsActivity.commentList = new ArrayList<Comment>(result);
             CommentsActivity.updateList();
             activity.makeLoadingIndicator(false);
         }
     }

     public static class GetTagFragmentTask extends AsyncTask<PostSelector, Void, ArrayList<Tag> >
     {
         int feedID = 0;

         public GetTagFragmentTask()
         {
         }

         public GetTagFragmentTask(int feedID)
         {
             this.feedID = feedID;
         }

         @Override
         protected void onPreExecute() {
             TagFragment.makeLoadingIndicator(true);
             super.onPreExecute();
         }

         @Override
         protected ArrayList<Tag> doInBackground(PostSelector... arg0) {
             HttpGet request = null;
             if(feedID == MainActivity.ALL_COLLEGES)
                 request = new HttpGet(REQUEST_URL + "tags/trending");
             else
                 request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/tags/trending");

             return getTagsFromURLRequest(request);
         }

         private ArrayList<Tag> getTagsFromURLRequest(HttpGet request) {
             ArrayList<Tag> ret = new ArrayList<Tag>();
             ResponseHandler<String> responseHandler = new BasicResponseHandler();
             String response = null;
             try {
                 response = client.execute(request, responseHandler);
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
             } catch (IOException e) {
                 e.printStackTrace();
             }

             if(response != null)
                 Log.d("cfeed", LOG_TAG + response);

             try {
                 ret = JSONParser.tagListFromJSON(response);
             } catch (IOException e) {
                 e.printStackTrace();
             }
             return ret;
         }

         @Override
         protected void onPostExecute(ArrayList<Tag> result) {
             TagFragment.tagList = new ArrayList<Tag>(result);
             TagFragment.updateList();
             TagFragment.makeLoadingIndicator(false);
             TagFragment.setupFooterListView();
         }
     }

     public static class GetTagActivityTask extends AsyncTask<PostSelector, Void, ArrayList<Post> >
     {
         int feedID = 0;
         TagListActivity activity;
         String tagText;

         public GetTagActivityTask()
         {
         }

         public GetTagActivityTask(TagListActivity activity, int feedID, String text)
         {
             this.feedID = feedID;
             this.activity = activity;
             tagText = text;
         }

         @Override
         protected void onPreExecute() {
             activity.makeLoadingIndicator(true);
             super.onPreExecute();
         }

         @Override
         protected ArrayList<Post> doInBackground(PostSelector... arg0) {
             HttpGet request = null;
             if(feedID == MainActivity.ALL_COLLEGES)
                 request = new HttpGet(REQUEST_URL + "posts/byTag/" + tagText);
             else
                 request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/posts/byTag/" + tagText);

             return getPostsFromURLRequest(request);
         }

         private ArrayList<Post> getPostsFromURLRequest(HttpGet request) {
             ArrayList<Post> ret = new ArrayList<Post>();
             ResponseHandler<String> responseHandler = new BasicResponseHandler();
             String response = null;
             try {
                 response = client.execute(request, responseHandler);
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
             } catch (IOException e) {
                 e.printStackTrace();
             }

             if(response != null)
                 Log.d("cfeed", LOG_TAG + response);

             try {
                 ret = JSONParser.postListFromJSON(response);
             } catch (IOException e) {
                 e.printStackTrace();
             }
             return ret;
         }

         @Override
         protected void onPostExecute(ArrayList<Post> result) {
             activity.postList = new ArrayList<Post>(result);
             TagListActivity.updateList();
             activity.makeLoadingIndicator(false);
         }
     }

     public static class GetCollegeFragmentTask extends AsyncTask<PostSelector, Void, ArrayList<College> >
     {
         public GetCollegeFragmentTask()
         {
         }

         @Override
         protected void onPreExecute() {
             MostActiveCollegesFragment.makeLoadingIndicator(true);
             super.onPreExecute();
         }

         @Override
         protected ArrayList<College> doInBackground(PostSelector... arg0) {
             HttpGet request = new HttpGet(REQUEST_URL + "colleges/trending?page=1&per_page=20");

             return getCollegesFromURLRequest(request);
         }

         private ArrayList<College> getCollegesFromURLRequest(HttpGet request) {
             ArrayList<College> ret = new ArrayList<College>();
             ResponseHandler<String> responseHandler = new BasicResponseHandler();
             String response = null;
             try {
                 response = client.execute(request, responseHandler);
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
             } catch (IOException e) {
                 e.printStackTrace();
             }

             if(response != null)
                 Log.d("cfeed", LOG_TAG + response);

             try {
                 ret = JSONParser.collegeListFromJSON(response);
             } catch (IOException e) {
                 e.printStackTrace();
             }
             return ret;
         }

         @Override
         protected void onPostExecute(ArrayList<College> result) {
             MostActiveCollegesFragment.collegeList = new ArrayList<College>(result);
             MostActiveCollegesFragment.updateList();
             MostActiveCollegesFragment.makeLoadingIndicator(false);
         }
     }

    public static class GetFullCollegeListTask extends AsyncTask<PostSelector, Void, ArrayList<College> >
    {
        String checkSumVersion;

        public GetFullCollegeListTask(String s){
            checkSumVersion = s;
        }

        @Override
        protected ArrayList<College> doInBackground(PostSelector... arg0) {
            HttpGet request = new HttpGet(REQUEST_URL + "colleges");
            return getCollegesFromURLRequest(request);
        }

        private ArrayList<College> getCollegesFromURLRequest(HttpGet request) {
            ArrayList<College> ret = new ArrayList<College>();
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            String response = null;
            try {
                response = client.execute(request, responseHandler);
            } catch (ClientProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

            if(response != null && !response.isEmpty()) {
                Log.d("cfeed", LOG_TAG + response);
                Log.d("cfeed", "COLLEGE_LIST storing new server college list into strings");
                String first = response.substring(0, response.length() / 2);
                String second = response.substring((response.length() / 2) + 1, response.length());
                PrefManager.putString(MainActivity.PREFERENCE_KEY_COLLEGE_LIST1, first);
                PrefManager.putString(MainActivity.PREFERENCE_KEY_COLLEGE_LIST2, second);
            }

            try {
                ret = JSONParser.collegeListFromJSON(response);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return ret;
        }

        @Override
        protected void onPostExecute(ArrayList<College> result) {
            MainActivity.collegeList = result;
            PrefManager.putCollegeListCheckSum(checkSumVersion);
            Log.i("cfeed","COLLEGE_LIST Updated main college list.");
        }
    }

    public static class GetManyPostsTask extends AsyncTask<PostSelector, Void, ArrayList<Post> >
    {
        private List<Integer> postIDList;
        private MyPostsFragment frag;

        public GetManyPostsTask(List<Integer> postIDList, MyPostsFragment frag)
        {
            this.postIDList = postIDList;
            this.frag = frag;
        }

        public GetManyPostsTask(List<Integer> postIDList)
        {
            this.postIDList = postIDList;
            frag = null;
        }

        @Override
        protected void onPreExecute() {
            if(frag != null){
                frag.makeLoadingIndicator(true);
            }
            super.onPreExecute();
        }

        @Override
        protected ArrayList<Post> doInBackground(PostSelector... arg0) {
            String arrayQuery = "";
            if(postIDList == null || postIDList.size() == 0){
                return new ArrayList<Post>();
            } else {
                for(int n : postIDList){
                    arrayQuery += ("many_ids[]=" + n + "&");
                }
                //remove final &
                if(arrayQuery.length() > 0){
                    arrayQuery = arrayQuery.substring(0, arrayQuery.length()-1);
                }
                HttpGet request = new HttpGet(REQUEST_URL + "posts/many?" + arrayQuery);
                return getPostsFromURLRequest(request);
            }

        }

        private ArrayList<Post> getPostsFromURLRequest(HttpGet request) {
            ArrayList<Post> ret = new ArrayList<Post>();
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            String response = null;
            try {
                response = client.execute(request, responseHandler);
            } catch (ClientProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

            if(response != null)
                Log.d("cfeed", LOG_TAG + response);

            try {
                ret = JSONParser.postListFromJSON(response);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return ret;
        }

        @Override
        protected void onPostExecute(ArrayList<Post> result) {
            if(frag != null){
                frag.updateList(result);
                frag.makeLoadingIndicator(false);
            }
            else{
                MyCommentsFragment.updateCommentParentList(result);
            }
            super.onPostExecute(result);
        }
    }

    public static class GetMyCommentsTask extends AsyncTask<PostSelector, Void, ArrayList<Comment> >
    {
        MyCommentsFragment frag;

        public GetMyCommentsTask(MyCommentsFragment frag)
        {
            this.frag = frag;
        }

        @Override
        protected void onPreExecute() {
            frag.makeLoadingIndicator(true);
            super.onPreExecute();
        }

        @Override
        protected ArrayList<Comment> doInBackground(PostSelector... arg0) {
            String arrayQuery = "";
            if(MainActivity.myCommentsList == null || MainActivity.myCommentsList.size() == 0){
                return new ArrayList<Comment>();
            } else {
                for(int n : MainActivity.myCommentsList){
                    arrayQuery += ("many_ids[]=" + n + "&");
                }
                //remove final &
                if(arrayQuery.length() > 0){
                    arrayQuery = arrayQuery.substring(0, arrayQuery.length()-1);
                }
                HttpGet request = new HttpGet(REQUEST_URL + "comments/many?" + arrayQuery);
                return getCommentsFromURLRequest(request);
            }

        }

        private ArrayList<Comment> getCommentsFromURLRequest(HttpGet request) {
            ArrayList<Comment> ret = new ArrayList<Comment>();
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            String response = null;
            try {
                response = client.execute(request, responseHandler);
            } catch (ClientProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

            if(response != null)
                Log.d("cfeed", LOG_TAG + response);

            try {
                ret = JSONParser.commentListFromJSON(response);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return ret;
        }

        @Override
        protected void onPostExecute(ArrayList<Comment> result) {
            frag.updateList(result);
            frag.makeLoadingIndicator(false);
            super.onPostExecute(result);
        }
    }

     public static class MakePostTask extends AsyncTask<Post, Void, Boolean>{

         Context c;
         String response = null;
         int postCollegeID;
         MainActivity main;

         public MakePostTask(Context context, MainActivity main) {
             c = context;
             this.main = main;
         }

         @Override
         protected Boolean doInBackground(Post... posts) {
             try{
                 postCollegeID = posts[0].getCollegeID();
                 Log.i("cfeed",LOG_TAG + "Posting to feed with ID of " + posts[0].getCollegeID());
                 Log.i("cfeed",LOG_TAG + "Request URL: " + REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
                 HttpPost request = new HttpPost(REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
                 request.setHeader("Content-Type", "application/json");
                 request.setEntity(new ByteArrayEntity(posts[0].toJSONString().toByteArray()));
                 ResponseHandler<String> responseHandler = new BasicResponseHandler();
                 response = client.execute(request, responseHandler);
                 Log.d("cfeed", LOG_TAG + "Server response: " + response);
                 return true;
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
                 return false;
             } catch (IOException e) {
                 e.printStackTrace();
                 return false;
             }
         }

         @Override
         protected void onPostExecute(Boolean result) {
             if(!result)
                 Toast.makeText(c, "Failed to post, please try again later.", Toast.LENGTH_LONG).show();
             else{
                 parseResponseIntoPostAndAdd(response);
             }
             super.onPostExecute(result);
         }

         private void parseResponseIntoPostAndAdd(String response) {
             try {
                 Log.i("cfeed","NETWORK: Successful post response, adding to list");
                 Post responsePost = JSONParser.postFromJSON(response);
                 responsePost.setCollegeID(postCollegeID);
                 if(MainActivity.getCollegeByID(postCollegeID) != null){
                     responsePost.setCollegeName(MainActivity.getCollegeByID(postCollegeID).getName());
                 }
                 MainActivity.postVoteList.add(new Vote(-1, responsePost.getID(), true));
                 PrefManager.putPostVoteList(MainActivity.postVoteList);
                 main.addNewPostToListAndMyContent(responsePost, c);
             } catch (IOException e) {
                 Log.i("cfeed","ERROR: post not added");
                 e.printStackTrace();
             }

         }
     }

     public static class MakeCommentTask extends AsyncTask<Comment, Void, Boolean>{

         Context c;
         String response;

         public MakeCommentTask(Context context) {
             c = context;
         }

         @Override
         protected Boolean doInBackground(Comment... comments) {
             try{
                 Log.i("cfeed",LOG_TAG + "Making comment with college ID of " + comments[0].getCollegeID() +
                         " and Post ID of " + comments[0].getPostID());
                 String fullRequestURL = REQUEST_URL + "posts/" + comments[0].getPostID() + "/comments";
                 Log.i("cfeed",LOG_TAG + "Request URL: " + fullRequestURL);
                 Log.i("cfeed",LOG_TAG + "JSON to send: " + comments[0].toJSONString());
                 HttpPost request = new HttpPost(fullRequestURL);
                 request.setHeader("Content-Type", "application/json");
                 request.setEntity(new ByteArrayEntity(comments[0].toJSONString().toByteArray()));
                 ResponseHandler<String> responseHandler = new BasicResponseHandler();
                 response = client.execute(request, responseHandler);

                 Log.d("cfeed", LOG_TAG + "Server response: " + response);
                 return true;
             } catch (ClientProtocolException e) {
                 e.printStackTrace();
                 return false;
             } catch (IOException e) {
                 e.printStackTrace();
                 return false;
             }
         }

         @Override
         protected void onPostExecute(Boolean result) {
             if(!result)
                 Toast.makeText(c, "Failed to , please try again later.", Toast.LENGTH_LONG).show();
             else{
                 Comment responseComment = null;
                 try {
                     responseComment = JSONParser.commentFromJSON(response);
                     int id = responseComment.getID();
                     Log.i("cfeed","ID: " + id);
                     MainActivity.commentVoteList.add(new Vote(-1, responseComment.getPostID(), responseComment.getID(), true));
                     PrefManager.putCommentVoteList(MainActivity.commentVoteList);
                     MainActivity.myCommentsList.add(id);
                     PrefManager.putMyCommentsList(MainActivity.myCommentsList);
                     //instantly add to new comments
                     CommentsActivity.commentList.add(0, responseComment);
                     CommentsActivity.updateList();

                     MainActivity.lastCommentTime = Calendar.getInstance();
                     PrefManager.putLastCommentTime(MainActivity.lastCommentTime);

                     Log.i("cfeed","New My Comments list is of size " + MainActivity.myCommentsList.size());
                 } catch (IOException e) {
                     e.printStackTrace();
                 }
             }
             super.onPostExecute(result);
         }

     }

    public static class MakePostVoteTask extends AsyncTask<Vote, Void, Boolean>{
        Context c;
        String response = null;

        public MakePostVoteTask(Context c){
            this.c = c;
        }
        public Boolean doInBackground(Vote... votes){
            try{
                HttpPost request = new HttpPost(REQUEST_URL + "posts/" + votes[0].postID + "/votes");
                request.setHeader("Content-Type", "application/json");
                request.setEntity(new ByteArrayEntity(votes[0].toJSONString().toByteArray()));
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                response = client.execute(request, responseHandler);

                Log.i("cfeed", LOG_TAG + " Make vote server response: " + response);
                return true;
            } catch (ClientProtocolException e) {
                e.printStackTrace();
                return false;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        }

        public void onPostExecute(Boolean result){
            if(!result){
                Log.e("cfeed","Vote didnt work");
            }

            Vote returnedVote = null;
            try {
                returnedVote = JSONParser.postVoteFromJSON(response);
                MainActivity.postVoteList.add(returnedVote);
                PrefManager.putPostVoteList(MainActivity.postVoteList);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static class MakeCommentVoteTask extends AsyncTask<Vote, Void, Boolean>{
        Context c;
        String response = "";
        Comment comment;

        public MakeCommentVoteTask(Context c, Comment comment){
            this.c = c;
            this.comment = comment;
        }

        public Boolean doInBackground(Vote... votes){
            try{
                HttpPost request = new HttpPost(REQUEST_URL + "posts/" + votes[0].postID + "/comments/" + votes[0].commentID + "/votes");
                request.setHeader("Content-Type", "application/json");
                request.setEntity(new ByteArrayEntity(votes[0].toJSONString().toByteArray()));
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                response = client.execute(request, responseHandler);

                Log.d("cfeed", LOG_TAG + "Make vote server response: " + response);
                return true;
            } catch (ClientProtocolException e) {
                e.printStackTrace();
                return false;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        }

        public void onPostExecute(Boolean result){
            if(!result){
                Log.e("cfeed","Vote didnt work");
            }

            Vote returnedVote = null;
            try {
                returnedVote = JSONParser.commentVoteFromJSON(response, comment);
                MainActivity.commentVoteList.add(returnedVote);
                PrefManager.putCommentVoteList(MainActivity.commentVoteList);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static class MakePostVoteDeleteTask extends AsyncTask<Vote, Void, Boolean>{
        Vote vote;
        Context c;

        public MakePostVoteDeleteTask(Context c){
            this.c = c;
        }
        public Boolean doInBackground(Vote... votes){
            try{
                vote = votes[0];
                if(vote != null){
                    HttpDelete request = new HttpDelete(REQUEST_URL + "votes/" + vote.id);
                    //request.setEntity(new ByteArrayEntity(
                    //  votes[0].toString().getBytes("UTF8")));
                    ResponseHandler<String> responseHandler = new BasicResponseHandler();
                    String response = client.execute(request, responseHandler);

                    Log.d("cfeed", LOG_TAG + "Make vote delete server response: " + response);
                    return true;
                } else {
                    Log.e("cfeed", "ERROR DELETING VOTE, IT WAS NULL");
                    return false;
                }

            } catch (ClientProtocolException e) {
                e.printStackTrace();
                return false;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        }

        public void onPostExecute(Boolean result){
            if(!result){
                Log.e("cfeed", "Vote delete didn't work.");
            }

            MainActivity.removePostVoteByPostID(vote.postID);
            PrefManager.putPostVoteList(MainActivity.postVoteList);
        }
    }

    public static class MakeCommentVoteDeleteTask extends AsyncTask<Vote, Void, Boolean>{
        Vote vote;
        Context c;

        public MakeCommentVoteDeleteTask(Context c){
            this.c = c;
        }

        public Boolean doInBackground(Vote... votes){
            try{
                vote = votes[0];
                if(vote != null){
                    HttpDelete request = new HttpDelete(REQUEST_URL + "votes/" + vote.id);
                    //request.setEntity(new ByteArrayEntity(
                    //  votes[0].toString().getBytes("UTF8")));
                    ResponseHandler<String> responseHandler = new BasicResponseHandler();
                    String response = client.execute(request, responseHandler);

                    Log.d("cfeed", LOG_TAG + "Make vote server response: " + response);
                    return true;
                } else {
                    Log.e("cfeed", "ERROR DELETING VOTE, IT WAS NULL");
                    return false;
                }
            } catch (ClientProtocolException e) {
                e.printStackTrace();
                return false;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        }

        public void onPostExecute(Boolean result){
            if(!result){
                Log.e("cfeed", "Vote delete didn't work.");
            }

            MainActivity.removeCommentVoteByCommentID(vote.commentID);
            PrefManager.putCommentVoteList(MainActivity.commentVoteList);
        }
    }

    public static class MakeFlagTask extends AsyncTask<Integer, Void, Boolean>{

        Context c;
        int postID;

        public MakeFlagTask(Context c){
            this.c = c;
        }


        @Override
        protected void onPreExecute() {
            CommentsActivity.addActionBarLoadingIndicatorAndRemoveFlag();
            super.onPreExecute();
        }


        public Boolean doInBackground(Integer... postID){
            this.postID = postID[0];
            try{
                HttpGet request = new HttpGet(REQUEST_URL + "posts/" + postID[0] + "/flags");
                //request.setEntity(new ByteArrayEntity(String.valueOf(postID).getBytes("UTF8")));
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                String response = client.execute(request, responseHandler);

                Log.d("cfeed", LOG_TAG + "Make flag server response: " + response);
                return true;
            } catch (ClientProtocolException e) {
                e.printStackTrace();
                return false;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        }

        public void onPostExecute(Boolean result){
            Log.d("http", LOG_TAG + "success: " + result);
            if(result){
                MainActivity.flagList.add(postID);
                PrefManager.putFlagList(MainActivity.flagList);
                CommentsActivity.removeFlagButtonAndLoadingIndicator();
                Toast.makeText(c, "Post has been flagged, thank you :)", Toast.LENGTH_LONG).show();
            }else{
                Toast.makeText(c, "Failed to flag post, please try again later.", Toast.LENGTH_LONG).show();
                CommentsActivity.removeActionBarLoadingIndicatorAndAddFlag();
            }
            super.onPostExecute(result);
        }
    }

    public static class CollegeListCheckSumTask extends AsyncTask<Integer, Void, Boolean>{

        String response;

        public Boolean doInBackground(Integer... postID){
            try{
                HttpGet request = new HttpGet(REQUEST_URL + "colleges/listVersion");
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                response = client.execute(request, responseHandler);

                Log.d("cfeed", LOG_TAG + "Checksum server response: " + response);
                return true;
            } catch (ClientProtocolException e) {
                e.printStackTrace();
                return false;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        }

        public void onPostExecute(Boolean result){
            Log.d("http", LOG_TAG + "success: " + result);
            if(result){
                String version = null;
                try {
                    version = JSONParser.checkSumFromJSON(response);
                    if(version.equals(MainActivity.collegeListCheckSum)){
                        Log.i("cfeed", "CHECKSUM: same");
                    } else {
                        Log.i("cfeed", "CHECKSUM: different, updating college list...");
                        MainActivity.updateCollegeList(version);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            super.onPostExecute(result);
        }
    }
 }
