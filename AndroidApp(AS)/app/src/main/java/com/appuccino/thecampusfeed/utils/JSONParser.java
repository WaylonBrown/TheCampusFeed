package com.appuccino.thecampusfeed.utils;

import android.net.Uri;
import android.util.JsonReader;

import com.appuccino.thecampusfeed.objects.College;
import com.appuccino.thecampusfeed.objects.Comment;
import com.appuccino.thecampusfeed.objects.Post;
import com.appuccino.thecampusfeed.objects.Tag;
import com.appuccino.thecampusfeed.objects.Vote;

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
        JsonReader reader = null;
        if(storedCollegeListJSON != null)
            reader = new JsonReader(new StringReader(storedCollegeListJSON));

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
                int deltaScore = 0;
				int collegeID = -1;
				String time = null;
				int commentCount = 0;
                Uri imageUri = null;
				
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
                    else if(name.equals("vote_delta")){
                        //use in case null is passed in, which prim types can't take
                        try{
                            deltaScore = reader.nextInt();
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
                    else if(name.equals("image_uri")){
                        imageUri = Uri.parse(reader.nextString());
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
				
				ret.add(new Post(id, text, score, deltaScore, collegeID, time, commentCount, imageUri, -1));
			}
			reader.endArray();
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			reader.close();
		}
		
		return ret;
	}

    public static Post postFromJSON(String json) throws IOException{
        Post ret = null;
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));

            int id = -1;
            String text = null;
            int score = 0;
            int deltaScore = 0;
            int collegeID = -1;
            String time = null;
            int commentCount = 0;
            int defaultVoteID = 0;
            Uri uri = null;

            reader.beginObject();
            while(reader.hasNext()) {
                String name = reader.nextName(); //property name of next property.
                if (name.equals("id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        id = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("text")) {
                    text = reader.nextString();
                } else if (name.equals("score")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        score = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("vote_delta")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        deltaScore = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("college_id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        collegeID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("created_at")) {
                    time = reader.nextString();
                } else if (name.equals("comment_count")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        commentCount = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                }else if(name.equals("image_uri")){
                    try{
                        uri = Uri.parse(reader.nextString());
                    } catch (Exception e){
                        e.printStackTrace();
                    }

                }else if (name.equals("initial_vote_id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        defaultVoteID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else {
                    reader.skipValue();
                }
            }
            reader.endObject();
            ret = new Post(id, text, score, deltaScore, collegeID, time, commentCount, uri, defaultVoteID);
            return ret;
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }

    public static Vote postVoteFromJSON(String json) throws IOException{
        Vote ret = null;
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));

            int voteID = -1;
            boolean upvote = true;
            int postID = 0;

            reader.beginObject();
            while(reader.hasNext()) {
                String name = reader.nextName(); //property name of next property.
                if (name.equals("id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        voteID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("upvote")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        upvote = reader.nextBoolean();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("votable_id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        postID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else {
                    reader.skipValue();
                }
            }
            reader.endObject();
            ret = new Vote(voteID, postID, upvote);
            return ret;
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }

    public static Vote commentVoteFromJSON(String json, Comment comment) throws IOException{
        Vote ret = null;
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));

            int voteID = -1;
            boolean upvote = true;
            int postID = 0;

            reader.beginObject();
            while(reader.hasNext()) {
                String name = reader.nextName(); //property name of next property.
                if (name.equals("id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        voteID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("upvote")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        upvote = reader.nextBoolean();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("votable_id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        postID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else {
                    reader.skipValue();
                }
            }
            reader.endObject();
            ret = new Vote(voteID, postID, comment.getID(), upvote);
            return ret;
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }

    public static Comment commentFromJSON(String json) throws IOException{
        Comment ret = null;
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));

            int id = -1;
            String text = null;
            int score = 0;
            int postID = -1;
            String time = null;
            int voteDelta = 1;
            int defaultVoteID = -1;

            reader.beginObject();
            while(reader.hasNext()) {
                String name = reader.nextName(); //property name of next property.
                if (name.equals("id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        id = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("text")) {
                    text = reader.nextString();
                } else if (name.equals("score")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        score = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("vote_delta")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        voteDelta = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                }else if (name.equals("post_id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        postID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else if (name.equals("created_at")) {
                    time = reader.nextString();
                } else if (name.equals("initial_vote_id")) {
                    //use in case null is passed in, which prim types can't take
                    try {
                        defaultVoteID = reader.nextInt();
                    } catch (Exception e) {
                        reader.skipValue();
                    }
                } else {
                    reader.skipValue();
                }
            }
            reader.endObject();
            ret = new Comment(text, id, postID, score, voteDelta, 0, time, defaultVoteID);
            return ret;
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }

    /**
     * To load a comment list for a post
     *
     * @param json
     * @param postID
     * @return
     * @throws IOException
     */
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
                int deltaScore = 0;
				
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
					} else if (name.equals("vote_delta")) {
                        //use in case null is passed in, which prim types can't take
                        try {
                            deltaScore = reader.nextInt();
                        } catch (Exception e) {
                            reader.skipValue();
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
				ret.add(new Comment(message, id, postID, score, deltaScore, collegeID, time, -1));
			}
			reader.endArray();
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			reader.close();
		}
		return ret;
	}

    /**
     * To load a comment list for My Comments in My Content
     *
     * @param json
     * @return
     * @throws IOException
     */
    public static ArrayList<Comment> commentListFromJSON(String json) throws IOException{
        ArrayList<Comment> ret = new ArrayList<Comment>();
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));
            reader.beginArray();
            while(reader.hasNext()){

                int id = -1;
                int postID = 0;
                String message = null;
                int score = 0;
                int collegeID = -1;
                String time = null;
                int deltaScore = 0;

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
                    } else if (name.equals("vote_delta")) {
                        //use in case null is passed in, which prim types can't take
                        try {
                            deltaScore = reader.nextInt();
                        } catch (Exception e) {
                            reader.skipValue();
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
                    else if(name.equals("post_id")){
                        //use in case null is passed in, which prim types can't take
                        try{
                            postID = reader.nextInt();
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
                ret.add(new Comment(message, id, postID, score, deltaScore, collegeID, time, -1));
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

    public static String checkSumFromJSON(String json) throws IOException{
        String ret = null;
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));

            reader.beginObject();
            while(reader.hasNext()) {
                String name = reader.nextName(); //property name of next property.
                if (name.equals("version")) {
                    //use in case null is passed in, which prim types can't take
                    ret = reader.nextString();
                } else {
                    reader.skipValue();
                }
            }
            reader.endObject();
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }

    public static String appVersionFromJSON(String json) throws IOException{
        String ret = null;
        JsonReader reader = new JsonReader(new StringReader(""));
        try {
            reader = new JsonReader(new StringReader(json));

            reader.beginObject();
            while(reader.hasNext()) {
                String name = reader.nextName(); //property name of next property.
                if (name.equals("minVersion")) {
                    //use in case null is passed in, which prim types can't take
                    ret = reader.nextString();
                } else {
                    reader.skipValue();
                }
            }
            reader.endObject();
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            reader.close();
        }

        return ret;
    }
}
