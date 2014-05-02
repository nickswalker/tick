#import "TICKRepeatDetailTableViewController.h"
#import "TICKAlarm.h"

@interface TICKRepeatDetailTableViewController ()

@end

@implementation TICKRepeatDetailTableViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if([self.alarm repeatsForDayOfWeek:(DayOfWeek)indexPath.row]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[self.alarm setRepeatForDayOfWeek:(DayOfWeek)indexPath.row withValue:true];
	}
	else {
		
	cell.accessoryType = UITableViewCellAccessoryNone;
		[self.alarm setRepeatForDayOfWeek:(DayOfWeek)indexPath.row withValue:false];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}


@end
