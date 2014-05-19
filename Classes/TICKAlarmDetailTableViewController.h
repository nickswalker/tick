#import <UIKit/UIKit.h>
#import "TICKRepeatDetailTableViewController.h"

@class TICKAlarm;

@protocol AlarmCreation <NSObject>
-(void) alarmDetailWasDismissed:(TICKAlarm*)alarm;
@end

@interface TICKAlarmDetailTableViewController : UITableViewController

@property id<AlarmCreation> delegate;
@property TICKAlarm* alarm;
@property IBOutlet UIDatePicker* datePicker;
@property IBOutlet UITableViewCell* repeatSchedule;
@property IBOutlet UITableViewCell* deleteCell;
@property BOOL isInEditMode;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)dateChanged:(id)sender;

@end
