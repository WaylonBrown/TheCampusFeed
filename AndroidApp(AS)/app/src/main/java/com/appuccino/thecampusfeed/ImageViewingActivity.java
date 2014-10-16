package com.appuccino.thecampusfeed;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;

import com.squareup.picasso.Picasso;

public class ImageViewingActivity extends Activity{

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_ACTION_BAR);
		setContentView(R.layout.activity_imageviewing);
		setupActionBar();
		setImage();
	}

    private void setImage() {
        ImageView image = (ImageView)findViewById(R.id.fullScreenImage);

        Uri imageUri = Uri.parse(getIntent().getStringExtra("imageURI"));
        Picasso.with(this).load(imageUri).into(image);
    }

    private void setupActionBar() {
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_tag_layout);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
        actionBar.setDisplayShowHomeEnabled(false);

        ImageView backButton = (ImageView)findViewById(R.id.backButtonTag);
        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
	}
}
