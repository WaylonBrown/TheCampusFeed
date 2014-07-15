package com.appuccino.collegefeed.utils;

import android.util.JsonReader;

import com.appuccino.collegefeed.objects.College;
import com.appuccino.collegefeed.objects.Comment;
import com.appuccino.collegefeed.objects.Post;
import com.appuccino.collegefeed.objects.Tag;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;

public class JSONParser {

	public static ArrayList<College> collegeListFromJSON(String storedCollegeListJSON1, String storedCollegeListJSON2) throws IOException {
		ArrayList<College> ret = new ArrayList<College>();
		JsonReader reader = new JsonReader(new StringReader(storedCollegeListJSON1 + storedCollegeListJSON2));
		
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
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			reader.close();
		}
		
		return ret;
	}

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
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }
	
	public static ArrayList<Post> postListFromJSON(String json) throws IOException{
		ArrayList<Post> ret = new ArrayList<Post>();
		JsonReader reader = new JsonReader(new StringReader(""));
		try {
			reader = new JsonReader(new StringReader(json));
			reader.beginArray();
			while(reader.hasNext()){
				
				int id = -1;
				String text = null;
				int score = 0;
				int collegeID = -1;
				String time = null;
				int commentCount = 0;
				
				reader.beginObject();
				while(reader.hasNext()){
					String name = reader.nextName(); //property name of next property.
					if(name.equals("id")){
						//use in case null is passed in, which prim types can't take
						try{
							id = reader.nextInt();
						}catch(Exception e){
							reader.skipValue();
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
						}
					}
					else if(name.equals("college_id")){
						//use in case null is passed in, which prim types can't take
						try{
							collegeID = reader.nextInt();
						}catch(Exception e){
							reader.skipValue();
						}
					}
					else if(name.equals("created_at")){
						time = reader.nextString();
					}
					else if(name.equals("comment_count")){
						//use in case null is passed in, which prim types can't take
						try{
							commentCount = reader.nextInt();
						}catch(Exception e){
							reader.skipValue();
						}
					}
					else{
						reader.skipValue();
					}
				}
				reader.endObject();
				
				ret.add(new Post(id, text, score, collegeID, time, commentCount));
			}
			reader.endArray();
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			reader.close();
		}
		
		return ret;
	}

	public static ArrayList<Comment> commentListFromJSON(String json, int postID) throws IOException{
		ArrayList<Comment> ret = new ArrayList<Comment>();
		JsonReader reader = new JsonReader(new StringReader(""));
		try {
			reader = new JsonReader(new StringReader(json));
			reader.beginArray();
			while(reader.hasNext()){
				
				int id = -1;
				String message = null;
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
						message = reader.nextString();
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
				ret.add(new Comment(message, id, postID, score, collegeID, time));
			}
			reader.endArray();
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			reader.close();
		}
		return ret;
	}

	public static ArrayList<Tag> tagListFromJSON(String json) throws IOException {
		ArrayList<Tag> ret = new ArrayList<Tag>();
		JsonReader reader = new JsonReader(new StringReader(""));
		try {
			reader = new JsonReader(new StringReader(json));
			reader.beginArray();
			while(reader.hasNext()){
				
				String text = null;
				
				reader.beginObject();
				while(reader.hasNext()){
					String name = reader.nextName(); //property name of next property.
					if(name.equals("text")){
						text = reader.nextString();
					}
					else{
						reader.skipValue();
					}
				}
				reader.endObject();
				
				ret.add(new Tag(text));
			}
			reader.endArray();
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			reader.close();
		}
		
		return ret;
	}

}
