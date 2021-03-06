package com.appuccino.thecampusfeed.utils;

import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import com.appuccino.thecampusfeed.CommentsActivity;
import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.TagListActivity;
import com.appuccino.thecampusfeed.dialogs.ChangeTimeCrunchCollegeDialog;
import com.appuccino.thecampusfeed.dialogs.ChooseFeedDialog;
import com.appuccino.thecampusfeed.dialogs.ForceRequiredUpdateDialog;
import com.appuccino.thecampusfeed.dialogs.NewPostDialog;
import com.appuccino.thecampusfeed.fragments.MostActiveCollegesFragment;
import com.appuccino.thecampusfeed.fragments.MyCommentsFragment;
import com.appuccino.thecampusfeed.fragments.MyPostsFragment;
import com.appuccino.thecampusfeed.fragments.NewPostFragment;
import com.appuccino.thecampusfeed.fragments.TagFragment;
import com.appuccino.thecampusfeed.fragments.TopPostFragment;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.objects.Comment;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.objects.Tag;
import com.appuccino.thecampusfeed.objects.Vote;

import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import java.net.URL;
import java.net.UnknownHostException;
import java.security.GeneralSecurityException;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

public class NetWorker {

     public final static String SERVER_URL = "https://thecampusfeed.com/api/";
     public final static String API_VERSION = "v1/";
     public final static String REQUEST_URL = SERVER_URL + API_VERSION;
     public final static String LOG_TAG = "NETWORK: ";


    public static class MySSLSocketFactory extends SSLSocketFactory {
        SSLContext sslContext = SSLContext.getInstance("TLS");

        public MySSLSocketFactory(KeyStore truststore) throws NoSuchAlgorithmException, KeyManagementException, KeyStoreException, UnrecoverableKeyException {
            super(truststore);

            TrustManager tm = new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                }

                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                }

                public X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
            };

            sslContext.init(null, new TrustManager[] { tm }, null);
        }

        @Override
        public Socket createSocket(Socket socket, String host, int port, boolean autoClose) throws IOException, UnknownHostException {
            return sslContext.getSocketFactory().createSocket(socket, host, port, autoClose);
        }

        @Override
        public Socket createSocket() throws IOException {
            return sslContext.getSocketFactory().createSocket();
        }
    }

     public static HttpClient client = getNewHttpClient();
     public static SSLSocketFactory sf = null;
     public static HttpClient getNewHttpClient() {
        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            trustStore.load(null, null);

            sf = new MySSLSocketFactory(trustStore);
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

            HttpParams params = new BasicHttpParams();
            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

            SchemeRegistry registry = new SchemeRegistry();
            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
            registry.register(new Scheme("https", sf, 443));

            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);

            return new DefaultHttpClient(ccm, params);
        } catch (Exception e) {
            return new DefaultHttpClient();
        }
     }

     public static class PostSelector{

     }

     public static class GetPostsTask extends AsyncTask<PostSelector, Void, ArrayList<Post> >
     {
         int whichFrag = 0;
         int feedID = 0;
         int pageNumber;
         boolean wasPullToRefresh;
         final int POSTS_PER_PAGE = 20;
         TopPostFragment frag1;
         NewPostFragment frag2;

         public GetPostsTask(int whichFrag, int feedID, int pageNumber, boolean wasPullToRefresh)
         {
             this.whichFrag = whichFrag;
             this.feedID = feedID;
             this.pageNumber = pageNumber;
             this.wasPullToRefresh = wasPullToRefresh;
         }

         public GetPostsTask(TopPostFragment frag, int whichFrag, int feedID, int pageNumber, boolean wasPullToRefresh)
         {
             this.frag1 = frag;
             this.whichFrag = whichFrag;
             this.feedID = feedID;
             this.pageNumber = pageNumber;
             this.wasPullToRefresh = wasPullToRefresh;
         }

         public GetPostsTask(NewPostFragment frag, int whichFrag, int feedID, int pageNumber, boolean wasPullToRefresh)
         {
             this.frag2 = frag;
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
             } catch (HttpResponseException e){
                 if(e.toString().toLowerCase().contains("server error"))
                 {
                     MainActivity.activity.runOnUiThread(new Runnable() {
                         public void run() {
                             Toast.makeText(MainActivity.activity, "Can't connect, please try again shortly", Toast.LENGTH_LONG).show();
                         }
                     });
                 }
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
             if(whichFrag == 0 && frag1 != null)		//top posts
             {
                 if(result != null && result.size() != 0){
                     for(Post p : result){
                         TopPostFragment.listAdapter.addIfNotAdded(p);
                     }
                 }else{
                     TopPostFragment.endOfListReached = true;
                     TopPostFragment.replaceFooterBecauseEndOfList();
                 }

                 //use these 2 test lines if you want to show the "pull down to load posts" test
                 /*
                 TopPostFragment.endOfListReached = true;
                 TopPostFragment.postList = new ArrayList<Post>();
                 */
                 frag1.updateList();
                 TopPostFragment.makeLoadingIndicator(false);
                 TopPostFragment.currentPageNumber++;
                 TopPostFragment.removeFooterSpinner();
             }
             else if (frag2 != null)	//new posts
             {
                 if(result != null && result.size() != 0){
                     for(Post p : result){
                         NewPostFragment.listAdapter.addIfNotAdded(p);
                     }
                 }else{
                     NewPostFragment.endOfListReached = true;
                     NewPostFragment.replaceFooterBecauseEndOfList();
                 }

                 frag2.updateList();
                 NewPostFragment.makeLoadingIndicator(false);
                 NewPostFragment.currentPageNumber++;
                 NewPostFragment.removeFooterSpinner();
             }
         }
     }
    

     public static class GetCommentsTask extends AsyncTask<PostSelector, Void, ArrayList<Comment>>
     {
         int postID = 0;
         CommentsActivity activity;

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
         int pageNumber;
         final int POSTS_PER_PAGE = 20;
         TagFragment frag;

         public GetTagFragmentTask()
         {
         }

         public GetTagFragmentTask(TagFragment frag, int feedID, int p)
         {
             this.frag = frag;
             this.feedID = feedID;
             pageNumber = p;
         }

         @Override
         protected void onPreExecute() {
             //dont need, not pull to refresh
             //TagFragment.makeLoadingIndicator(true);
             super.onPreExecute();
         }

         @Override
         protected ArrayList<Tag> doInBackground(PostSelector... arg0) {
             String paginationString = "?page=" + pageNumber + "&per_page=" + POSTS_PER_PAGE;
             HttpGet request = null;
             String requestString = "";
             if(feedID == MainActivity.ALL_COLLEGES)
                 requestString = REQUEST_URL + "tags/trending" + paginationString;
             else
                 requestString = REQUEST_URL + "colleges/" + String.valueOf(feedID) + "/tags/trending" + paginationString;

             request = new HttpGet(requestString);
             frag.currentPageNumber++;
             MyLog.i("Getting tags from " + requestString);
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
             if(result != null && result.size() != 0){
                 TagFragment.listAdapter.addAll(result);
             } else {
                 TagFragment.endOfListReached = true;
                 TagFragment.replaceFooterBecauseEndOfList();
             }

             frag.updateList();
             frag.makeLoadingIndicator(false);
             frag.removeFooterSpinner();
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
        MainActivity main;

        public GetFullCollegeListTask(String s, MainActivity main){
            checkSumVersion = s;
            this.main = main;
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
            Collections.sort(MainActivity.collegeList, new ListComparator());
            PrefManager.putCollegeListCheckSum(checkSumVersion);
            if(main.userLocation != null)
                main.determinePermissions(main.userLocation);
            Log.i("cfeed","COLLEGE_LIST Updated main college list.");
            ChooseFeedDialog.recalculateNearYouList(main);
            if(MainActivity.topPostFrag != null){
                MainActivity.topPostFrag.pullDownText.setText("An updated college list has been found, please reselect the feed you want to view by clicking Choose below");
                MainActivity.topPostFrag.updateList();
            } else if(MainActivity.newPostFrag != null){
                MainActivity.newPostFrag.pullDownText.setText("An updated college list has been found, please reselect the feed you want to view by clicking Choose below");
                MainActivity.newPostFrag.updateList();
            }
        }
    }

    public static class GetManyPostsTask extends AsyncTask<PostSelector, Void, ArrayList<Post> >
    {
        private List<Integer> postIDList;
        private MyPostsFragment frag;
        //only if loading a post from URL click
        private int urlPostID = -1;
        private CommentsActivity commentsActivity;

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

        //from clicking post from URL click
        public GetManyPostsTask(int id, CommentsActivity commentsActivity){
            postIDList = null;
            urlPostID = id;
            this.commentsActivity = commentsActivity;
        }

        @Override
        protected void onPreExecute() {
            if(frag != null){
                frag.makeLoadingIndicator(true);
            }else if(commentsActivity != null && urlPostID >= 0){
                commentsActivity.makeLoadingIndicator(true);
            }
            super.onPreExecute();
        }

        @Override
        protected ArrayList<Post> doInBackground(PostSelector... arg0) {
            String arrayQuery = "";
            if(urlPostID == -1 && (postIDList == null || postIDList.size() == 0)){
                return new ArrayList<Post>();
            } else {
                //post URL click
                if(urlPostID != -1){
                    arrayQuery = "many_ids[]=" + urlPostID;
                    HttpGet request = new HttpGet(REQUEST_URL + "posts/many?" + arrayQuery);
                    return getPostsFromURLRequest(request);
                } else {    //myPostsFragment load
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
            if(frag != null && urlPostID == -1){
                frag.updateList(result);
                frag.makeLoadingIndicator(false);
            } else if (urlPostID == -1){
                MyCommentsFragment.updateCommentParentList(result);
            } else if (result != null && result.size() > 0){
                commentsActivity.postLoadedFromURL(result.get(0));
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

         //temporary while images arent on the server but just client side yet
         Uri imageUri;

         public MakePostTask(Context context, MainActivity main) {
             c = context;
             this.main = main;
         }

         @Override
         protected Boolean doInBackground(Post... posts) {
             try{
                 //temporary while images arent on the server but just client side yet
                 imageUri = posts[0].getImageUri();
                 postCollegeID = posts[0].getCollegeID();
                 Log.i("cfeed",LOG_TAG + "Posting to feed with ID of " + posts[0].getCollegeID());
                 Log.i("cfeed",LOG_TAG + "Request URL: " + REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
                 HttpPost request = new HttpPost(REQUEST_URL + "colleges/" + posts[0].getCollegeID() + "/posts");
                 request.setHeader("Content-Type", "application/json");
                 request.setEntity(new ByteArrayEntity(posts[0].toJSONString().toByteArray()));

                 HttpResponse httpResponse = client.execute(request);
                 java.util.Scanner s = new java.util.Scanner(httpResponse.getEntity().getContent()).useDelimiter("\\A");
                 response = s.hasNext() ? s.next() : "";
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
                 MyLog.i("RESETASDFASFD: " + response);
                 Post responsePost = parseResponseIntoPostAndAdd(response);
                 addTimeCrunchTime(responsePost);
             }
             super.onPostExecute(result);
         }

         //only add time crunch time if posting to your college, otherwise tell user it wasn't added and ask to change
         private void addTimeCrunchTime(Post post) {
             //set home college if not set or if theres no hours
             if(PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1) < 0 || PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0) == 0){
                 PrefManager.putInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, post.getCollegeID());
             }

             MyLog.i("time crunch home college: " + PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1) + " post college: " + post.getCollegeID());
             //if posting to the college that you already have time crunch hours for
             if (PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1) == post.getCollegeID()) {
                 Toast.makeText(c, MainActivity.TIME_CRUNCH_POST_TIME + " hours added to your Time Crunch", Toast.LENGTH_LONG).show();
                 //add time to the time crunch
                 //if time crunch is active, add to backup hours instead of normal hours
                 if(PrefManager.getBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false)){
                     PrefManager.putInt(PrefManager.TIME_CRUNCH_BACKUP_HOURS, PrefManager.getInt(PrefManager.TIME_CRUNCH_BACKUP_HOURS, 0) + MainActivity.TIME_CRUNCH_POST_TIME);
                 } else {    //add like normal
                     PrefManager.putInt(PrefManager.TIME_CRUNCH_HOURS, PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0) + MainActivity.TIME_CRUNCH_POST_TIME);
                 }
             } else if (PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0) > 0){   //if posting to a college that you don't have time crunch hours for, and there are time crunch hours
                 new ChangeTimeCrunchCollegeDialog(main, post.getCollegeID());
             }
         }

         private Post parseResponseIntoPostAndAdd(String response) {
             Post responsePost = null;
             try {
                 Log.i("cfeed","NETWORK: Successful post response, adding to list");
                 responsePost = JSONParser.postFromJSON(response);
                 responsePost.setCollegeID(postCollegeID);
                 //temporary while images arent on the server but just client side yet
                 responsePost.setImageUri(imageUri);
                 if(MainActivity.getCollegeByID(postCollegeID) != null){
                     responsePost.setCollegeName(MainActivity.getCollegeByID(postCollegeID).getName());
                 }
                 MainActivity.postVoteList.add(new Vote(responsePost.defaultVoteID, responsePost.getID(), true));
                 PrefManager.putPostVoteList(MainActivity.postVoteList);
                 main.addNewPostToListAndMyContent(responsePost, c);
             } catch (Exception e) {
                 Log.i("cfeed","ERROR: post not added");
                 e.printStackTrace();
             }

             return responsePost;
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
                     MainActivity.commentVoteList.add(new Vote(responseComment.defaultVoteID, responseComment.getPostID(), responseComment.getID(), true));
                     PrefManager.putCommentVoteList(MainActivity.commentVoteList);
                     MainActivity.myCommentsList.add(id);
                     PrefManager.putMyCommentsList(MainActivity.myCommentsList);
                     //instantly add to new comments
                     CommentsActivity.commentList.add(responseComment);
                     CommentsActivity.updateList();
                     CommentsActivity.scrollToCommentsBottom();

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
                MainActivity.postVoteList.add(votes[0]);
                PrefManager.putPostVoteList(MainActivity.postVoteList);

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
                MainActivity.setPostVoteID(returnedVote.id, returnedVote.postID);
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
                MainActivity.commentVoteList.add(votes[0]);
                PrefManager.putCommentVoteList(MainActivity.commentVoteList);

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
                MainActivity.setCommentVoteID(returnedVote.id, returnedVote.commentID);
                PrefManager.putCommentVoteList(MainActivity.commentVoteList);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static class MakePostVoteDeleteTask extends AsyncTask<Vote, Void, Boolean>{
        Vote vote;
        Context c;
        int voteID;

        public MakePostVoteDeleteTask(Context c, int voteID, int postID){
            this.c = c;
            this.voteID = voteID;
            MainActivity.removePostVoteByPostID(postID);
            PrefManager.putPostVoteList(MainActivity.postVoteList);
        }

        public Boolean doInBackground(Vote... votes){
            try{
                Log.i("cfeed","Vote delete URL: " + REQUEST_URL + "votes/" + voteID);
                HttpDelete request = new HttpDelete(REQUEST_URL + "votes/" + voteID);
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                String response = client.execute(request, responseHandler);

                Log.d("cfeed", LOG_TAG + "Make vote delete server response: " + response);
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
                Log.e("cfeed", "Vote delete didn't work.");
            }
        }
    }

    public static class MakeCommentVoteDeleteTask extends AsyncTask<Vote, Void, Boolean>{
        Vote vote;
        Context c;
        int voteID;

        public MakeCommentVoteDeleteTask(Context c, int voteID, int commentID){
            this.c = c;
            this.voteID = voteID;
            MainActivity.removeCommentVoteByCommentID(commentID);
            PrefManager.putCommentVoteList(MainActivity.commentVoteList);
        }

        public Boolean doInBackground(Vote... votes){
            try{
                HttpDelete request = new HttpDelete(REQUEST_URL + "votes/" + voteID);
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                String response = client.execute(request, responseHandler);

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
                Log.e("cfeed", "Vote delete didn't work.");
            }
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

    public static class CheckForceRequiredUpdated extends AsyncTask<Void, Void, Boolean>{

        String response;
        double currentVersion;
        MainActivity activity;

        public CheckForceRequiredUpdated(String currentVersion, MainActivity activity){
            try{
                this.currentVersion = Double.valueOf(currentVersion);
            }catch(Exception e){
                e.printStackTrace();
            }
            this.activity = activity;
        }

        @Override
        public Boolean doInBackground(Void... vd){
            try{
                HttpGet request = new HttpGet(REQUEST_URL + "minAndroidVersion");
                ResponseHandler<String> responseHandler = new BasicResponseHandler();
                response = client.execute(request, responseHandler);

                Log.d("cfeed", LOG_TAG + "App version server response: " + response);
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
            if(result && response != null){
                Double forceUpdateVersion = null;
                try {
                    String versionString = JSONParser.appVersionFromJSON(response);
                    MyLog.i("Version string from server is " + versionString);
                    forceUpdateVersion = Double.valueOf(versionString);
                    if(forceUpdateVersion > currentVersion){
                        MyLog.i("Forcing required update");
                        new ForceRequiredUpdateDialog(activity);
                    } else {
                        MyLog.i("No force update required");
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            super.onPostExecute(result);
        }
    }

    public static class UploadImageTask extends AsyncTask<Bitmap, Void, Boolean>{

        Context c;
        String response = null;
        MainActivity main;
        File myPath;
        int imageID;
        Uri imageUri;
        NewPostDialog dialog;
        ProgressDialog uploadDialog;

        public UploadImageTask(Context context, MainActivity main, NewPostDialog dialog, ProgressDialog uploadDialog, File mypath) {
            c = context;
            this.main = main;
            myPath = mypath;
            this.dialog = dialog;
            this.uploadDialog = uploadDialog;
        }

        @Override
        protected Boolean doInBackground(Bitmap... bitmaps) {

            HttpsURLConnection connection = null;
            DataOutputStream outputStream = null;
            String pathToOurFile = myPath.getAbsolutePath();
            String urlServer = REQUEST_URL + "/images";
            String lineEnd = "\r\n";
            String twoHyphens = "--";
            String boundary =  "*****";

            int bytesRead, bytesAvailable, bufferSize;
            byte[] buffer;
            int maxBufferSize = 1*1024*1024;

            try
            {
                FileInputStream fileInputStream = new FileInputStream(new File(pathToOurFile) );

                URL url = new URL(urlServer);
                connection = (HttpsURLConnection) url.openConnection();

                KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
                trustStore.load(null, null);
                TrustManagerFactory tmf =
                        TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
                tmf.init(trustStore);
                SSLContext ctx = SSLContext.getInstance("TLS");


                //THIS PART ACCEPTS ALL CERTIFICATES, FIX THIS LATER
                // Create a trust manager that does not validate certificate chains
                TrustManager[] trustAllCerts = new TrustManager[] {
                        new X509TrustManager() {
                            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                                return new X509Certificate[0];
                            }
                            public void checkClientTrusted(
                                    java.security.cert.X509Certificate[] certs, String authType) {
                            }
                            public void checkServerTrusted(
                                    java.security.cert.X509Certificate[] certs, String authType) {
                            }
                        }
                };
                // Install the all-trusting trust manager
                SSLContext sc = null;
                try {
                    sc = SSLContext.getInstance("SSL");
                    sc.init(null, trustAllCerts, new java.security.SecureRandom());
                    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
                } catch (GeneralSecurityException e) {
                }
                connection.setSSLSocketFactory(sc.getSocketFactory());

                // Allow Inputs &amp; Outputs.
                connection.setDoInput(true);
                connection.setDoOutput(true);
                connection.setUseCaches(false);

                // Set HTTP method to POST.
                connection.setRequestMethod("POST");

                connection.setRequestProperty("Connection", "Keep-Alive");
                connection.setRequestProperty("Content-Type", "multipart/form-data;boundary="+boundary);

                outputStream = new DataOutputStream( connection.getOutputStream() );
                outputStream.writeBytes(twoHyphens + boundary + lineEnd);
                outputStream.writeBytes("Content-Disposition: form-data; name=\"image[upload]\";filename=\"" + pathToOurFile +"\"" + lineEnd);
                outputStream.writeBytes(lineEnd);

                bytesAvailable = fileInputStream.available();
                bufferSize = Math.min(bytesAvailable, maxBufferSize);
                buffer = new byte[bufferSize];

                // Read file
                bytesRead = fileInputStream.read(buffer, 0, bufferSize);

                int initialBytesToRead = bytesRead;
                while (bytesRead > 0)
                {
                    outputStream.write(buffer, 0, bufferSize);
                    bytesAvailable = fileInputStream.available();
                    bufferSize = Math.min(bytesAvailable, maxBufferSize);
                    bytesRead = fileInputStream.read(buffer, 0, bufferSize);
                }

                outputStream.writeBytes(lineEnd);
                outputStream.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);

                // Responses from the server (code and message)
                int serverResponseCode = connection.getResponseCode();
                uploadDialog.setProgress(41);
                String serverResponseMessage = connection.getResponseMessage();
                uploadDialog.setProgress(60);
                InputStream str = (InputStream)(connection.getContent());
                uploadDialog.setProgress(80);

                Scanner scan = new Scanner(str);
                String responseBody = scan.nextLine();
                uploadDialog.setProgress(100);

                MyLog.d("Server response code: " + serverResponseCode);
                MyLog.d("Server response message: " + serverResponseMessage);
                MyLog.d("Server response body: " + responseBody);

                fileInputStream.close();
                outputStream.flush();
                outputStream.close();
                uploadDialog.setProgress(100);

                String[] responseSplit = responseBody.split(",");
                imageID = Integer.valueOf(responseSplit[0]);
                imageUri = Uri.parse(responseSplit[1]);
            }
            catch (Exception ex)
            {
                ex.printStackTrace();
                return false;
            }

            return true;
        }

        @Override
        protected void onPostExecute(Boolean result) {
            if(!result) {
                Toast.makeText(c, "Failed to upload image, please try again and make sure you are connected to the internet.", Toast.LENGTH_LONG).show();
                dialog.imageLoadingFromNetworkFailed();
            } else {
                dialog.imageUploaded(imageID, imageUri);
            }
            super.onPostExecute(result);
        }
    }
 }
