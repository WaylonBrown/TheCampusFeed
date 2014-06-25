package com.appuccino.collegefeed.utils;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import com.appuccino.collegefeed.CommentsActivity;
import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.TagListActivity;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TagFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Tag;
import com.appuccino.collegefeed.objects.Vote;

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
		
		public GetPostsTask()
		{
		}
		
		public GetPostsTask(int whichFrag, int feedID)
		{
			this.whichFrag = whichFrag;
			this.feedID = feedID;
		}
		
		@Override
		protected void onPreExecute() {
			if(whichFrag == 0)			//top posts
				TopPostFragment.makeLoadingIndicator(true);
			else if (whichFrag == 1)	//new posts
				NewPostFragment.makeLoadingIndicator(true);
			else if (whichFrag == 2)	//my posts
				MyPostsFragment.makeLoadingIndicator(true);
			super.onPreExecute();
		}

		@Override
		protected ArrayList<Post> doInBackground(PostSelector... arg0) {
			switch(whichFrag){
			case 0:
				return fetchTopPostsFrag();
			case 1:
				return fetchNewPostsFrag();
			default:
				return fetchMyPostsFrag();
			}
		}
		
		private ArrayList<Post> fetchTopPostsFrag() {
			HttpGet request = null;
			if(feedID == MainActivity.ALL_COLLEGES)
				request = new HttpGet(REQUEST_URL + "posts/trending");
			else
				request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/posts/trending");
			
			return getPostsFromURLRequest(request);
		}

		private ArrayList<Post> fetchNewPostsFrag() {
			HttpGet request = null;
			if(feedID == MainActivity.ALL_COLLEGES)
				request = new HttpGet(REQUEST_URL + "posts/recent");
			else
				request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/posts/recent");
			
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if(response != null)
				Log.d("cfeed", LOG_TAG + response);
			
			try {
				ret = JSONParser.postListFromJSON(response);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return ret;
		}

		@Override
		protected void onPostExecute(ArrayList<Post> result) {
			if(whichFrag == 0)		//top posts
			{
				TopPostFragment.postList = new ArrayList<Post>(result);
				TopPostFragment.updateList();
				TopPostFragment.makeLoadingIndicator(false);
				TopPostFragment.setupFooterListView();
			}
			else if(whichFrag == 1)	//new posts
			{
				NewPostFragment.postList = new ArrayList<Post>(result);
				NewPostFragment.updateList();
				NewPostFragment.makeLoadingIndicator(false);
				NewPostFragment.setupFooterListView();
			}
			else if(whichFrag == 2)	//my posts
			{
				MyPostsFragment.postList = new ArrayList<Post>(result);
				MyPostsFragment.updateList();
				MyPostsFragment.makeLoadingIndicator(false);
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if(response != null)
				Log.d("cfeed", LOG_TAG + "Server response: " + response);
			
			try {
				ret = JSONParser.commentListFromJSON(response, postID);
			} catch (IOException e) {
				// TODO Auto-generated catch block
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if(response != null)
				Log.d("cfeed", LOG_TAG + response);
			
			try {
				ret = JSONParser.tagListFromJSON(response);
			} catch (IOException e) {
				// TODO Auto-generated catch block
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
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if(response != null)
				Log.d("cfeed", LOG_TAG + response);
			
			try {
				ret = JSONParser.postListFromJSON(response);
			} catch (IOException e) {
				// TODO Auto-generated catch block
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
	
	public static class MakePostTask extends AsyncTask<Post, Void, Boolean>{

		Context c;
		
		public MakePostTask(Context context) {
			c = context;
		}

		@Override
		protected Boolean doInBackground(Post... posts) {
			try{
				Log.i("cfeed",LOG_TAG + "Posting to feed with ID of " + posts[0].getCollegeID());
				Log.i("cfeed",LOG_TAG + "Request URL: " + REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
				HttpPost request = new HttpPost(REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
				request.setHeader("Content-Type", "application/json");
				request.setEntity(new ByteArrayEntity(posts[0].toJSONString().toByteArray()));
				ResponseHandler<String> responseHandler = new BasicResponseHandler();
				String response = client.execute(request, responseHandler);
				
				Log.d("cfeed", LOG_TAG + "Server response: " + response);
				return true;
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
		}

		@Override
		protected void onPostExecute(Boolean result) {
			if(!result)
				Toast.makeText(c, "Failed to post.", Toast.LENGTH_LONG).show();
			super.onPostExecute(result);
		}
		
	}
	
	public static class MakeCommentTask extends AsyncTask<Comment, Void, Boolean>{

		Context c;
		
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
				String response = client.execute(request, responseHandler);
				
				Log.d("cfeed", LOG_TAG + "Server response: " + response);
				return true;
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
		}

		@Override
		protected void onPostExecute(Boolean result) {
			if(!result)
				Toast.makeText(c, "Failed to post.", Toast.LENGTH_LONG).show();
			super.onPostExecute(result);
		}
		
	}
	
	public static class MakeVoteTask extends AsyncTask<Vote, Void, Boolean>{
		public Boolean doInBackground(Vote... votes){
			try{
				HttpGet request = new HttpGet(REQUEST_URL + "posts/" + votes[0].id + "/votes");
				//request.setEntity(new ByteArrayEntity(
				  //  votes[0].toString().getBytes("UTF8")));
				ResponseHandler<String> responseHandler = new BasicResponseHandler();
				String response = client.execute(request, responseHandler);
				
				Log.d("cfeed", LOG_TAG + "Make vote server response: " + response);
				return true;
			} catch (ClientProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
		}
		
		public void onPostExecute(Boolean result){
			Log.d("http", LOG_TAG + "success: " + result);
		}
	}
}
