#import "TICKViewController.h"
#import "TICKDebugConsoleViewController.h"
#import "TICKDisplayOptionsViewController.h"
#import "BlueShield.h"
#import "BSDefines.h"

typedef enum{
	SETDATE = 1,
	SETTIME = 2,
	SETLIGHTCOLOR = 3,
	SETALARM = 4,
	SETSETTING = 5,
	GETSETTING = 6
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
	
    if (buttonIndex == 2) {
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
			[_shield didDiscoverCharacteristicsBlock:^(id response, NSError *error) {
				double delayInSeconds = 3.0;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					[_shield notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
					   characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
										p:_peripheral
									   on:YES];
					
									
					[_shield didUpdateValueBlock:^(NSData *data, NSError *error) {
						NSString *recv = [[NSString alloc] initWithData:data
															   encoding:NSUTF8StringEncoding];
						
						
					}];
				});
			}];
		}


    });
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
	int r = (char)self.rSlider.value;
	int g = (char)self.gSlider.value;
	int b = (char)self.bSlider.value;
	const char message[] = {SETLIGHTCOLOR, r, g, b};
	
	[self sendBytes:message];
}

#pragma mark - custom method

- (void)sendTx:(NSString*)string {
	NSLog(string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [_shield writeValue:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
     characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_TX_UUID]
                      p:_peripheral
                   data:data];
}

- (void)sendBytes:(const void *)message {
//	for (int i = 0; i < sizeof(message); i++) {
//		printf("%x",&message[i]);
//	}
    NSData *data = [NSData dataWithBytes:message length:sizeof(message)];
    [_shield writeValue:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
     characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_TX_UUID]
                      p:_peripheral
                   data:data];
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
	dateFormatter.dateFormat = @"dd MM yyyy";
	
	NSString *dateString = [dateFormatter stringFromDate: localDate];
	
	
	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
	timeFormatter.dateFormat = @"HH:mm:ss";
	
	
	NSString *timeString = [timeFormatter stringFromDate: localDate];
	
	[self sendTx:[@"TI:" stringByAppendingString: timeString]];
	//[self sendTx:[@"DA+" stringByAppendingString: dateString]];

}

@end
