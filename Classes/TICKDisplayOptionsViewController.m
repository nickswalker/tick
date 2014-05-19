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

}

- (void)viewWillAppear:(BOOL)animated{
	[self configureViewFromModel];
}

-(void)configureViewFromModel{
	NSNumber* twentyFourHourTime = [self.tock.settings objectForKey:[NSNumber numberWithInt:DISPLAYTWENTYFOURHOURTIME]];
	self.displayTwentyFourHourTime.on = twentyFourHourTime.boolValue;
	
	NSNumber* blinkColon = [self.tock.settings objectForKey:[NSNumber numberWithInt:BLINKCOLON]];
	self.blinkColon.on= blinkColon.boolValue;
	
	NSNumber* brightnessValue = [self.tock.settings objectForKey:[NSNumber numberWithInt:BRIGHTNESS]];
	self.brightness.value = brightnessValue.floatValue;
	NSNumber* autoBrightnessValue = [self.tock.settings objectForKey:[NSNumber numberWithInt:AUTOBRIGHTNESS]];
	self.autoBrightness.on = autoBrightnessValue.boolValue;
	
	
	if (!self.autoBrightness.isOn)
		self.brightness.enabled = true;
	else self.brightness.enabled = false;
	
}

-(IBAction)settingChanged:(UISwitch*)sender{
	if (sender == [self displayTwentyFourHourTime])
		[self.tock sendSetting:DISPLAYTWENTYFOURHOURTIME value:(char)[sender isOn]];
	if (sender == [self blinkColon])
		[self.tock sendSetting:BLINKCOLON value:(char)sender.isOn];
	if (sender == [self autoBrightness]){
		[self.tock sendSetting:AUTOBRIGHTNESS value:(char)sender.isOn];
		self.brightness.enabled = !sender.isOn;
	}
	
}

-(void)reset:(id)sender{
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                      message:@"This will erase all customizations."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Reset", nil];
	
    [message show];
}

-(IBAction)sliderSettingChanged:(UISlider*)sender{
	if (sender == [self brightness])
		[self.tock sendSetting:BRIGHTNESS value:(char)[sender value]];
	
	
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[self.tock resetToDefaults];
	}
}
- (IBAction)reloadClicked:(id)sender {
	[self.tock detachFromTock];
	[self.tock attachToTock];
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
