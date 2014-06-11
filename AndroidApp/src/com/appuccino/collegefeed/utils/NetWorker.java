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

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.fragments.MyCommentsFragment;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;

public class NetWorker {
	
	public final static String SERVER_URL = "http://cfeed.herokuapp.com/api/";
	public final static String API_VERSION = "v1/";
	public final static String REQUEST_URL = SERVER_URL + API_VERSION;
	
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
			ArrayList<Post> ret = new ArrayList<Post>();
			HttpGet request = null;
			if(feedID == MainActivity.ALL_COLLEGES)
				request = new HttpGet(REQUEST_URL + "posts");
			else
				request = new HttpGet(REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/posts");
			
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
				Log.d("http", response);
			
			try {
				ret = JSONParser.postListFromJSON(response);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return ret;
		}

		private ArrayList<Post> fetchNewPostsFrag() {
			ArrayList<Post> ret = new ArrayList<Post>();
			return ret;
		}
		
		private ArrayList<Post> fetchMyPostsFrag() {
			ArrayList<Post> ret = new ArrayList<Post>();
			return ret;
		}

		@Override
		protected void onPostExecute(ArrayList<Post> result) {
			if(whichFrag == 0)		//top posts
			{
				//activityContext.getFragment
				TopPostFragment.postList.clear();
				TopPostFragment.postList.addAll(result);
				TopPostFragment.updateList();
				TopPostFragment.makeLoadingIndicator(false);
				TopPostFragment.setupFooterListView();
			}
			else if(whichFrag == 1)	//new posts
			{
				NewPostFragment.postList.clear();
				NewPostFragment.postList.addAll(result);
				NewPostFragment.updateList();
				NewPostFragment.makeLoadingIndicator(false);
				NewPostFragment.setupFooterListView();
			}
			else if(whichFrag == 2)	//my posts
			{
				MyPostsFragment.postList.clear();
				MyPostsFragment.postList.addAll(result);
				MyPostsFragment.updateList();
				MyPostsFragment.makeLoadingIndicator(false);
			}
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
				Log.i("cfeed","Request URL: " + REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
				HttpPost request = new HttpPost(REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
				request.setHeader("Content-Type", "application/json");
				request.setEntity(new ByteArrayEntity(posts[0].toJSONString().toByteArray()));
				ResponseHandler<String> responseHandler = new BasicResponseHandler();
				String response = client.execute(request, responseHandler);
				
				Log.d("cfeed", "Server response: " + response);
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

				HttpGet request = new HttpGet(REQUEST_URL + "votes");
				//request.setEntity(new ByteArrayEntity(
				  //  votes[0].toString().getBytes("UTF8")));
				ResponseHandler<String> responseHandler = new BasicResponseHandler();
				String response = client.execute(request, responseHandler);
				
				Log.d("http", response);
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
			Log.d("http", "success: " + result);
		}
	}
}
