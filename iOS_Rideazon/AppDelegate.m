#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>

static NSString* const kHNKGooglePlacesAutocompleteApiKey = @"KEY_REMOVED";


@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:kHNKGooglePlacesAutocompleteApiKey];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                    annotation:annotation];
}

@end
