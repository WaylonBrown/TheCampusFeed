package com.appuccino.postfeed.objects;

import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

import android.os.AsyncTask;
import android.util.Log;

public class NetWorker {
	
	public static String serverUrl = "http://vm-0.bowmessage.kd.io:3000/";
	
	public static class VoteTask extends AsyncTask<Vote, Void, Boolean>{
		public Boolean doInBackground(Vote... votes){
			try{
				
				//int TIMEOUT_MILLISEC = 10000;  // = 10 seconds
				//HttpParams httpParams = new BasicHttpParams();
				//HttpConnectionParams.setConnectionTimeout(httpParams, TIMEOUT_MILLISEC);
				//HttpConnectionParams.setSoTimeout(httpParams, TIMEOUT_MILLISEC);
				HttpClient client = new DefaultHttpClient();

				HttpGet request = new HttpGet(serverUrl);
				//request.setEntity(new ByteArrayEntity(
				  //  votes[0].toString().getBytes("UTF8")));
				ResponseHandler<String> responseHandler = new BasicResponseHandler();
				String response = client.execute(request, responseHandler);
				
				Log.d("http", response);
				return true;
			} catch(IOException e){
				return false;
			}
		}
		
		public void onPostExecute(Boolean result){
			Log.d("http", "success: " + result);
		}
	}
}
