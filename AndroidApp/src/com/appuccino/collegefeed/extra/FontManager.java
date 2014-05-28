package com.appuccino.collegefeed.extra;

import android.content.Context;
import android.graphics.Typeface;

public class FontManager {
	public static Typeface light;
	public static Typeface italic;
	public static Typeface medium;
	public static Typeface bold;
	
	public static void setup(Context c) 
	{
		light = Typeface.createFromAsset(c.getAssets(), "fonts/Roboto-Light.ttf");
    	italic = Typeface.createFromAsset(c.getAssets(), "fonts/Roboto-LightItalic.ttf");
    	medium = Typeface.createFromAsset(c.getAssets(), "fonts/omnes_semibold.otf");
    	bold = Typeface.createFromAsset(c.getAssets(), "fonts/mplus-2c-bold.ttf");
	}
}
