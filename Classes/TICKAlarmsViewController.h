#import <UIKit/UIKit.h>
#import "TICKTock.h"

@class TICKTock;

@interface TICKAlarmsViewController : UITableViewController

@property TICKTock* tock;
@property NSMutableArray *alarms;
@property IBOutlet UIBarButtonItem* editButton;

- (IBAction)editButtonPressed:(UIBarButtonItem*)sender;

@end
