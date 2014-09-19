package com.appuccino.thecampusfeed.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;

public class TimeCrunchFragment extends Fragment
{
    static MainActivity mainActivity;
    View rootView;

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
        //list = (QuickReturnListView)rootView.findViewById(R.id.fragmentListView);

        //pullListFromServer();

        return rootView;
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
