package com.egnyte.fbplugins.customrules;

public class UsesDeprecatedClassInInstanceOfCheck {

	public void someMethod(Object obj) {
		if (obj instanceof MyDeprecatedClass) { } 
	}
	
}
