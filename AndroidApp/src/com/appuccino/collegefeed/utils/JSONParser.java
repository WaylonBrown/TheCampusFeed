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
		
		try {
			JsonReader reader = new JsonReader(new StringReader(json));
			reader.beginArray();
			while(reader.hasNext()){
				
				int id = -1;
				String text = null;
				int score = 0;
				int collegeID = -1;
				String time = null;
				
				reader.beginObject();
				while(reader.hasNext()){
					String name = reader.nextName(); //property name of next property.
					if(name.equals("id")){
						//use in case null is passed in, which prim types can't take
						try{
							id = reader.nextInt();
						}catch(Exception e){
							reader.skipValue();
							e.printStackTrace();
						}
					}
					else if(name.equals("text")){
						text = reader.nextString();
					}
					else if(name.equals("score")){
						//use in case null is passed in, which prim types can't take
						try{
							score = reader.nextInt();
						}catch(Exception e){
							reader.skipValue();
							e.printStackTrace();
						}
					}
					else if(name.equals("college_id")){
						//use in case null is passed in, which prim types can't take
						try{
							collegeID = reader.nextInt();
						}catch(Exception e){
							reader.skipValue();
							e.printStackTrace();
						}
					}
					else if(name.equals("created_at")){
						time = reader.nextString();
					}
					else{
						reader.skipValue();
					}
				}
				reader.endObject();
				
				ret.add(new Post(id, text, score, collegeID, time));
			}
			reader.endArray();
		} finally{
			reader.close();
		}
		
		return ret;
	}

	private static Integer passIntWithNull(Integer nextInt) {
		if(nextInt != null)
			return nextInt;
		
		return 0;
	}

}
