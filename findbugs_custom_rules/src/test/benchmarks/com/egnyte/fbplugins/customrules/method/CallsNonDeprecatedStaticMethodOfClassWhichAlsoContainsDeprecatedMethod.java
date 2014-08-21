package com.egnyte.fbplugins.customrules.method;

public class CallsNonDeprecatedStaticMethodOfClassWhichAlsoContainsDeprecatedMethod {
    
    public static void callMethodWhichIsNotDeprecated() {
        MyClassWithDeprecatedStaticMethod.iAmNotDeprecated();
    }
}
