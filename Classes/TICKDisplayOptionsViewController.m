#import "TICKDisplayOptionsViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "TICKTock.h"
#import "BSDefines.h"


@interface TICKDisplayOptionsViewController ()

@end

@implementation TICKDisplayOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIView* color = [[UIView alloc] init];
	color.backgroundColor = [UIColor colorWithRed:.933 green:.933 blue:.9531 alpha:1];
	[self.tableView setBackgroundView:color];
	if (self.autoBrightness.isOn)
		self.brightness.enabled = true;
}


-(IBAction)settingChanged:(UISwitch*)sender{
	if (sender == [self displayTwentyFourHourTime])
		[self sendSetting:DISPLAYTWENTYFOURHOURTIME value:(char)[sender isOn]];
	if (sender == [self blinkColon])
		[self sendSetting:BLINKCOLON value:(char)sender.isOn];
	if (sender == [self louderAlarm])
		[self sendSetting:LOUDERALARM value:(char)sender.isOn];
	if (sender == [self debugMode])
		[self sendSetting:DEBUGMODE value:(char)sender.isOn];
	if (sender == [self autoBrightness]){
		[self sendSetting:AUTOBRIGHTNESS value:(char)sender.isOn];
		self.brightness.enabled = !sender.isOn;
	}
	
}

-(void)reset:(id)sender{
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
                                                      message:@"Are you sure? This will erase all customizations."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
	
    [message show];
}

-(IBAction)sliderSettingChanged:(UISlider*)sender{
	if (sender == [self brightness])
		[self sendSetting:BRIGHTNESS value:(char)[sender value]];
	
	
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[self.tock resetToDefaults];
	}
}
- (IBAction)reloadClicked:(id)sender {
	//[self.tock detachFromTock];
	//[self.tock attachToTock];
	[self.tock fetchAlarm:0];
}
-(void)sendSetting:(Option)option value:(unsigned char)value{
	[self sendSetting:option value:value];
}

-(void)retrieveSetting:(Option)option value:(BOOL)value{
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 1 && indexPath.row == 0){
		[self reset:nil];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
