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

    /**
     * For use with {@link com.appuccino.collegefeed.fragments.MostActiveCollegesFragment}
     * @param name
     * @param id
     */
    public College(String name, int id)
    {
        this.name = name;
        this.id = id;
    }

    /**
     * For use with {@link com.appuccino.collegefeed.utils.JSONParser}
     * @param name
     * @param id
     */
	public College(String name, int id, double lat, double lon)
	{
		this.name = name;
		this.id = id;
		this.latitude = lat;
		this.longitude = lon;
	}

    public void setName(String n){
        name = n;
    }
	
	public String getName()
	{
		return name;
	}
	
	public int getID()
	{
		return id;
	}
	
	public double getLatitude()
	{
		return latitude;
	}

	public double getLongitude()
	{
		return longitude;
	}
	
	@Override
	public String toString() {
		return "College name=" + name + ", shortName=" + shortName + ", id="
				+ id + ", latitude=" + latitude + ", longitude=" + longitude;
	}
}
