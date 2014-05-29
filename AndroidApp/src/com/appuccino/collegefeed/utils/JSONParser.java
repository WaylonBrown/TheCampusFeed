package com.appuccino.collegefeed.utils;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.JsonReader;

import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Post;

public class JSONParser {

	public static ArrayList<College> collegeListFromJSON(String storedCollegeListJSON) throws IOException {
		ArrayList<College> ret = new ArrayList<College>();
		JsonReader reader = new JsonReader(new StringReader(storedCollegeListJSON));
		
		try {
			reader.beginArray();
			while(reader.hasNext()){
				
				String name = null;
				int id = Integer.MIN_VALUE;
				double latitude = 0;
				double longitude = 0;
				
				reader.beginObject();
				while(reader.hasNext()){
					String property = reader.nextName(); //property name of next property.
					if(property.equals("id")){
						id = reader.nextInt();
					}
					else if(property.equals("name")){
						name = reader.nextString();
					}
					else if(property.equals("lat")){
						latitude = reader.nextDouble();
					}
					else if(property.equals("lon")){
						longitude = reader.nextDouble();
					}
					else{
						reader.skipValue();
					}
				}
				reader.endObject();
				
				ret.add(new College(name, id, latitude, longitude));
			}
			reader.endArray();
		} finally{
			reader.close();
		}
		
		return ret;
	}
	
	public static ArrayList<Post> postListFromJSON(String json) throws IOException{
		ArrayList<Post> ret = new ArrayList<Post>();
		JsonReader reader = new JsonReader(new StringReader(json));
		
		try {
			reader.beginArray();
			while(reader.hasNext()){
				
				Integer id = null;
				String text = null;
				Integer score = null;
				
				reader.beginObject();
				while(reader.hasNext()){
					String name = reader.nextName(); //property name of next property.
					if(name.equals("id")){
						id = reader.nextInt();
					}
					else if(name.equals("text")){
						text = reader.nextString();
					}
					else{
						reader.skipValue();
					}
				}
				reader.endObject();
				
				ret.add(new Post(0,text,2));
			}
			reader.endArray();
		} finally{
			reader.close();
		}
		
		return ret;
	}

}
