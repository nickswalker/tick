#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BSDefines.h"

@class TICKTock;

@interface TICKDisplayOptionsViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) TICKTock *tock;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property IBOutlet UISwitch *displayTwentyFourHourTime;
@property IBOutlet UISwitch *blinkColon;
@property IBOutlet UISwitch *autoBrightness;
@property IBOutlet UISlider *brightness;

-(IBAction)sliderSettingChanged:(UISlider*)sender;
-(IBAction)settingChanged:(UISwitch*)sender;
-(void)reset:(id)sender;


@end
