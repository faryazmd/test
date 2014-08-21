package com.egnyte.fbplugins.customrules;


import org.apache.commons.lang.StringUtils;

import edu.umd.cs.findbugs.BugReporter;
import edu.umd.cs.findbugs.Detector;
import edu.umd.cs.findbugs.ba.ClassContext;

public class ThisPluginDetector implements Detector {
    private static final String loggingLabel = Deprecated3rdPartyDetector.class.getSimpleName();
	
    private static class SetupChecker {
        
        private SetupChecker() { }
        public static SetupChecker SINGLETON_INSTANCE = new SetupChecker();
        
        public DeprecatedSettings initialiseSettings() throws Exception {
            String deprecatedListPath = System.getenv("DEPRECATED_LIST_HOME");
            System.out.printf("Will try to load from [%s].%n", deprecatedListPath);
            DeprecatedSettings settings = DeprecatedSettings.settingsFromTxtFile(deprecatedListPath);
            if (!settings.isValid()) {
                int lineNumber = 0;
                for(String invalidLines: settings.invalidLines()) {
                    System.out.printf("[%s] Error in deprecated class list (line %d): class name: [%s]%n", 
                            loggingLabel, lineNumber++, invalidLines);
                }
            } else {
                String deprecated = StringUtils.join(settings.deprecatedClasses(), ",");
                System.out.printf("[%s] Searching for deprecated classes: [%s]", loggingLabel, deprecated);
            }
            
            return settings;
        }
    }
	
    

	static {
        System.out.printf("Registered plugin detector [%s]%n", loggingLabel);
    }
	
    private final DeprecatedSettings settings;
    private final Deprecated3rdPartyDetector actualDetector;
	
	public ThisPluginDetector(BugReporter bugReporter) {
		this.settings = createSettings();
		this.actualDetector = new Deprecated3rdPartyDetector(this, bugReporter, settings);
	}
	
	private DeprecatedSettings createSettings() {
	    try {
	        return SetupChecker.SINGLETON_INSTANCE.initialiseSettings();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new DeprecatedSettings(false);
    }

    @Override
	public void report() { }

	@Override
	public void visitClassContext(ClassContext classContext) {
	    if (! settings.isValid()) { return; }
	    
	    actualDetector.visitClassContext(classContext);
	}
	

}
