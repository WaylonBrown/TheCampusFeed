package com.appuccino.thecampusfeed.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.dialogs.ActivateTimeCrunchDialog;
import com.appuccino.thecampusfeed.dialogs.DeactivateTimeCrunchDialog;
import com.appuccino.thecampusfeed.dialogs.WhatsTimeCrunchDialog;
import com.appuccino.thecampusfeed.extra.CustomTextView;
import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.MyLog;
import com.appuccino.thecampusfeed.utils.PrefManager;

import java.util.Calendar;

public class TimeCrunchFragment extends Fragment
{
    static MainActivity mainActivity;

    //views
    View rootView;
    Button whatsTimeCrunchButton;
    static Button activateButton;
    static Button deactivateButton;
    static CustomTextView timeText;
    static CustomTextView collegeText;
    static CustomTextView bottomText;

    //values
    static int timeCrunchHours;
    int collegeID;
    static boolean currentlyActive = false;
    static Calendar activateTime;

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
        if(mainActivity == null){
            mainActivity = (MainActivity)getActivity();
        }
        rootView = inflater.inflate(R.layout.fragment_time_crunch,
                container, false);
        whatsTimeCrunchButton = (Button)rootView.findViewById(R.id.whatsTimeCrunch);
        activateButton = (Button)rootView.findViewById(R.id.activateButton);
        deactivateButton = (Button)rootView.findViewById(R.id.deActivateButton);
        timeText = (CustomTextView)rootView.findViewById(R.id.timeCrunchTimeText);
        collegeText = (CustomTextView)rootView.findViewById(R.id.timeCrunchCollegeText);
        bottomText = (CustomTextView)rootView.findViewById(R.id.timeCrunchBottomText);

        whatsTimeCrunchButton.setTypeface(FontManager.light);
        activateButton.setTypeface(FontManager.light);
        deactivateButton.setTypeface(FontManager.light);

        setClickListeners();
        getTimeCrunchData();

        return rootView;
    }

    private void getTimeCrunchData() {
        timeCrunchHours = PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0);
        collegeID = PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1);
        activateTime = PrefManager.getTimeCrunchActivateTimestamp();
        //use for testing
//        timeCrunchHours = 100;
//        collegeID = 645;
        currentlyActive = PrefManager.getBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false);
        if(currentlyActive){
            activateButton.setVisibility(View.GONE);
            deactivateButton.setVisibility(View.VISIBLE);
        } else {
            activateButton.setVisibility(View.VISIBLE);
            deactivateButton.setVisibility(View.GONE);
        }

        if(mainActivity != null){
            checkTimeCrunchHoursLeft(mainActivity);
        }

        if(timeText != null && collegeText != null && bottomText != null){
            String timeTextString;
            if(timeCrunchHours != 1)
            {
                if(timeCrunchHours >= 0){
                    timeTextString = timeCrunchHours + " hrs";
                } else {
                    timeTextString = 0 + " hrs";
                }
            }
            else
                timeTextString = timeCrunchHours + " hr";

            if(currentlyActive){
                timeTextString += " left";
            }
            timeText.setText(timeTextString);

            College homeCollege = MainActivity.getCollegeByID(collegeID);
            if(homeCollege != null && timeCrunchHours > 0){
                collegeText.setText(homeCollege.getName());
            }

            String bottomTextString;
            if(currentlyActive){
                bottomTextString = "Time crunch is on.";
            } else {
                bottomTextString = "Time crunch is off.";
            }
            bottomText.setText(bottomTextString);
        }
    }

    //passing in reference to the MainActivity since it is called statically before this fragment is created
    public static void checkTimeCrunchHoursLeft(MainActivity main) {
        activateTime = PrefManager.getTimeCrunchActivateTimestamp();
        currentlyActive = PrefManager.getBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false);
        timeCrunchHours = PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0);

        //update hours according to time stamp
        if(currentlyActive && activateTime != null){
            MyLog.i("Time crunch is active, calculating hours left");
            Calendar now = Calendar.getInstance();
            long difference = now.getTimeInMillis() - activateTime.getTimeInMillis();
            //int hoursDifference = (int)Math.ceil(difference / (60*60*1000));
            //use for testing: this uses seconds instead of hours
            int hoursDifference = (int)Math.ceil(difference / (1000));
            MyLog.i("hoursDifference: " + hoursDifference);
            timeCrunchHours = timeCrunchHours - hoursDifference;
            MyLog.i("timeCrunchHours: " + timeCrunchHours);
            //time crunch is done
            if(timeCrunchHours <= 0){
                MyLog.i("Time crunch is now done");
                PrefManager.putBoolean(PrefManager.TIME_CRUNCH_ACTIVATED, false);
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOURS, 0);
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1);
                PrefManager.putTimeCrunchActivateTimestamp(null);
                main.getLocation();
                updateActivationState(false);
                Toast.makeText(main, "Your Time Crunch time has expired, getting normal GPS location", Toast.LENGTH_LONG).show();
            }
        } else {
            MyLog.i("Time crunch is inactive");
        }
    }

    public static void updateActivationState(boolean active){
        timeCrunchHours = PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0);

        if(bottomText != null){
            String bottomTextString;
            if(active){
                bottomTextString = "Time crunch is on.";
            } else {
                bottomTextString = "Time crunch is off.";
            }
            bottomText.setText(bottomTextString);
        }

        if(activateButton != null && deactivateButton != null){
            if(active){
                deactivateButton.setVisibility(View.VISIBLE);
                activateButton.setVisibility(View.GONE);
            } else {
                activateButton.setVisibility(View.VISIBLE);
                deactivateButton.setVisibility(View.GONE);
            }
        }

        if(timeText != null){
            if(!active){
                timeText.setText("0 hrs");
            } else {
                timeText.setText(timeText.getText().toString() + " left");
            }
        }

        if(collegeText != null){
            College homeCollege = MainActivity.getCollegeByID(PrefManager.getInt(PrefManager.TIME_CRUNCH_HOME_COLLEGE, -1));
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

        final TimeCrunchFragment that = this;
        if(activateButton != null){
            activateButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if(timeCrunchHours <= 0){
                        new ActivateTimeCrunchDialog(mainActivity, that, collegeID, "", "You need Time Crunch hours to do that!", false);
                    } else {
                        new ActivateTimeCrunchDialog(mainActivity, that, collegeID, "Activate Time Crunch?", "Are you sure you want to start Time Crunch? This means that for the next " + timeCrunchHours +
                                " hours the app will think you are at your University, meaning you are free to post, comment, and vote on posts as if you were there. If you ever want to cancel your" +
                                " Time Crunch, the rest of the unused hours will be wiped!", true);
                    }
                }
            });
        }

        if(deactivateButton != null){
            deactivateButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    new DeactivateTimeCrunchDialog(mainActivity, that);
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
