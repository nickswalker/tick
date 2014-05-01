#import <UIKit/UIKit.h>
#import "TICKAlarmDetailTableViewController.h"

@class TICKAlarm;

@interface TICKAlarmTableViewCell : UITableViewCell <AlarmCreation>

@property TICKAlarm* alarm;
@property IBOutlet UISwitch* activationSwitch;
@property IBOutlet UILabel* timeLabel;
@property IBOutlet UILabel* repeatScheduleLabel;

- (IBAction)toggledActivation:(UISwitch*)sender;

@end
