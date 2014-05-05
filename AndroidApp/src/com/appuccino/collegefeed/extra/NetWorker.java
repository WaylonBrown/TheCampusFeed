package com.appuccino.collegefeed.extra;

import java.io.IOException;
import java.util.ArrayList;

import org.apache.http.Header;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

import android.os.AsyncTask;
import android.util.Log;

import com.appuccino.collegefeed.fragments.MyCommentsFragment;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;

public class NetWorker {
	
	public static String serverUrl = "http://cfeed.herokuapp.com/api/";
	public static String apiVersion = "v1/";
	public static String requestUrl = serverUrl + apiVersion;
	
	public static HttpClient client = new DefaultHttpClient();
	
	public static class PostSelector{
		
	}
	
	public static class GetPostsTask extends AsyncTask<PostSelector, Void, ArrayList<Post> >
	{
		int whichFrag = 0;
		
		public GetPostsTask()
		{
		}
		
		public GetPostsTask(int whichFrag)
		{
			this.whichFrag = whichFrag;
		}
		
		@Override
		protected void onPreExecute() {
			if(whichFrag == 0)			//top posts
				TopPostFragment.makeLoadingIndicator(true);
			else if (whichFrag == 1)	//new posts
				NewPostFragment.makeLoadingIndicator(true);
			else if (whichFrag == 2)	//my posts
				MyPostsFragment.makeLoadingIndicator(true);
			else if (whichFrag == 2)	//my comments
				MyCommentsFragment.makeLoadingIndicator(true);
			super.onPreExecute();
		}

		@Override
		protected ArrayList<Post> doInBackground(PostSelector... arg0) {
			HttpGet request = new HttpGet(requestUrl + "posts");
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
			ArrayList<Post> ret = null;
			try {
				ret = Post.postsFromJson(response);
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
				//activityContext.getFragment
				TopPostFragment.postList.clear();
				TopPostFragment.postList.addAll(result);
				TopPostFragment.updateList();
				TopPostFragment.makeLoadingIndicator(false);
			}
			else if(whichFrag == 1)	//new posts
			{
				NewPostFragment.postList.clear();
				NewPostFragment.postList.addAll(result);
				NewPostFragment.updateList();
				NewPostFragment.makeLoadingIndicator(false);
			}
			else if(whichFrag == 2)	//my posts
			{
				MyPostsFragment.postList.clear();
				MyPostsFragment.postList.addAll(result);
				MyPostsFragment.updateList();
				MyPostsFragment.makeLoadingIndicator(false);
			}
			//IMPLEMENT WHEN SERVER IS SET UP
//			else if(whichFrag == 2)	//my comments
//			{
//				MyCommentsFragment.commentList.clear();
//				MyCommentsFragment.commentList.addAll(result);
//				MyPostsFragment.updateList();
//				MyPostsFragment.makeLoadingIndicator(false);
//			}
		}

		
		
	}
	
	public static class MakePostTask extends AsyncTask<Post, Void, Boolean>{

		@Override
		protected Boolean doInBackground(Post... posts) {
			try{

				HttpPost request = new HttpPost(requestUrl + "posts");
				request.setHeader("Content-Type", "application/json");
				request.setEntity(new ByteArrayEntity(posts[0].toJSONString().toByteArray()));
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

		@Override
		protected void onPostExecute(Boolean result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
		}
		
	}
	
	public static class MakeVoteTask extends AsyncTask<Vote, Void, Boolean>{
		public Boolean doInBackground(Vote... votes){
			try{

				HttpGet request = new HttpGet(requestUrl + "votes");
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
