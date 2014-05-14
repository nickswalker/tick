#import "TICKTock.h"
#import "BSDefines.h"
#import "TICKAlarm.h"
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif

@implementation TICKTock
-(id) init{
	self = [super init];
	[super controlSetup];
	alarm_t test;
	test.hour = 15;
	test.minute = 30;
	test.repeatSchedule = 0b10011110;
	NSMutableArray* alarms = [[NSMutableArray alloc] init];
	TICKAlarm* tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	
	test.repeatSchedule = 0b10111110;
	tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	test.repeatSchedule = 0b11111111;
	tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	
	test.repeatSchedule = 0b10110111;
	tempAlarm = [[TICKAlarm alloc] initWithBinary:test];
	[alarms addObject:tempAlarm];
	self.alarms = alarms;
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
			UIAlertView *alert = [[UIAlertView alloc]
								  
								  initWithTitle:@"Couldn't find Tock"
								  message:@"Make sure your Tock is nearby"
								  delegate:nil
								  cancelButtonTitle:@"What's a Tock?"
								  otherButtonTitles:@"Try Again", nil];
			
			//alert.delegate = self;
			[alert show];
			
		}
		else{
			
			NSLog(@"%@",self.peripherals);
			self.activePeripheral = [self.peripherals objectAtIndex:0];
			
			[self connectPeripheral:self.activePeripheral];
			[self syncCurrentDateAndTime];
			[self didDiscoverCharacteristicsBlock:^(id response, NSError *error) {
				double delayInSeconds = 3.0;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					[self notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
					   characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
									 p: self.activePeripheral
									   on:YES];
					
					[self didUpdateValueBlock:^(NSData *data, NSError *error) {
						[self processCommand:data error:error];
					}];
				});
			}];
	
		}
	});
}
-(void)detachFromTock{
	//[self disconnectPeripheral];
}

#pragma Send UART Data

- (void)sendText:(NSString*)string {
	
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [self writeValue:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
  characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_TX_UUID]
				   p: self.activePeripheral
				data:data];
}

- (void)sendBytes:(unsigned char *)message size:(size_t)size {
	NSLog(@"Sent");
	for(int i = 0; i < size ; i++){
		NSLog(@"%d: %hhd", i, message[i]);
	}
    NSData *data = [NSData dataWithBytes:message length:size];
    [self writeValue:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
  characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_TX_UUID]
				   p: self.activePeripheral
				data:data];
}



- (void)processCommand: (NSData*)message error:(NSError*) error{
	uint8_t *byteData = (uint8_t*)malloc(message.length);
	memcpy(byteData, [message bytes], message.length);
	NSLog(@"Message Recieved");
	for(int i = 0; i < sizeof(byteData) ; i++){
		NSLog(@"%d: %hhd", i, byteData[i]);
	}
}

#pragma Commands
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

- (void)fetchAlarm:(int)alarmNumber{
	unsigned char message[]  = {GETALARM, alarmNumber};
	[self sendBytes:message size:sizeof(message)];
	
}

-(void)sendColor:(uint8_t)r green:(int8_t)g blue:(uint8_t)b{

	unsigned char message[] = {SETLIGHTCOLOR, r, g, b};
	[self sendBytes:message size:sizeof(message)];
}

-(void)sendSetting:(Option)option value:(uint8_t)value{
	unsigned char byte1 = value;
	unsigned char message[] = {SETSETTING, option, byte1};
	[self sendBytes:message size:sizeof(message)];
}
@end
