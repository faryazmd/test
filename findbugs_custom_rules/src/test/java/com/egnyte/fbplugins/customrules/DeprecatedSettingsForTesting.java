package com.egnyte.fbplugins.customrules;

import static java.util.Arrays.asList;

import java.util.Collections;

import com.egnyte.fbplugins.customrules.DeprecatedSettings;
import com.egnyte.fbplugins.customrules.Deprecation;
import com.egnyte.fbplugins.customrules.MethodDeprecation;
import com.egnyte.fbplugins.customrules.MyDeprecatedClass;
import com.egnyte.fbplugins.customrules.MyDeprecatedInterface;
import com.egnyte.fbplugins.customrules.method.MyClassWithDeprecatedInstanceMethod;
import com.egnyte.fbplugins.customrules.method.MyClassWithDeprecatedStaticMethod;
import com.egnyte.fbplugins.customrules.method.MyInterfaceWithDeprecatedMethod;

public class DeprecatedSettingsForTesting {

    public DeprecatedSettings settings() {
        Deprecation myDeprecatedClass = Deprecation.of(MyDeprecatedClass.class.getCanonicalName(), "");
        Deprecation myDeprecatedInterface = Deprecation.of(MyDeprecatedInterface.class.getCanonicalName(), "cause i said so");
        Deprecation myDeprecatedStaticMethod = MethodDeprecation.ofMethod(MyClassWithDeprecatedStaticMethod.class.getCanonicalName(), "iAmDeprecated", "");
        Deprecation myDeprecatedInstanceMethod = MethodDeprecation.ofMethod(MyClassWithDeprecatedInstanceMethod.class.getCanonicalName(), "iAmDeprecated", "");
        Deprecation myDeprecatedInterfaceMethod = MethodDeprecation.ofMethod(MyInterfaceWithDeprecatedMethod.class.getCanonicalName(), "iAmDeprecated", "");
        
        return new DeprecatedSettings(asList(myDeprecatedClass, 
                                             myDeprecatedInterface, 
                                             myDeprecatedStaticMethod, 
                                             myDeprecatedInstanceMethod,
                                             myDeprecatedInterfaceMethod),
                                      asList(MyDeprecatedClass.class.getCanonicalName(), 
                                             MyDeprecatedInterface.class.getCanonicalName(),
                                             MyClassWithDeprecatedStaticMethod.class.getCanonicalName(),
                                             MyClassWithDeprecatedInstanceMethod.class.getCanonicalName(),
                                             MyInterfaceWithDeprecatedMethod.class.getCanonicalName()), 
                                      Collections.<String>emptyList());
    }
    
}
