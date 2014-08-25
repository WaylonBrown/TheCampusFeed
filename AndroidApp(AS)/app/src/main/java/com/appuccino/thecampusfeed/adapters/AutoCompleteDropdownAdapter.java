package com.appuccino.thecampusfeed.adapters;

import java.util.List;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.R;
import com.appuccino.thecampusfeed.utils.FontManager;

public class AutoCompleteDropdownAdapter extends ArrayAdapter<String>{

	MainActivity main;
	int rowLayout;
	List<String> allCollegesList;
	
	public AutoCompleteDropdownAdapter(MainActivity main, int rowLayout, List<String> allCollegesList) {
		super(main, rowLayout, allCollegesList);
		this.main = main;
		this.rowLayout = rowLayout;
		this.allCollegesList = allCollegesList;
	}

	@Override
    public View getView(int position, View convertView, ViewGroup parent) {
         
        try{
             
            /*
             * The convertView argument is essentially a "ScrapView" as described is Lucas post 
             * http://lucasr.org/2012/04/05/performance-tips-for-androids-listview/
             * It will have a non-null value when ListView is asking you recycle the row layout. 
             * So, when convertView is not null, you should simply update its contents instead of inflating a new row layout.
             */
            if(convertView==null){
                // inflate the layout
                LayoutInflater inflater = ((MainActivity) main).getLayoutInflater();
                convertView = inflater.inflate(rowLayout, parent, false);
            }
             
            // object item based on the position
            String college = getItem(position);
 
            // get the TextView and then set the text (item name) and tag (item ID) values
            TextView collegeTextView = (TextView) convertView.findViewById(R.id.dropDownText);
            collegeTextView.setText(college);
            collegeTextView.setTypeface(FontManager.light);
             
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
         
        return convertView;
         
    }
}
