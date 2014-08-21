package com.egnyte.fbplugins.customrules;

import java.util.ArrayList;
import java.util.List;

public class HasADeprecatedClassForALocalVariable {

	public void someMethod() {
		toString();
		List<String> notDeprecated = new ArrayList<String>();
		notDeprecated.clear();
		
		MyDeprecatedClass localVariable = new MyDeprecatedClass();
		notDeprecated.add(localVariable.toString());
	}
	
}
