package com.appuccino.thecampusfeed.dialogs;

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

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.NetWorker.MakePostTask;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NewPostDialog extends AlertDialog.Builder{
	
	Context context;
	private int selectedCollegeID = -1;
    MainActivity main;
    AlertDialog dialog;
	
	public NewPostDialog(final Context context, MainActivity main, View layout) {
		super(context);
		this.context = context;
        this.main = main;
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
        dialog = create();
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
                    new MakePostTask(context, main).execute(newPost);
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

                String[] tagArray = parseTagsWithRegex(message);
                if(tagArray.length > 0)
                {
                    for(int i = 0; i < tagArray.length; i++)
                    {
                        //prevent indexoutofboundsexception
                        if(tagArray[i].length() > 0)
                        {
                            currentTags += tagArray[i] + " ";
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

    private String[] parseTagsWithRegex(String message) {
        List<String> returnList = new ArrayList<String>();
        Matcher m = Pattern.compile("#[A-Za-z0-9_]{3,139}").matcher(message);
        while (m.find()){
            returnList.add(m.group());
        }

        return returnList.toArray(new String[returnList.size()]);
    }

    public boolean isShowing(){
        if(dialog == null)
            return false;
        else
            return dialog.isShowing();
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
