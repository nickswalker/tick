#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "TICKTock.h"

@class TICKTock;

@interface TICKTabBarViewController : UITabBarController <UITabBarControllerDelegate, MBProgressHUDDelegate, TICKTockDelegate>

@property TICKTock* tock;
@property MBProgressHUD* HUD;

@end
