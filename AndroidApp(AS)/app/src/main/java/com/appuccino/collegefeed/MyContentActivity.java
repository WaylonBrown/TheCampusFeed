package com.appuccino.collegefeed;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.appuccino.collegefeed.utils.FontManager;

/**
 * Created by Waylon on 7/6/2014.
 */
public class MyContentActivity extends Activity{

    ListView myPostsListView;
    ListView myCommentsListView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_content);
        setupActionbar();
        setupViews();
        fetchLists();
        //TODO: remove this
    }

    private void fetchLists() {
        //TODO: fetch from server here
    }



    private void setupActionbar() {
        ActionBar actionBar = getActionBar();
        actionBar.setCustomView(R.layout.actionbar_main);
        actionBar.setDisplayShowTitleEnabled(false);
        actionBar.setDisplayShowCustomEnabled(true);
        actionBar.setDisplayUseLogoEnabled(false);
        actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
        actionBar.setIcon(R.drawable.logofake);

        ImageView postButton = (ImageView)findViewById(R.id.newPostButton);
        postButton.setVisibility(View.GONE);
    }

    private void setupViews() {
        TextView myPostsText = (TextView)findViewById(R.id.myPostsTextView);
        TextView myCommentsText = (TextView)findViewById(R.id.myCommentsTextView);
        //ListView myPostsListView = (ListView)findViewById()

        myPostsText.setTypeface(FontManager.light);
        myCommentsText.setTypeface(FontManager.light);
    }
}
