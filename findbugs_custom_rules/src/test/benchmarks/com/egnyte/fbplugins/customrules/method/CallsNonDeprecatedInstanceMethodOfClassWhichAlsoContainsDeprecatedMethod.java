package com.egnyte.fbplugins.customrules.method;

public class CallsNonDeprecatedInstanceMethodOfClassWhichAlsoContainsDeprecatedMethod {

    public void callMethodWhichIsNotDeprecated() {
        new MyClassWithDeprecatedInstanceMethod().iAmNotDeprecated();
    }
    
}
