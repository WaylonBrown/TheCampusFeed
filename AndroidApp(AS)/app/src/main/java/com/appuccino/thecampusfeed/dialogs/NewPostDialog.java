package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.extra.CustomTextView;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.MyLog;
import com.appuccino.thecampusfeed.utils.NetWorker;
import com.appuccino.thecampusfeed.utils.NetWorker.MakePostTask;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class NewPostDialog extends AlertDialog.Builder{
	
	Context context;
	private int selectedCollegeID = -1;
    MainActivity main;
    AlertDialog dialog;
    ProgressDialog uploadDialog;
    private boolean imageSelected = false;
    CustomTextView checkMark;
    ImageView previewImage;
    ProgressBar progressBar;
    RelativeLayout layoutPreview;
    Uri currentImageUri;
    private static int IMAGE_MAX_DIMENSION = 700;
    Post post;

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
                if(thisString.length() >= MainActivity.MIN_POST_LENGTH || imageSelected)
                {
                    if(!imageSelected){
                        post = new Post(thisString, selectedCollegeID);
                        new MakePostTask(context, main).execute(post);
                        dialog.dismiss();
                    } else {
                        post = new Post(thisString, selectedCollegeID, currentImageUri);
                        compressAndUploadImage();
                    }
                }
                else
                {
                    Toast.makeText(context, "Text posts must be at least " + MainActivity.MIN_POST_LENGTH + " characters long.", Toast.LENGTH_LONG).show();
                }
            }
        });

        TextView title = (TextView)layout.findViewById(R.id.newPostTitle);
        TextView college = (TextView)layout.findViewById(R.id.collegeText);
        CustomTextView cameraButton = (CustomTextView)layout.findViewById(R.id.cameraButton);
        checkMark = (CustomTextView)layout.findViewById(R.id.checkMark);
        previewImage = (ImageView)layout.findViewById(R.id.imagePreview);
        LinearLayout pictureModeLayout = (LinearLayout)layout.findViewById(R.id.pictureModeLayout);
        progressBar = (ProgressBar)layout.findViewById(R.id.previewLoading);
        layoutPreview = (RelativeLayout)layout.findViewById(R.id.layoutPreview);

        layoutPreview.setVisibility(View.GONE);
        postMessage.setTypeface(FontManager.light);
        college.setTypeface(FontManager.italic);
        title.setTypeface(FontManager.light);
        postButton.setTypeface(FontManager.light);

        if(MainActivity.PICTURE_MODE){
            pictureModeLayout.setVisibility(View.VISIBLE);
        } else {
            pictureModeLayout.setVisibility(View.GONE);
        }
        checkMark.setVisibility(View.INVISIBLE);

        //if not in picture mode, ensure keyboard is brought up when dialog shows
        if(!MainActivity.PICTURE_MODE){
            postMessage.setOnFocusChangeListener(new View.OnFocusChangeListener() {
                @Override
                public void onFocusChange(View v, boolean hasFocus) {
                    if (hasFocus) {
                        dialog.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
                    }
                }
            });
        }

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

                String[] tagArray = MainActivity.parseTagsWithRegex(message);
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

        cameraButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(checkMark != null){
                    checkMark.setVisibility(View.GONE);
                }
                
                //if user has unlocked the 5 total post points achievement or test mode is on, allow pics
                if(MainActivity.achievementUnlockedList.contains(9) || MainActivity.TEST_MODE_ON){
                    //if achievement isnt unlocked but allowing to add image because of test mode
                    if(!MainActivity.achievementUnlockedList.contains(9) && MainActivity.TEST_MODE_ON){
                        Toast.makeText(main, "Test mode is on, allowing to post image even though no achievement", Toast.LENGTH_SHORT).show();
                    }
                    Intent photoPickerIntent = new Intent(Intent.ACTION_PICK);
                    photoPickerIntent.setType("image/*");
                    main.startActivityForResult(photoPickerIntent, MainActivity.SELECT_PHOTO_INTENT_CODE);
                    progressBar.setVisibility(View.VISIBLE);
                    layoutPreview.setVisibility(View.VISIBLE);
                } else {
                    new ActivateTimeCrunchDialog(main, null, 0, "", "In order to post pictures, you need to first unlock the achievement \"Achieve a total post score of at least 5\"", false);
                }
            }
        });

        setupCollege(college);
    }

    public void compressAndUploadImage(){
        uploadDialog = new ProgressDialog(main);
        uploadDialog.setTitle("Uploading image...");
        uploadDialog.setProgressStyle(uploadDialog.STYLE_HORIZONTAL);
        uploadDialog.setProgress(0);   //start at 20 since image is compressed
        uploadDialog.setMax(100);
        uploadDialog.show();
        TextView titleText = (TextView) uploadDialog.findViewById(context.getResources().getIdentifier("alertTitle", "id", "android"));
        titleText.setTypeface(FontManager.light);

        try {
            Bitmap bitmap = MediaStore.Images.Media.getBitmap(main.getContentResolver(), currentImageUri);
            MyLog.i("Image file size before compression: " + (bitmap.getRowBytes() * bitmap.getHeight()));
            //compression, between the width and height the longer one is 100
            float widthToHeightRatio = (float)bitmap.getWidth() / (float)bitmap.getHeight();
            int width = 0;
            int height = 0;
            //width is greater
            if(widthToHeightRatio > 1.0f){
                height = Math.round(IMAGE_MAX_DIMENSION * (float)bitmap.getHeight() / (float)bitmap.getWidth());
                width = IMAGE_MAX_DIMENSION;
            } else if (widthToHeightRatio < 1.0f) { //height is greater
                width = Math.round(IMAGE_MAX_DIMENSION * (float)bitmap.getWidth() / (float)bitmap.getHeight());
                height = IMAGE_MAX_DIMENSION;
            } else {    //width and height are exact same
                width = IMAGE_MAX_DIMENSION;
                height = IMAGE_MAX_DIMENSION;
            }

            Bitmap compressedBitmap = Bitmap.createScaledBitmap(bitmap, width, height, true);
            MyLog.i("Image file size after compression: " + (compressedBitmap.getRowBytes() * compressedBitmap.getHeight()));

            //20% since image is compressed
            uploadDialog.setProgress(20);
            ContextWrapper cw = new ContextWrapper(main);
            // path to /data/data/yourapp/app_data/imageDir
            File directory = cw.getDir("TheCampusFeed", Context.MODE_PRIVATE);
            // Create imageDir
            File mypath=new File(directory,"uploadedImage.jpg");
            MyLog.i("Files path is: " + mypath.getAbsolutePath());

            FileOutputStream fos = null;
            try {

                fos = new FileOutputStream(mypath);

                // Use the compress method on the BitMap object to write image to the OutputStream
                compressedBitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
                fos.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            if(MainActivity.COMPRESSION_TEST_MODE_ON){
                Toast.makeText(main, "Test mode is on, replacing preview with compressed image and not posting post", Toast.LENGTH_SHORT).show();
                //replaces preview with compressed image and doesn't post
                testCompressedImage(compressedBitmap, mypath);
                uploadDialog.dismiss();
            } else {    //save then upload image
                new NetWorker.UploadImageTask(main, main, this, uploadDialog, mypath).execute(compressedBitmap);
            }

        } catch (IOException e) {
            makeImageErrorToast();
            uploadDialog.dismiss();
            e.printStackTrace();
        }
    }

    public void imageUploaded(int imageID, Uri imageUri){
        if(uploadDialog != null && uploadDialog.isShowing()){
            uploadDialog.dismiss();
        }
        if(dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }

        if(post != null){
            post.setImageID(imageID);
            post.setImageUri(imageUri);
            new MakePostTask(context, main).execute(post);
        } else {
            Toast.makeText(main, "Error making post, please try again.", Toast.LENGTH_LONG).show();
        }
    }

    //optional for testing, saves Bitmap to system then shows in app after compression
    public void testCompressedImage(Bitmap bm, File mypath){
        previewImage.setVisibility(View.VISIBLE);
        Picasso.with(context).load(mypath).fit().centerInside().into(previewImage);
    }

    public void setViewsOnCancel(){
        if(layoutPreview != null){
            layoutPreview.setVisibility(View.GONE);
            checkMark.setVisibility(View.GONE);
        }
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

    public void setImageChosen(Uri imageUri){
        imageSelected = true;
        previewImage.setVisibility(View.VISIBLE);
        Picasso.with(context).load(imageUri).fit().centerInside().into(previewImage, new Callback() {
            @Override
            public void onSuccess() {
                if(progressBar != null){
                    progressBar.setVisibility(View.GONE);
                    checkMark.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onError() {
                if(progressBar != null){
                    progressBar.setVisibility(View.GONE);
                    layoutPreview.setVisibility(View.GONE);
                    checkMark.setVisibility(View.GONE);
                }
            }
        });
        currentImageUri = imageUri;
    }

    public void makeImageErrorToast(){
        Toast.makeText(main, "Error uploading image, please try again.", Toast.LENGTH_LONG).show();
    }
}
