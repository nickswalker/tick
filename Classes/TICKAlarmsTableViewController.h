#import <UIKit/UIKit.h>
#import "TICKTock.h"
#import "TICKAlarmDetailTableViewController.h"

@class TICKTock;

@interface TICKAlarmsTableViewController : UITableViewController

@property TICKTock* tock;
@property NSArray *alarms;
@property IBOutlet UIBarButtonItem* editButton;


- (IBAction)editButtonPressed:(UIBarButtonItem*)sender;




@end
