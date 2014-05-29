package com.appuccino.collegefeed.objects;

public class College 
{
	String name;
	String shortName;	//optional
	int id;
	double latitude;
	double longitude;
	
	public College(String name)
	{
		this.name = name;
	}
	
	public College(String name, int id, double lat, double lon)
	{
		this.name = name;
		this.id = id;
		this.latitude = lat;
		this.longitude = lon;
	}
	
	public String getName()
	{
		return name;
	}

	@Override
	public String toString() {
		return "College name=" + name + ", shortName=" + shortName + ", id="
				+ id + ", latitude=" + latitude + ", longitude=" + longitude;
	}
}
