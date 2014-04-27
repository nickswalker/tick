#import "TICKAlarmsViewController.h"
#import "TICKAlarm.h"

@interface TICKAlarmsViewController ()

@end

@implementation TICKAlarmsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		self.tableView.separatorColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* color = [[UIView alloc] init];
	color.backgroundColor = [UIColor colorWithRed:.933 green:.933 blue:.9531 alpha:1];
	[self.tableView setBackgroundView:color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender{
	if ([self.tableView isEditing]) {
		// If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
		[self.tableView setEditing:NO animated:YES];
		self.editButton.title = @"Edit";
	}
	else {
		[self.tableView setEditing:YES animated:YES];
		self.editButton.title = @"Done";
	}

	
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.alarms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Alarm" forIndexPath:indexPath];
    
	TICKAlarm *alarm = (self.alarms)[indexPath.row];
	UISwitch *activatedSwitch = (UISwitch *) [cell viewWithTag:3];
	UILabel *time = (UILabel *)[cell viewWithTag:1];
	UILabel *repeatSchedule = (UILabel *)[cell viewWithTag:2];
	
	time.text= [NSString stringWithFormat:@"%d:%d", alarm.hour, alarm.minute ];
	repeatSchedule.text = [alarm getStringRepresentationOfRepeatSchedule];
	activatedSwitch.on = [alarm isActivated];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
