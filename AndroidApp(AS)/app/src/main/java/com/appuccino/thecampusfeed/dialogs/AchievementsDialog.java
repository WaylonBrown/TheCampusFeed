package com.appuccino.thecampusfeed.dialogs;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.Gravity;
import android.widget.Button;
import android.widget.TextView;

import com.appuccino.thecampusfeed.MainActivity;
import com.appuccino.thecampusfeed.objects.Achievement;
import com.appuccino.thecampusfeed.utils.FontManager;
import com.appuccino.thecampusfeed.utils.PrefManager;

import java.util.ArrayList;
import java.util.List;

public class AchievementsDialog extends AlertDialog.Builder{
	Context context;
	AlertDialog dialog;

    public static List<Achievement> achievementList;

	public AchievementsDialog(final Context context) {
		super(context);
		this.context = context;
		setCancelable(true);

        // if the View your Achievements achievement isn't unlocked, unlock it
        unlockAchievement(context, 31);

        setPositiveButton("Got it", new DialogInterface.OnClickListener()
        {
            @Override
            public void onClick(DialogInterface dialog, int which)
            {
                //do nothing
            }
        }).setTitle("Achievements");

        String message = constructAchievementsString();

        setMessage(message);
		
		createDialog();
	}

    public static void unlockAchievement(Context c, int id) {
        if(!MainActivity.achievementUnlockedList.contains(id)){
            Achievement achievement = null;
            for(Achievement ach : AchievementsDialog.achievementList){
                if(ach.ID == id){
                    achievement = ach;
                }
            }

            if(achievement != null){
                MainActivity.achievementUnlockedList.add(id);
                PrefManager.putAchievementUnlockedList(MainActivity.achievementUnlockedList);
                PrefManager.putInt(PrefManager.TIME_CRUNCH_HOURS,
                        PrefManager.getInt(PrefManager.TIME_CRUNCH_HOURS, 0) + achievement.reward);

                //show Achievement Unlocked! dialog
                AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(c);
                dialogBuilder.setPositiveButton("Great!", new DialogInterface.OnClickListener(){
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        //do nothing
                    }
                }).setTitle("Achievement Unlocked!");

                String message = "You've earned " + achievement.reward + " hours for your Time Crunch by ";
                switch(achievement.section){
                    case 1:
                        message += "making a total of " + achievement.numToAchieve + " posts!";
                        break;
                    case 2:
                        message += "achieving a total Post Score of " + achievement.numToAchieve + " points!";
                        break;
                    case 3:
                        message += "making a post that has at least " + achievement.numToAchieve + " points!";
                        break;
                    case 4:
                        if(achievement.ID == 31){
                            message += "viewing your Achievements List!";
                        } else if (achievement.ID == 32){
                            message += "getting 100 points for a post that is 3 words or less!";
                        } else if (achievement.ID == 33){
                            message += "having 2000+ Time Crunch hours!";
                        }
                }

                dialogBuilder.setMessage(message);

                AlertDialog dialog = dialogBuilder.create();
                dialog.show();

                TextView titleText = (TextView) dialog.findViewById(c.getResources().getIdentifier("alertTitle", "id", "android"));
                TextView messageText = (TextView)dialog.findViewById(android.R.id.message);
                Button yesButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
                Button noButton = dialog.getButton(AlertDialog.BUTTON_NEGATIVE);

                titleText.setTypeface(FontManager.light);
                messageText.setTypeface(FontManager.light);
                yesButton.setTypeface(FontManager.light);
                if(noButton != null){
                    noButton.setTypeface(FontManager.light);
                }
            }
        }
    }

    private String constructAchievementsString() {
        String str = "";

        str += "Achievement Name (Time Crunch Reward)\n\nQuantities of Posts:\n";
        for(Achievement ach : achievementList){
            if(ach.section == 1){
                //if achievement has been unlocked
                if(MainActivity.achievementUnlockedList.contains(ach.ID)){
                    str += "✔ ";
                }
                str += ach.name + " (" + ach.reward + " hours)\n";
            }
        }

        str += "\nTotal Post Score:\n";
        for(Achievement ach : achievementList){
            if(ach.section == 2){
                //if achievement has been unlocked
                if(MainActivity.achievementUnlockedList.contains(ach.ID)){
                    str += "✔ ";
                }
                str += ach.name + " (" + ach.reward + " hours)\n";
            }
        }

        str += "\nIndividual Post Score:\n";
        for(Achievement ach : achievementList){
            if(ach.section == 3){
                //if achievement has been unlocked
                if(MainActivity.achievementUnlockedList.contains(ach.ID)){
                    str += "✔ ";
                }
                str += ach.name + " (" + ach.reward + " hours)\n";
            }
        }

        str += "\nExtra:\n";
        for(Achievement ach : achievementList){
            if(ach.section == 4){
                //if achievement has been unlocked or achievement is View Achievement List achievement
                if(MainActivity.achievementUnlockedList.contains(ach.ID)){
                    str += "✔ ";
                }
                str += ach.name + " (" + ach.reward + " hours)\n";
            }
        }

        return str;
    }

    public static void generateAchievementList() {
        List<Achievement> returnList = new ArrayList<Achievement>();
        //parameters: String name, int numToAchieve, int reward, int id, int section (1 = Quantities of Posts, 2 = Total Post Score, 3 = Individual Post Score, 4 = Extra)
        returnList.add(new Achievement("1 Post", 1, 10, 1, 1));
        returnList.add(new Achievement("3 Posts", 3, 30, 2, 1));
        returnList.add(new Achievement("10 Posts", 10, 100, 3, 1));
        returnList.add(new Achievement("50 Posts", 50, 500, 4, 1));
        returnList.add(new Achievement("200 Posts", 200, 2000, 5, 1));
        returnList.add(new Achievement("1000 Posts", 1000, 10000, 6, 1));

        returnList.add(new Achievement("10 Points", 10, 20, 10, 2));
        returnList.add(new Achievement("30 Points", 30, 60, 11, 2));
        returnList.add(new Achievement("100 Points", 100, 200, 12, 2));
        returnList.add(new Achievement("500 Points", 500, 1000, 13, 2));
        returnList.add(new Achievement("2,000 Points", 2000, 4000, 14, 2));
        returnList.add(new Achievement("10,000 Points", 10000, 20000, 15, 2));

        returnList.add(new Achievement("5 points", 5, 50, 20, 3));
        returnList.add(new Achievement("10 Points", 10, 100, 21, 3));
        returnList.add(new Achievement("20 Points", 20, 200, 22, 3));
        returnList.add(new Achievement("40 Points", 40, 400, 23, 3));
        returnList.add(new Achievement("80 Points", 80, 800, 24, 3));
        returnList.add(new Achievement("150 Points", 150, 1500, 25, 3));
        returnList.add(new Achievement("300 Points", 300, 3000, 26, 3));
        returnList.add(new Achievement("800 Points", 800, 8000, 27, 3));

        returnList.add(new Achievement("View your Achievements List", 1, 10, 31, 4));
        returnList.add(new Achievement("100 Points for a post that's 3 words or less", 1, 2000, 32, 4));
        returnList.add(new Achievement("Have 2000+ Time Crunch hours", 1, 2000, 33, 4));

        achievementList = returnList;
    }

    private void createDialog() {
		dialog = create();
		dialog.show();
		
		TextView titleText = (TextView) dialog.findViewById(context.getResources().getIdentifier("alertTitle", "id", "android"));
		TextView messageText = (TextView)dialog.findViewById(android.R.id.message);
        Button yesButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
        Button noButton = dialog.getButton(AlertDialog.BUTTON_NEGATIVE);

		titleText.setTypeface(FontManager.light);
		messageText.setTypeface(FontManager.light);
    	yesButton.setTypeface(FontManager.light);
        if(noButton != null){
            noButton.setTypeface(FontManager.light);
        }

        titleText.setGravity(Gravity.CENTER_HORIZONTAL);
        messageText.setGravity(Gravity.CENTER_HORIZONTAL);
	}
}