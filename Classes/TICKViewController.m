#import "TICKViewController.h"
#import "TICKDebugConsoleViewController.h"
#import "TICKDisplayOptionsViewController.h"
#import "BlueShield.h"
#import "BSDefines.h"

typedef enum{
	SETDATE = 1,
	SETTIME = 2,
	SETLIGHTCOLOR = 3,
	GETLIGHTCOLOR = 4,
	SETALARM = 5,
	GETALARM = 6,
	SETSETTING = 7,
	GETSETTING = 8,
	TESTCONNECTION =255
} Command;

@interface TICKViewController ()

@end

@implementation TICKViewController 

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (buttonIndex == 0) {
        [self reloadClicked:self];
    } else {
        NSURL *url = [NSURL URLWithString:@"http://nickswalker.com"];
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
- (IBAction)sliderValueChanged:(UISlider *)sender {
	int r = (char)self.rSlider.value;
	int g = (char)self.gSlider.value;
	int b = (char)self.bSlider.value;
	const char message[] = {SETLIGHTCOLOR, r, g, b};
	
	[self.shield sendBytes:message];
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
	NSDate *localDate = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	dateFormatter.dateFormat = @"s";
	
	NSString *dateString = [dateFormatter stringFromDate: localDate];
	time_t time_t = [[NSDate date] timeIntervalSince1970];
	NSLog(@"@%ld", time_t);
	char byte1 = (time_t >> 24) & 0xFF;
	char byte2 = (time_t >> 16) & 0xFF;
	char byte3 = (time_t >> 8) & 0xFF;
	char byte4 = (time_t >> 0) & 0xFF;
	
	const char message[]  = {SETTIME, byte1, byte2, byte3, byte4};
	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
	timeFormatter.dateFormat = @"HH:mm:ss";
	
	
	NSString *timeString = [timeFormatter stringFromDate: localDate];
	
	
	[self.shield sendBytes:message];
	

}

@end
