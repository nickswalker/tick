#import "TICKColorViewController.h"
#import "TICKDebugConsoleViewController.h"
#import "TICKDisplayOptionsViewController.h"
#import "BlueShield.h"
#import "BSDefines.h"



@interface TICKColorViewController ()

@end

@implementation TICKColorViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
	_shield = [[BlueShield alloc] init];
    [_shield controlSetup];
    
    [_shield didPowerOnBlock:^(id response, NSError *error) {
        [self reloadClicked:nil];
		
    }];
	   
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (buttonIndex == 1) {
        [self reloadClicked:nil];
    } else {
        NSURL *url = [NSURL URLWithString:@"http://ticktock.nickswalker.com"];
		[[UIApplication sharedApplication] openURL:url];
    }
}
- (IBAction)reloadClicked:(id)sender {
    double timeout = 3;
    [_shield findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"BlueShield"];
		_shield.peripherals = [[_shield.peripherals filteredArrayUsingPredicate:predicate] mutableCopy];
		if ([_shield.peripherals count] < 1) {
			UIAlertView *alert = [[UIAlertView alloc]
								  
								  initWithTitle:@"Couldn't find Tock"
								  message:@"Make sure your Tock is nearby"
								  delegate:nil
								  cancelButtonTitle:@"What's a Tock?"
								  otherButtonTitles:@"Try Again", nil];
			
			alert.delegate = self;
			[alert show];
			
		}
		else{
			
			NSLog(@"%@",_shield.peripherals);
			self.peripheral = [_shield.peripherals objectAtIndex:0];
			
			[_shield connectPeripheral:_peripheral];
			[self syncCurrentDateAndTime];

		}


    });
}



- (IBAction)updateColorCell:(UISlider *)sender {
	float r = self.rSlider.value/255;
	float g = self.gSlider.value/255;
	float b = self.bSlider.value/255;

	[self.colorCell setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:1]];
}
- (IBAction)sendColorToTock:(UISlider *)sender {
	unsigned char r = (char)self.rSlider.value;
	unsigned char g = (char)self.gSlider.value;
	unsigned char b = (char)self.bSlider.value;
	unsigned char message[] = {SETLIGHTCOLOR, r, g, b};
	
	[self.shield sendBytes:message size:sizeof(message)];
}
- (IBAction)refresh:(id)sender{
	[self syncCurrentDateAndTime];
}

#pragma mark - UITextFieldDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        [[segue destinationViewController] setShield:self.shield andPeripheral: self.peripheral];
    }
}

- (void)syncCurrentDateAndTime
{
	//In GMT
	time_t time_t = [[NSDate date] timeIntervalSince1970];
	
	//Now in iPhone-local time zone/DST
	time_t += [[NSTimeZone systemTimeZone] secondsFromGMT];

	unsigned char byte1 = (time_t >> 0);
	unsigned char byte2 = (time_t >> 8);
	unsigned char byte3 = (time_t >> 16);
	unsigned char byte4 = (time_t >> 24);
	
	unsigned char message[]  = {SETTIME, byte1, byte2, byte3, byte4};
	[self.shield sendBytes:message size:sizeof(message)];

}

@end
