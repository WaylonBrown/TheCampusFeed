package com.appuccino.thecampusfeed;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.animation.AlphaAnimation;
import android.widget.LinearLayout;

import java.util.Timer;
import java.util.TimerTask;

public class SplashActivity extends Activity{

    public static final String URL_POST_ID = "url_post_id";
	private int SPLASH_MILLISECONDS = 400;
    private int openedPostID = -1;  //use if app opened from link
    MainActivity activity;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);

        final Intent intent = getIntent();
        final String action = intent.getAction();

        if (Intent.ACTION_VIEW.equals(action)) {
            Log.i("cfeed","Intent data: " + intent.getDataString());
            String[] dataList = intent.getDataString().split("/");
            if (dataList.length > 1) {
                try{
                    openedPostID = Integer.valueOf(dataList[dataList.length-1]);
                    Log.i("cfeed","OPENED FROM LINK: id of " + openedPostID);
                } catch (Exception e){
                    e.printStackTrace();
                }

            }
        }

        if(MainActivity.activity == null){
            LinearLayout layout = (LinearLayout) findViewById(R.id.splashLayout);
            AlphaAnimation animation = new AlphaAnimation(0.0f , 1.0f ) ;
            animation.setFillAfter(true);
            animation.setDuration(SPLASH_MILLISECONDS);
            //apply the animation ( fade In ) to your LAyout
            layout.startAnimation(animation);
            runTimer();
        } else {
            goToMainActivity();
        }
	}

	private void runTimer() {
		Timer timeout = new Timer();
    	timeout.schedule(new TimerTask()
    	{
			@Override
			public void run() 
			{						
				runOnUiThread(new Runnable(){
					@Override
					public void run() {
						goToMainActivity();
					}
				});
			}							
    	}, SPLASH_MILLISECONDS);
	}
	
	private void goToMainActivity(){
		Intent intent = new Intent(this, MainActivity.class);
        intent.putExtra(URL_POST_ID, openedPostID);
		startActivity(intent);
		overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);	
		finish();
	}
}
