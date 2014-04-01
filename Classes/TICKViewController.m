#import "TICKViewController.h"
#import "TICKDebugConsoleViewController.h"
#import "TICKDisplayOptionsViewController.h"
#import "BlueShield.h"
#import "BSDefines.h"

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


- (IBAction)reloadClicked:(id)sender {
    double timeout = 3;
    [_shield findBLEPeripherals:timeout];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"BlueShield"];
		_shield.peripherals = [[_shield.peripherals filteredArrayUsingPredicate:predicate] mutableCopy];
		NSLog(@"%@",_shield.peripherals);
		self.peripheral = [_shield.peripherals objectAtIndex:0];
		
		[_shield connectPeripheral:_peripheral];
		
		[_shield didDiscoverCharacteristicsBlock:^(id response, NSError *error) {
			double delayInSeconds = 3.0;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				[_shield notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
				   characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
									p:_peripheral
								   on:YES];
				
				NSDate *localDate = [NSDate date];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
				dateFormatter.dateFormat = @"dd MM yyyy";
				
				NSString *dateString = [dateFormatter stringFromDate: localDate];
				
				
				
				NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
				timeFormatter.dateFormat = @"HH:mm:ss";
				
				
				NSString *timeString = [timeFormatter stringFromDate: localDate];
				
				[self sendTx:[@"TI:" stringByAppendingString: timeString]];
				//[self sendTx:[@"DA+" stringByAppendingString: dateString]];
				
				[_shield didUpdateValueBlock:^(NSData *data, NSError *error) {
					NSString *recv = [[NSString alloc] initWithData:data
														   encoding:NSUTF8StringEncoding];
					
					
				}];
			});
		}];

    });
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
	int r = (int)self.rSlider.value;
	int g = (int)self.gSlider.value;
	int b = (int)self.bSlider.value;
	
	char redStr[20];
	char greenStr[20];
	char blueStr[20];
	sprintf(redStr,"%02x", r);
	sprintf(blueStr,"%02x", b);
	sprintf(greenStr,"%02x", g);
	
	[self sendTx:[NSString stringWithFormat: @"L:%s%s%s", redStr, greenStr, blueStr]];
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

#pragma mark - UITextFieldDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        [[segue destinationViewController] setShield:self.shield andPeripheral: self.peripheral];
    }
}

@end
