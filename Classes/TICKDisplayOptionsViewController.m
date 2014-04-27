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
    // Do any additional setup after loading the view.
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

-(IBAction)sliderSettingChanged:(UISlider*)sender{
	if (sender == [self brightness])
		[self sendSetting:BRIGHTNESS value:(char)[sender value]];
	
	
}
- (IBAction)reloadClicked:(id)sender {
 
}
-(void)sendSetting:(Option)option value:(unsigned char)value{
	unsigned char byte1 = value;
	unsigned char message[] = {SETSETTING, option, byte1};
	[self.tock sendBytes:message size:sizeof(message)];
}

-(void)retrieveSetting:(Option)option value:(BOOL)value{
	
}

@end
