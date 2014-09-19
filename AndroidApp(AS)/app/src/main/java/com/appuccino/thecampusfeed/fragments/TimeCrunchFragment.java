package com.appuccino.thecampusfeed.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.dialogs.WhatsTimeCrunchDialog;

public class TimeCrunchFragment extends Fragment
{
    static MainActivity mainActivity;

    //views
    View rootView;
    Button whatsTimeCrunchButton;

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

        setClickListeners();

        return rootView;
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
