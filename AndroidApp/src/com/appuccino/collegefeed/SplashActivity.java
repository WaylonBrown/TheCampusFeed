package com.appuccino.collegefeed;

import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class SplashActivity extends Activity{
	
	private int SPLASH_MILLISECONDS = 1000;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
		setContentView(R.layout.activity_splash);
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
		intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION );
		startActivity(intent);
		finish();
		overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);	
	}
}
