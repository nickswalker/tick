#import "TICKTabBarViewController.h"
#import "TICKTock.h"

@interface TICKTabBarViewController () 

@end

@implementation TICKTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"TabbarLoaded");
    self.tock = [[TICKTock alloc] init];
	[self.tock didPowerOnBlock:^(id response, NSError *error) {
        [self.tock attachToTock];
	}];
	[[[self viewControllers][0] viewControllers][0] setTock:self.tock];
	[[[self viewControllers][2] viewControllers][0] setTock:self.tock];
	[[[self viewControllers][1] viewControllers][0] setTock:self.tock];
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
