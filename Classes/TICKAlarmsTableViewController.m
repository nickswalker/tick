#import "TICKAlarmsTableViewController.h"
#import "TICKAlarm.h"
#import "TICKAlarmDetailTableViewController.h"
#import "TICKAlarmTableViewCell.h"
#import "BSDefines.h"

@interface TICKAlarmsTableViewController ()

@end

@implementation TICKAlarmsTableViewController

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
- (void)viewWillAppear:(BOOL)animated
{
    [self setEditing:false animated:false];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	if (editing) {
		self.editButton.title = @"Done";
	}
	else {
		self.editButton.title = @"Edit";
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender{
	if (self.isEditing) {
		[self setEditing:NO animated:YES];
	}
	else {
		[self setEditing:YES animated:YES];
	}
	
}
#pragma mark - Table view data source
- (void)alarmDetailWasDismissed:(TICKAlarm *)alarm{
	
	NSMutableArray* temp = [self.tock.alarms mutableCopy];
	[temp addObject: alarm];
	self.tock.alarms = temp;
	[self.tableView reloadData];
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tock.alarms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TICKAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Alarm" forIndexPath:indexPath];
    cell.alarm = self.tock.alarms[indexPath.row];
    
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSMutableArray* temp = [self.tock.alarms mutableCopy];
		[temp removeObjectAtIndex:indexPath.row];
		self.tock.alarms = temp;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
    }
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(TICKAlarmTableViewCell*)sender
{
	UINavigationController* navigationController = (UINavigationController*)[segue destinationViewController];
	TICKAlarmDetailTableViewController* destinationViewController = (TICKAlarmDetailTableViewController*)[navigationController visibleViewController];
	
	if( [[segue identifier] isEqualToString:@"AddAlarm"]){
		destinationViewController.delegate = self;
		destinationViewController.alarm = [[TICKAlarm alloc] init];
		
		destinationViewController.title = @"Add Alarm";
		
	}
	else if([[segue identifier] isEqualToString:@"EditAlarm"]){
		destinationViewController.delegate = sender;
		destinationViewController.title = @"Edit Alarm";
		destinationViewController.alarm= sender.alarm;
	
	}
}


@end
