package com.appuccino.collegefeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.CommentsActivity;
import com.appuccino.collegefeed.MainActivity;
import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.utils.FontManager;
import com.appuccino.collegefeed.utils.NetWorker.MakeCommentTask;
import com.appuccino.collegefeed.utils.TimeManager;

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
		
		final EditText messageEditText = (EditText)layout.findViewById(R.id.newCommentMessage);
		Button commentButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
		commentButton.setOnClickListener(new View.OnClickListener()
    	{
    		@Override
			public void onClick(View v) 
    		{				
    			String thisString = messageEditText.getText().toString().trim();
    			if(thisString.length() >= MainActivity.MIN_COMMENT_LENGTH)
    			{
    				Comment newComment = new Comment(thisString, 0, parentPost.getID(), 1, parentPost.getCollegeID(), TimeManager.now());
    				//instantly add to new comments
    				CommentsActivity.commentList.add(newComment);
    				CommentsActivity.updateList();
        			new MakeCommentTask(context).execute(newComment);
        			dialog.dismiss();
    			}
    			else
    			{
    				Toast.makeText(context, "Comment must be at least " + MainActivity.MIN_COMMENT_LENGTH + " characters long.", Toast.LENGTH_LONG).show();
    			}
			}
    	});
    	
    	TextView title = (TextView)layout.findViewById(R.id.newCommentTitle);
    	messageEditText.setTypeface(FontManager.light);
    	title.setTypeface(FontManager.light);
    	commentButton.setTypeface(FontManager.light);
    	
    	//ensure keyboard is brought up when dialog shows
    	messageEditText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
    	    @Override
    	    public void onFocusChange(View v, boolean hasFocus) {
    	        if (hasFocus) {
    	            dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    	        }
    	    }
    	});
   
    	final TextView tagsText = (TextView)layout.findViewById(R.id.newCommentTagsText);
    	tagsText.setTypeface(FontManager.light);
    	
    	//set listener for tags
    	messageEditText.addTextChangedListener(new TextWatcher(){

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
				String message = messageEditText.getText().toString();
				String currentTags = "Tags: <font color='#33B5E5'>";
				
				String[] wordArray = message.split(" ");
				if(wordArray.length > 0)
				{
					for(int i = 0; i < wordArray.length; i++)
					{
						//prevent indexoutofboundsexception
						if(wordArray[i].length() > 0)
						{
							if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1 && !containsSymbols(wordArray[i]))
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
	}

    private boolean containsSymbols(String text) {
        if(text.contains("!") ||
                text.contains("$") ||
                text.contains("%") ||
                text.contains("^") ||
                text.contains("&") ||
                text.contains("*") ||
                text.contains("+") ||
                text.contains(".")){
            return true;
        }
        return false;
    }
}