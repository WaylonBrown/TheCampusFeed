package com.appuccino.thecampusfeed.objects;

/**
 * Created by Waylon on 9/25/2014.
 */
public class Achievement {
    public String name;
    public int numToAchieve;
    public int reward;
    public int ID;
    public int section; //1 = Quantities of Posts, 2 = Total Post Score, 3 = Individual Post Score, 4 = Extra

    public Achievement(String n, int num, int r, int i, int s){
        name = n;
        numToAchieve = num;
        reward = r;
        ID = i;
        section = s;
    }
}
