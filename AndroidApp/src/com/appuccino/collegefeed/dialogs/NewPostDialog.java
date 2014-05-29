package com.appuccino.collegefeed.dialogs;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.extra.NetWorker.MakePostTask;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.managers.FontManager;
import com.appuccino.collegefeed.objects.Post;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class NewPostDialog extends AlertDialog.Builder{
	
	Context context;
	
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
		
		final AlertDialog dialog = create();
		dialog.show();
		
		final EditText postMessage = (EditText)layout.findViewById(R.id.newPostMessage);
		Button postButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
    	postButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{				
    			if(postMessage.getText().toString().length() >= MainActivity.MIN_POST_LENGTH)
    			{
    				Post newPost = new Post(postMessage.getText().toString());
        			NewPostFragment.postList.add(newPost);
        			TopPostFragment.postList.add(newPost);
        			NewPostFragment.updateList();
        			TopPostFragment.updateList();
        			new MakePostTask().execute(newPost);
        			dialog.dismiss();
    			}
    			else
    			{
    				Toast.makeText(context, "Post must be at least 10 characters long.", Toast.LENGTH_LONG).show();
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
					//tagsText.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, 0));
					//tagsText.setHeight(0);
				}					
				else if(!currentTags.equals("Tags: <font color='#33B5E5'></font>") && !tagsText.isShown())
				{
					tagsText.setVisibility(View.VISIBLE);
//					//tagsText.setLayoutParams(new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.WRAP_CONTENT));
//					Resources r = getApplicationContext().getResources();
//					Toast.makeText(getApplicationContext(), Math.round(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 100, r.getDisplayMetrics())), Toast.LENGTH_LONG).show();
//					tagsText.setHeight(100);
				}
					
				tagsText.setText(Html.fromHtml((currentTags)));
			}
    		
    	});
	}
}
