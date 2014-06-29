package com.appuccino.collegefeed.dialogs;

import java.util.ArrayList;
import java.util.List;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.MakePostTask;

public class NewPostDialog extends AlertDialog.Builder{
	
	Context context;
	private int selectedCollegeID = -1;
	
	public NewPostDialog(final Context context, View layout) {
		super(context);
		this.context = context;
		setCancelable(true);
		setView(layout).setPositiveButton("Post", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing here since overridden to be able to click button and not dismiss dialog
            }
        });
		
		if(MainActivity.permissions != null)
		{
			if(MainActivity.permissions.size() == 1)
			{
				selectedCollegeID = MainActivity.permissions.get(0);
				Log.i("cfeed","SelctedCollegeID: " + selectedCollegeID);
				createDialog(layout);
			}
			else	//in range of multiple colleges
			{
				createCollegeChooser(layout);
			}
		}
		
	}

	private void createCollegeChooser(final View layout) {
		List<String> stringPermissionsList = new ArrayList<String>();
		for(int collegeID : MainActivity.permissions){
			stringPermissionsList.add(MainActivity.getCollegeByID(collegeID).getName());
		}
		final CharSequence[] items = stringPermissionsList.toArray(new CharSequence[stringPermissionsList.size()]);

	    AlertDialog.Builder builder = new AlertDialog.Builder(context);
	    
	    final TextView title = new TextView(context);
	    title.setText("Post to...");
	    title.setTextSize(30);
	    title.setTextColor(context.getResources().getColor(R.color.lightblue));
	    title.setTypeface(FontManager.light);
	    title.setPadding(28, 20, 12, 20);
	    builder.setCustomTitle(title);
	    builder.setItems(items, new DialogInterface.OnClickListener() {
	        public void onClick(DialogInterface dialog, int item) {
	        	selectedCollegeID = MainActivity.permissions.get(item);
	        	createDialog(layout);
	        }
	    }).show();
	}

	private void createDialog(View layout) {
		final AlertDialog dialog = create();
		dialog.show();
		
		final EditText postMessage = (EditText)layout.findViewById(R.id.newPostMessage);
		Button postButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
    	postButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{				
    			String thisString = postMessage.getText().toString().trim();
    			if(thisString.length() >= MainActivity.MIN_POST_LENGTH)
    			{
    				Post newPost = new Post(thisString, selectedCollegeID);
    				//instantly add to new posts
    				if(MainActivity.currentFeedCollegeID == MainActivity.ALL_COLLEGES || MainActivity.currentFeedCollegeID == selectedCollegeID){
    					NewPostFragment.postList.add(newPost);
            			NewPostFragment.updateList();
    				}
        			new MakePostTask(context).execute(newPost);
        			dialog.dismiss();
    			}
    			else
    			{
    				Toast.makeText(context, "Post must be at least " + MainActivity.MIN_POST_LENGTH + " characters long.", Toast.LENGTH_LONG).show();
    			}
			}
    	});
    	
    	TextView title = (TextView)layout.findViewById(R.id.newPostTitle);
    	TextView college = (TextView)layout.findViewById(R.id.collegeText);
    	postMessage.setTypeface(FontManager.light);
    	college.setTypeface(FontManager.italic);
    	title.setTypeface(FontManager.light);
    	postButton.setTypeface(FontManager.light);
    	
    	//ensure keyboard is brought up when dialog shows
    	postMessage.setOnFocusChangeListener(new View.OnFocusChangeListener() {
    	    @Override
    	    public void onFocusChange(View v, boolean hasFocus) {
    	        if (hasFocus) {
    	            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    	        }
    	    }
    	});
   
    	final TextView tagsText = (TextView)layout.findViewById(R.id.newPostTagsText);
    	tagsText.setTypeface(FontManager.light);
    	
    	//set listener for tags
    	postMessage.addTextChangedListener(new TextWatcher(){

			@Override
			public void afterTextChanged(Editable s) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				String message = postMessage.getText().toString();
				String currentTags = "Tags: <font color='#33B5E5'>";
				
				String[] wordArray = message.split(" ");
				if(wordArray.length > 0)
				{
					for(int i = 0; i < wordArray.length; i++)
					{
						//prevent indexoutofboundsexception
						if(wordArray[i].length() > 0)
						{
							if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
							{
								currentTags += wordArray[i] + " ";
							}
						}
					}
				}
				
				currentTags += "</font>";
				//if there aren't any tags and view is shown, remove view
				if(currentTags.equals("Tags: <font color='#33B5E5'></font>") && tagsText.isShown())
				{
					tagsText.setVisibility(View.GONE);
				}					
				else if(!currentTags.equals("Tags: <font color='#33B5E5'></font>") && !tagsText.isShown())
				{
					tagsText.setVisibility(View.VISIBLE);
				}
					
				tagsText.setText(Html.fromHtml((currentTags)));
			}
    		
    	});
    	
    	setupCollege(college);
	}

	private void setupCollege(TextView college) {
		String collegeString = "Posting to ";
		if(MainActivity.permissions != null)
		{
			collegeString += MainActivity.getCollegeByID(selectedCollegeID).getName();
			college.setText(collegeString);
		}
	}
}
