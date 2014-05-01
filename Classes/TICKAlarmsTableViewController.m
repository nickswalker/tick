#import "TICKAlarmsTableViewController.h"
#import "TICKAlarm.h"
#import "TICKAlarmDetailTableViewController.h"
#import "TICKAlarmTableViewCell.h"
#import "BSDefines.h"

@interface TICKAlarmsTableViewController ()

@end

@implementation TICKAlarmsTableViewController
@synthesize alarms = _alarms;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.tock didUpdateValueBlock:^(NSData *data, NSError *error) {
			//NSString *recv = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			//this.
		}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* color = [[UIView alloc] init];
	color.backgroundColor = [UIColor colorWithRed:.933 green:.933 blue:.9531 alpha:1];
	[self.tableView setBackgroundView:color];
	
	[self.tock syncCurrentDateAndTime];
	
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
	unsigned char message[2] = {GETALARM,1};
	[self.tock sendBytes:message size:2];
	
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.alarms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TICKAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Alarm" forIndexPath:indexPath];
    cell.alarm = self.alarms[1];
    
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


- (NSArray*) alarms{
	return _alarms;
}

- (void) setAlarms:(NSArray *)alarms{
	_alarms = alarms;
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(TICKAlarmTableViewCell*)sender
{
	UINavigationController* navigationController = (UINavigationController*)[segue destinationViewController];
	TICKAlarmDetailTableViewController* destinationViewController = (TICKAlarmDetailTableViewController*)[navigationController visibleViewController];
	destinationViewController.delegate = sender;
	if( [[segue identifier] isEqualToString:@"AddAlarm"]){

		
	}
	else if([[segue identifier] isEqualToString:@"EditAlarm"]){
		destinationViewController.alarm= sender.alarm;
		NSLog(@"%@", sender);
		NSLog(@"%@", sender.alarm);
	
	}
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
