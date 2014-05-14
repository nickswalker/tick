#import "TICKTabBarViewController.h"
#import "TICKTock.h"

@interface TICKTabBarViewController () 

@end

@implementation TICKTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tock = [[TICKTock alloc] init];
	[self.tock didPowerOnBlock:^(id response, NSError *error) {
        [self.tock attachToTock];
	}];
	[[[self viewControllers][0] viewControllers][0] setTock:self.tock];
	[[[self viewControllers][2] viewControllers][0] setTock:self.tock];
	[[[self viewControllers][1] viewControllers][0] setTock:self.tock];
	UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:0];
	UIImage* selectedImage = [[UIImage imageNamed:@"color-fill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
	tabBarItem.selectedImage = selectedImage;
	
	tabBarItem = [self.tabBar.items objectAtIndex:1];
	selectedImage = [[UIImage imageNamed:@"alarms-fill"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
	tabBarItem.selectedImage = selectedImage;
	
	tabBarItem = [self.tabBar.items objectAtIndex:2];
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
