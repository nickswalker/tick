#import "TICKTabBarViewController.h"
#import "TICKTock.h"
#import "MBProgressHUD.h"

@interface TICKTabBarViewController () 

@end

@implementation TICKTabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tock = [[TICKTock alloc] init];
	self.tock.delegate = self;

	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	self.HUD = [[MBProgressHUD alloc] init];
	[self.HUD setRemoveFromSuperViewOnHide:true];

	[[[[self viewControllers][0] viewControllers][0] view] addSubview:self.HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	self.HUD.delegate = self;
	
	[self.tock didPowerOnBlock:^(id response, NSError *error) {
		[self.tock attachToTock];
		[self.HUD show:true];
	}];
	printf("Hey");
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self tockDidAttach];
		
	});
	
	[[[self viewControllers][0] viewControllers][0] setTock:self.tock];
	//[[[self viewControllers][2] viewControllers][0] setTock:self.tock];
	[[[self viewControllers][1] viewControllers][0] setTock:self.tock];
	//UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:0];
	//UIImage* selectedImage = [[UIImage imageNamed:@"color-fill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
	//tabBarItem.selectedImage = selectedImage;
	
	UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:0];
	UIImage* selectedImage = [[UIImage imageNamed:@"alarms-fill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
	tabBarItem.selectedImage = selectedImage;
	
	tabBarItem = [self.tabBar.items objectAtIndex:1];
	selectedImage = [[UIImage imageNamed:@"options-fill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
	tabBarItem.selectedImage = selectedImage;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	NSLog(@"TABBARDIDSELECT");
}

#pragma mark MBProgressHUDDelegate methods

-(void)tockDidAttach{
	[self.HUD removeFromSuperview];
	printf("YOU");
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	//[self.HUD removeFromSuperview];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
