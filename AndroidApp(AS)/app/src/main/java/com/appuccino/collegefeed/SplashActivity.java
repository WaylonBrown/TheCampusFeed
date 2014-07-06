package com.appuccino.collegefeed;

import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.animation.AlphaAnimation;
import android.widget.LinearLayout;

public class SplashActivity extends Activity{
	
	private int SPLASH_MILLISECONDS = 500;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);
		LinearLayout layout = (LinearLayout) findViewById(R.id.splashLayout);
		AlphaAnimation animation = new AlphaAnimation(0.0f , 1.0f ) ;
		animation.setFillAfter(true);
		animation.setDuration(SPLASH_MILLISECONDS);
		//apply the animation ( fade In ) to your LAyout
		layout.startAnimation(animation);
		runTimer();
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
		startActivity(intent);
		overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);	
		finish();
	}
}
