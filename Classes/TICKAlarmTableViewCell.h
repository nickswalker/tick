#import <UIKit/UIKit.h>
#import "TICKAlarmDetailTableViewController.h"

@class TICKAlarm;

@protocol AlarmEditing <NSObject>
-(void) alarmWasEdited:(TICKAlarm*)alarm inCell:(UITableViewCell*)cell;
@end

@interface TICKAlarmTableViewCell : UITableViewCell <AlarmCreation>

@property id<AlarmEditing> delegate;
@property TICKAlarm* alarm;
@property IBOutlet UISwitch* activationSwitch;
@property IBOutlet UILabel* timeLabel;
@property IBOutlet UILabel* repeatScheduleLabel;

- (IBAction)toggledActivation:(UISwitch*)sender;

@end
