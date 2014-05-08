#import "TICKAlarmDetailTableViewController.h"
#import "TICKAlarm.h"
#import "TICKRepeatDetailTableViewController.h"

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

-(void) viewWillAppear:(BOOL)animated{
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
- (IBAction)save:(id)sender{
	[self.delegate alarmDetailWasDismissed:self.alarm];
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)dateChanged:(UIDatePicker*)sender{
	NSDate *date = [sender date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
	self.alarm.hour = [components hour];
	self.alarm.minute = [components minute];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	TICKRepeatDetailTableViewController* destinationViewController = (TICKRepeatDetailTableViewController*)[segue destinationViewController];

	if([[segue identifier] isEqualToString:@"EditRepeat"]){
		destinationViewController.alarm= self.alarm;
		
	}
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
