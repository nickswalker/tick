#import "TICKAppDelegate.h"
#import "TICKAlarmsTableViewController.h"
#import "TICKAlarm.h"
#import "TICKTabBarViewController.h"

@implementation TICKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    alarm_t test;
	test.hour = 15;
	test.minute = 30;
	test.repeatSchedule = 0b10011110;
	NSMutableArray* alarms = [[NSMutableArray alloc] init];
	TICKAlarm* tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	
	test.repeatSchedule = 0b10111110;
	tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	test.repeatSchedule = 0b11111111;
	tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	test.repeatSchedule = 0b10110111;
	tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	
	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController = [tabBarController viewControllers][1];
    TICKAlarmsTableViewController *alarmsViewController = [navigationController viewControllers][0];
    alarmsViewController.alarms = alarms;
	
    return YES;
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
    [tabBarController.tock disconnectPeripheral];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
