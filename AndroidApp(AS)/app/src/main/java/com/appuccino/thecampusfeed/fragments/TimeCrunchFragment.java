package com.appuccino.thecampusfeed.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.dialogs.ActivateTimeCrunchDialog;
import com.appuccino.thecampusfeed.dialogs.WhatsTimeCrunchDialog;
import com.appuccino.thecampusfeed.extra.CustomTextView;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.PrefManager;

public class TimeCrunchFragment extends Fragment
{
    static MainActivity mainActivity;

    //views
    View rootView;
    Button whatsTimeCrunchButton;
    Button activateButton;
    CustomTextView timeText;
    CustomTextView collegeText;
    int timeCrunchHours;
    int collegeID;
    boolean currentlyActive = false;

    public TimeCrunchFragment(){
        mainActivity = MainActivity.activity;
    }

    public TimeCrunchFragment(MainActivity m)
    {
        mainActivity = m;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_time_crunch,
                container, false);
        whatsTimeCrunchButton = (Button)rootView.findViewById(R.id.whatsTimeCrunch);
        activateButton = (Button)rootView.findViewById(R.id.activateButton);
        timeText = (CustomTextView)rootView.findViewById(R.id.timeCrunchTimeText);
        collegeText = (CustomTextView)rootView.findViewById(R.id.timeCrunchCollegeText);

        whatsTimeCrunchButton.setTypeface(FontManager.light);
        activateButton.setTypeface(FontManager.light);

        setClickListeners();
        getTimeCrunchData();

        return rootView;
    }

    private void getTimeCrunchData() {
        timeCrunchHours = PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0);
        collegeID = PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1);
        currentlyActive = PrefManager.getBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false);

        if(timeText != null && collegeText != null){
            String timeTextString;
            if(timeCrunchHours != 1)
                timeTextString = timeCrunchHours + " hrs";
            else
                timeTextString = timeCrunchHours + " hr";

            if(currentlyActive){
                timeTextString += " left";
            }
            timeText.setText(timeTextString);

            College homeCollege = MainActivity.getCollegeByID(collegeID);
            if(homeCollege != null){
                collegeText.setText(homeCollege.getName());
            }
        }
    }

    private void setClickListeners() {
        if(whatsTimeCrunchButton != null){
            whatsTimeCrunchButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    new WhatsTimeCrunchDialog(mainActivity);
                }
            });
        }

        if(activateButton != null){
            activateButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(timeCrunchHours <= 0){
                        new ActivateTimeCrunchDialog(mainActivity, "", "You need Time Crunch hours to do that!", false);
                    } else {
                        new ActivateTimeCrunchDialog(mainActivity, "Activate Time Crunch?", "Are you sure you want to start Time Crunch? This means that for the next " + timeCrunchHours +
                            " hours the app will think you are at your University, meaning you are free to post, comment, and vote on posts as if you were there. There's no backing out, it will" +
                                " remain like that until the Time Crunch hours are used!", true);
                    }
                }
            });
        }
    }


    public static void makeLoadingIndicator(boolean makeLoading)
    {
//        if(loadingSpinner != null){
//            if(makeLoading)
//            {
//                list.setVisibility(View.INVISIBLE);
//                loadingSpinner.setVisibility(View.VISIBLE);
//            }
//            else
//            {
//                list.setVisibility(View.VISIBLE);
//                loadingSpinner.setVisibility(View.INVISIBLE);
//            }
//        }
    }
}
