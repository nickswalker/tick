#import "TICKAlarmsTableViewController.h"
#import "TICKAlarm.h"
#import "TICKAlarmDetailTableViewController.h"
#import "TICKAlarmTableViewCell.h"
#import "BSDefines.h"

@interface TICKAlarmsTableViewController ()

@end

@implementation TICKAlarmsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* color = [[UIView alloc] init];
	color.backgroundColor = [UIColor colorWithRed:.933 green:.933 blue:.9531 alpha:1];
	[self.tableView setBackgroundView:color];
	
}
- (void)viewWillAppear:(BOOL)animated
{
    [self setEditing:false animated:false];
	[self.tableView reloadData];
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
#pragma Protocol Implementations

- (void)alarmDetailWasDismissed:(TICKAlarm *)alarm{
	
	[self.tock sendAlarm: alarm number: [self.tock firstEmptyAlarm]];
	//[self.tock fetchAlarms];
	[self.tableView reloadData];
	
}
- (void) alarmWasEdited:(TICKAlarm*)alarm inCell:(UITableViewCell *)cell{
	UITableView* table = (UITableView *)[cell superview];
	NSIndexPath* indexPath = [table indexPathForCell:cell];
	[self.tock sendAlarm:alarm number:indexPath.row+1];
	[self.tableView reloadData];
	
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Change the selected background view of the cell.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tock numberOfAlarms];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TICKAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Alarm" forIndexPath:indexPath];

    cell.alarm = (TICKAlarm*)[self.tock.alarms objectForKey:[NSNumber numberWithInt:(indexPath.row+1)]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[self.tock clearAlarm:indexPath.row+1];
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
