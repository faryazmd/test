package com.egnyte.fbplugins.customrules.method;

public class CallsDeprecatedInstanceMethod {

    public void doSomething() {
        new MyClassWithDeprecatedInstanceMethod().iAmDeprecated();
    }
    
}
