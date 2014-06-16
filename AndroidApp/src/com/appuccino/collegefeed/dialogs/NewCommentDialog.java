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
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.MakePostTask;

public class NewCommentDialog extends AlertDialog.Builder{
	Context context;
	Post parentPost;
	
	public NewCommentDialog(final Context context, View layout, Post post) {
		super(context);
		this.context = context;
		parentPost = post;
		setCancelable(true);
		setView(layout).setPositiveButton("Comment", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing here since overridden to be able to click button and not dismiss dialog
            }
        });
		
		if(MainActivity.permissions != null && MainActivity.hasPermissions(parentPost.getCollegeID()))
		{
			createDialog(layout);
		}
		
	}

	private void createDialog(View layout) {
		final AlertDialog dialog = create();
		dialog.show();
		
		final EditText messageEditText = (EditText)layout.findViewById(R.id.newPostMessage);
		Button postButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
    	postButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{				
    			if(messageEditText.getText().toString().length() >= MainActivity.MIN_COMMENT_LENGTH)
    			{
    				Comment newComment = new Comment(messageEditText.getText().toString(), parentPost.getID());
    				//TODO: do this
    				//instantly add to new comments
    				//NewPostFragment.postList.add(newPost);
            		//NewPostFragment.updateList();
        			new MakeCommentTask(context).execute(newPost);
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

LayoutInflater inflater = getLayoutInflater();
View postDialogLayout = inflater.inflate(R.layout.dialog_comment, null);
final EditText commentMessage = (EditText)postDialogLayout.findViewById(R.id.newCommentMessage);

AlertDialog.Builder builder = new AlertDialog.Builder(this);
builder.setCancelable(true);
builder.setView(postDialogLayout)
.setPositiveButton("Comment", new DialogInterface.OnClickListener()
{
    @Override
    public void onClick(DialogInterface dialog, int which)
    {
        //do nothing here since overridden below to be able to click button and not dismiss dialog
    }
});
    	
final AlertDialog dialog = builder.create();
dialog.show();

Button postButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
postButton.setOnClickListener(new View.OnClickListener()
{
	@Override
	public void onClick(View v) 
	{				
		if(commentMessage.getText().toString().length() >= minCommentLength)
		{
			Comment newComment = new Comment(commentMessage.getText().toString(), post.getID());
			post.addComment(newComment);
			//new MakePostTask().execute(newPost);
			updateList();
			dialog.dismiss();
		}
		else
		{
			Toast.makeText(getApplicationContext(), "Post must be at least 3 characters long.", Toast.LENGTH_LONG).show();
		}
	}
});

TextView title = (TextView)postDialogLayout.findViewById(R.id.newCommentTitle);
commentMessage.setTypeface(FontManager.light);
title.setTypeface(FontManager.light);
postButton.setTypeface(FontManager.light);

//ensure keyboard is brought up when dialog shows
commentMessage.setOnFocusChangeListener(new View.OnFocusChangeListener() {
    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (hasFocus) {
            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        }
    }
});

final TextView tagsText = (TextView)postDialogLayout.findViewById(R.id.newCommentTagsText);
tagsText.setTypeface(FontManager.light);

//set listener for tags
commentMessage.addTextChangedListener(new TextWatcher(){

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
		String message = commentMessage.getText().toString();
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