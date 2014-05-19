#import "TICKAppDelegate.h"
#import "TICKAlarmsTableViewController.h"
#import "TICKAlarm.h"
#import "TICKTabBarViewController.h"

@implementation TICKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    return YES;
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	TICKTabBarViewController *tabBarController = (TICKTabBarViewController *)self.window.rootViewController;
    [tabBarController.tock detachFromTock];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	TICKTabBarViewController *tabBarController = (TICKTabBarViewController *)self.window.rootViewController;
    [tabBarController.tock attachToTock];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
	TICKTabBarViewController *tabBarController = (TICKTabBarViewController *)self.window.rootViewController;
    [tabBarController.tock detachFromTock];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
