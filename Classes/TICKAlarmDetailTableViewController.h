#import <UIKit/UIKit.h>

@class TICKAlarm;

@protocol AlarmCreation <NSObject>
-(void) alarmDetailWasDismissed:(TICKAlarm*)alarm;
@end

@interface TICKAlarmDetailTableViewController : UITableViewController

@property id<AlarmCreation> delegate;
@property TICKAlarm* alarm;
@property IBOutlet UIDatePicker* datePicker;
@property IBOutlet UITableViewCell* repeatSchedule;

- (IBAction)cancel:(id)sender;

@end
