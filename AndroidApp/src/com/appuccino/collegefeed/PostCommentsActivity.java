package com.appuccino.collegefeed;

import java.util.Collections;
import java.util.Comparator;

import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.collegefeed.R;
import com.appuccino.collegefeed.adapters.CommentListAdapter;
import com.appuccino.collegefeed.extra.FontManager;
import com.appuccino.collegefeed.extra.NetWorker;
import com.appuccino.collegefeed.extra.NetWorker.MakePostTask;
import com.appuccino.collegefeed.extra.NetWorker.MakeVoteTask;
import com.appuccino.collegefeed.fragments.MyPostsFragment;
import com.appuccino.collegefeed.fragments.NewPostFragment;
import com.appuccino.collegefeed.fragments.TopPostFragment;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Vote;

public class PostCommentsActivity extends Activity{

	static CommentListAdapter listAdapter;
	Post post;
	ImageView newCommentButton;
	final int minCommentLength = 3;
	ListView commentsList;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_comment);
		// Set up the action bar.
		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_comment);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayUseLogoEnabled(false);
		actionBar.setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.blue)));
		actionBar.setIcon(R.drawable.logofake);
		newCommentButton = (ImageView)findViewById(R.id.newCommentButton);
		commentsList = (ListView)findViewById(R.id.commentsList);
		
		int collegeID = getIntent().getIntExtra("COLLEGE_ID", 0);
		int sectionNumber = getIntent().getIntExtra("SECTION_NUMBER", 0);
		
		if(MainActivity.hasPermissions(collegeID))
			newCommentButton.setVisibility(View.VISIBLE);
		else
			newCommentButton.setVisibility(View.GONE);
		
		if(sectionNumber == 0)
			post = TopPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		else if(sectionNumber == 1)
			post = NewPostFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		else if(sectionNumber == 2)
			post = MyPostsFragment.getPostByID(getIntent().getIntExtra("POST_ID", -1), sectionNumber);
		
        //set fonts
		final TextView scoreText = (TextView)findViewById(R.id.scoreText);
		TextView messageText = (TextView)findViewById(R.id.messageText);
		TextView timeText = (TextView)findViewById(R.id.timeText);
		TextView commentsText = (TextView)findViewById(R.id.commentsText);
		scoreText.setTypeface(FontManager.bold);
		messageText.setTypeface(FontManager.light);
		timeText.setTypeface(FontManager.italic);
		commentsText.setTypeface(FontManager.light);
		
		ListView commentsListView = (ListView)findViewById(R.id.commentsList);
		if(post != null)
		{
			scoreText.setText(String.valueOf(post.getScore()));
			timeText.setText(String.valueOf(post.getHoursAgo()) + " hours ago");
			
			//change text if no comments from post
			if(post.getCommentList().size() == 0)
				commentsText.setText("No Comments");
				
			sortCommentsList(post);
			listAdapter = new CommentListAdapter(this, R.layout.list_row_post, post.getCommentList());
			
			//if doesnt havefooter, add it
			if(commentsListView.getFooterViewsCount() == 0)
			{
				//for card UI
				View headerFooter = new View(this);
				headerFooter.setLayoutParams(new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 8));
				commentsListView.addFooterView(headerFooter, null, false);
			}
			commentsListView.setAdapter(listAdapter);
			
			setMessageAndColorizeTags(post.getMessage(), messageText);
			final ImageView arrowUp = (ImageView)findViewById(R.id.arrowUp);
			final ImageView arrowDown = (ImageView)findViewById(R.id.arrowDown);
	        //arrow click listeners
	        arrowUp.setOnClickListener(new OnClickListener(){

				@Override
				public void onClick(View v) {
					//if already upvoted, un-upvote
					if(post.getVote() == -1)
					{
						post.setVote(1);
						post.score += 2;
						scoreText.setText(String.valueOf(post.score));
					}
					else if(post.getVote() == 0)
					{
						post.setVote(1);
						post.score++;
						scoreText.setText(String.valueOf(post.score));
					}
					else 
					{
						post.setVote(0);
						post.score--;
						scoreText.setText(String.valueOf(post.score));
					}
					TopPostFragment.updateList();
					NewPostFragment.updateList();
					TagListActivity.updateList();
					updateArrows(arrowUp, arrowDown);
					new MakeVoteTask().execute(new Vote(post.getID(), true));
				}        	
	        });
	        arrowDown.setOnClickListener(new OnClickListener(){

				@Override
				public void onClick(View v) 
				{					
					if(MainActivity.hasPermissions(post.getCollegeID()))
					{
						//if already downvoted, un-downvote
						if(post.getVote() == -1)
						{
							post.setVote(0);
							post.score++;
							scoreText.setText(String.valueOf(post.score));
						}
						else if(post.getVote() == 0)
						{
							post.setVote(-1);
							post.score--;
							scoreText.setText(String.valueOf(post.score));
						}
						else 
						{
							post.setVote(-1);
							post.score -= 2;
							scoreText.setText(String.valueOf(post.score));
						}
						TopPostFragment.updateList();
						NewPostFragment.updateList();
						TagListActivity.updateList();
						updateArrows(arrowUp, arrowDown);
					}
					else
					{
						Toast.makeText(getApplicationContext(), "You need to be near the college to downvote", Toast.LENGTH_LONG).show();
					}
				}        	
	        });
	        
	        //I know it's redundent to check permissions this many times, but no one fcking post to the wrong college!
	        if(MainActivity.hasPermissions(collegeID))
				newCommentButton.setOnClickListener(new OnClickListener(){

					@Override
					public void onClick(View v) 
					{					
						if(MainActivity.hasPermissions(post.getCollegeID()))
						{
							newCommentDialog();
						}
					}        	
		        });
	        
	        updateArrows(arrowUp, arrowDown);
		}
	}
	
	protected void newCommentDialog() 
	{
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
	}

	private void sortCommentsList(Post post) 
	{
		Collections.sort(post.getCommentList(), new Comparator<Comment>()
		{
			@Override
			public int compare(Comment lhs, Comment rhs) 
			{
				if(lhs.getScore() > rhs.getScore())
					return -1;
				else if(lhs.getScore() == rhs.getScore())
					return 0;
				else
					return 1;
			}
		});
	}

	protected void updateArrows(ImageView arrowUp, ImageView arrowDown) 
	{
		int vote = post.getVote();
        if(vote == -1)
        {
        	arrowDown.setImageDrawable(getResources().getDrawable(R.drawable.arrowdownred));
        	arrowUp.setImageDrawable(getResources().getDrawable(R.drawable.arrowup));
        }
        else if (vote == 1)
        {
        	arrowUp.setImageDrawable(getResources().getDrawable(R.drawable.arrowupblue));
        	arrowDown.setImageDrawable(getResources().getDrawable(R.drawable.arrowdown));
        }
        else	//no votes
        {
        	arrowUp.setImageDrawable(getResources().getDrawable(R.drawable.arrowup));
        	arrowDown.setImageDrawable(getResources().getDrawable(R.drawable.arrowdown));
        }
	}

	void setMessageAndColorizeTags(String msg, TextView messageText) 
    {
    	String tagColor = "#33B5E5";
    	String message = msg;
    	
    	String[] wordArray = message.split(" ");
    	//check for tags, colorize them
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		if(wordArray[i].length() > 0)	//in case empty, doesn't throw nullpointer
    		{
    			if(wordArray[i].substring(0, 1).equals("#") && wordArray[i].length() > 1)
        		{
        			wordArray[i] = "<font color='" + tagColor + "'>" + wordArray[i] + "</font>";
        		}
    		}    		
    	}
    	
    	message = "";
    	//combine back to string
    	for(int i = 0; i < wordArray.length; i++)
    	{
    		message += wordArray[i] + " ";
    	}
    	
    	messageText.setText(Html.fromHtml(message));
		
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
	}

	public static void updateList() {
		if(listAdapter != null)
			listAdapter.notifyDataSetChanged();		
	}

}
