package com.appuccino.collegefeed;

import android.content.Context;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.widget.EditText;

public class MyEditText extends EditText{

	public MyEditText(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}
	
	public MyEditText(Context context,AttributeSet attr) {
	    super(context,attr);
	    // TODO Auto-generated constructor stub
	}
	
	//dont allow enter key to work
	@Override
    public boolean onKeyDown(int keyCode, KeyEvent event)
    {
        if (keyCode==KeyEvent.KEYCODE_ENTER) 
        {
            // Just ignore the [Enter] key
            return true;
        }
        // Handle all other keys in the default way
        return super.onKeyDown(keyCode, event);
    }
}
