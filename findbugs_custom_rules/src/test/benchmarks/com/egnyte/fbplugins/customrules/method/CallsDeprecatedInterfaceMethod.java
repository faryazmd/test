package com.egnyte.fbplugins.customrules.method;

public class CallsDeprecatedInterfaceMethod {

    public void doSomething(MyInterfaceWithDeprecatedMethod interfaceWithDeprecated) {
        interfaceWithDeprecated.iAmDeprecated();
    }
    
}
