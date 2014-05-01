#import "TICKAlarmDetailTableViewController.h"
#import "TICKAlarm.h"

@interface TICKAlarmDetailTableViewController ()

@end

@implementation TICKAlarmDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
	NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: [NSDate date]];
	[components setHour: self.alarm.hour];
	[components setMinute: self.alarm.minute];
	
	NSDate *newDate = [gregorian dateFromComponents: components];
	
	self.datePicker.date = newDate;
	UILabel* detail = self.repeatSchedule.contentView.subviews[1];
	detail.text= self.alarm.getStringRepresentationOfRepeatSchedule;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
