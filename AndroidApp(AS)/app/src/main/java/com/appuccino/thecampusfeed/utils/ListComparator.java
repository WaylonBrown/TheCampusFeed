package com.appuccino.thecampusfeed.utils;

import java.util.Comparator;
import java.util.Locale;

import com.appuccino.thecampusfeed.objects.College;

public class ListComparator implements Comparator<College>{

	@Override
	public int compare(College lhs, College rhs) {
		return lhs.getName().toLowerCase(Locale.getDefault()).compareTo(rhs.getName().toLowerCase(Locale.getDefault()));
	}

}
