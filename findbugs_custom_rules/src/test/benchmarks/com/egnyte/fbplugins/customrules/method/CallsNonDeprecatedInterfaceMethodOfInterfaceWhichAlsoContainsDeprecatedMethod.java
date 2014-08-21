package com.egnyte.fbplugins.customrules.method;

public class CallsNonDeprecatedInterfaceMethodOfInterfaceWhichAlsoContainsDeprecatedMethod {

    public void callMethodWhichIsNotDeprecated(MyInterfaceWithDeprecatedMethod interfaceWithDeprecated) {
        interfaceWithDeprecated.iAmNotDeprecated();
    }
    
}
