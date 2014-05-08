#import "TICKTock.h"
#import "BSDefines.h"

@implementation TICKTock
-(id) init{
	self = [super init];
	[super controlSetup];
	
	return self;
}
- (void)attachToTock{
	double timeout = 3;
    [self findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"BlueShield"];
		self.peripherals = [[self.peripherals filteredArrayUsingPredicate:predicate] mutableCopy];
		if ([self.peripherals count] < 1) {
//			UIAlertView *alert = [[UIAlertView alloc]
//								  
//								  initWithTitle:@"Couldn't find Tock"
//								  message:@"Make sure your Tock is nearby"
//								  delegate:nil
//								  cancelButtonTitle:@"What's a Tock?"
//								  otherButtonTitles:@"Try Again", nil];
//			
//			alert.delegate = self;
//			[alert show];
			
		}
		else{
			
			NSLog(@"%@",self.peripherals);
			self.activePeripheral = [self.peripherals objectAtIndex:0];
			
			[self connectPeripheral:self.activePeripheral];
			[self syncCurrentDateAndTime];
	
		}
	});
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
	[self sendBytes:message size:sizeof(message)];
	
}
- (void)resetToDefaults{
	unsigned char message[] = {RESET};
	[self sendBytes:message size:sizeof(message)];
}

//- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//	
//    if (buttonIndex == 1) {
//        [self reloadClicked:nil];
//    } else {
//        NSURL *url = [NSURL URLWithString:@"http://ticktock.nickswalker.com"];
//		[[UIApplication sharedApplication] openURL:url];
//    }
//}
@end
