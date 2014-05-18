#import <UIKit/UIKit.h>
#import "TICKTock.h"
#import "TICKAlarmDetailTableViewController.h"
#import "TICKAlarmTableViewCell.h"

@class TICKTock;

@interface TICKAlarmsTableViewController : UITableViewController <AlarmCreation, AlarmEditing>

@property TICKTock* tock;

@property IBOutlet UIBarButtonItem* editButton;

- (void)alarmDetailWasDismissed:(TICKAlarm *)alarm;
- (IBAction)editButtonPressed:(UIBarButtonItem*)sender;

@end
