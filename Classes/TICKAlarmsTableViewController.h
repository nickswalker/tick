#import <UIKit/UIKit.h>
#import "TICKTock.h"
#import "TICKAlarmDetailTableViewController.h"

@class TICKTock;

@interface TICKAlarmsTableViewController : UITableViewController <AlarmCreation>

@property TICKTock* tock;
@property NSArray *alarms;
@property IBOutlet UIBarButtonItem* editButton;

- (void)alarmDetailWasDismissed:(TICKAlarm *)alarm;
- (IBAction)editButtonPressed:(UIBarButtonItem*)sender;




@end
