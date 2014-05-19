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
	self.alarms = [[NSMutableDictionary alloc] init];
	self.settings = [[NSMutableDictionary alloc] init];

	[super controlSetup];
	return self;
}

- (void)attachToTock{
	
	double timeout = 1;
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
			
			[self didDiscoverCharacteristicsBlock:^(CBUUID* response, NSError *error) {
				NSString* UUID = response.UUIDString;
				if ([UUID isEqual: BS_SERIAL_SERVICE_UUID]){
					
				
					dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
					dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
						[self notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
						   characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
										 p: self.activePeripheral
										   on:YES];
						[self syncCurrentDateAndTime];
						[self fetchAlarms];
						dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
							[self fetchSettings];
							NSLog(@"Yo");
						});
						
						
						
						[self didUpdateValueBlock:^(NSData *data, NSError *error) {
							[self processCommand:data error:error];
						}];
					});
				}
			}];
	
		}
	});
}
-(void)detachFromTock{
	[self.cm cancelPeripheralConnection:self.activePeripheral];
}

#pragma mark Send UART Data

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
	uint8_t *byteData = (uint8_t*)malloc((int)message.length);
	memcpy(byteData, [message bytes], (int)message.length);
	NSLog(@"Message Recieved");
	for(int i = 0; i < message.length ; i++){
		NSLog(@"%d: %hhd", i, byteData[i]);
	}
	switch ( (Command)byteData[0] ) {
		case GETALARM:{
			int alarm = [self fourBytesToInt:byteData[2] byte2:byteData[3] byte3:byteData[4] byte4:byteData[5]];
			[self.alarms setObject:[[TICKAlarm alloc] initWithInt:alarm] forKey: [NSNumber numberWithInt:byteData[1]] ];
		}
		case GETSETTING:{
			[self.settings setObject:[NSNumber numberWithInt: byteData[2]] forKey:[NSNumber numberWithInt: byteData[1]]];
		}
			break;
		
		default:
			break;
	}
}

#pragma mark Commands
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
- (void)fetchAlarmWithNumber:(NSNumber*)alarmNumber{
	[self fetchAlarm:alarmNumber.intValue];
	
}
- (void)fetchAlarm:(int)alarmNumber{
	unsigned char message[]  = {GETALARM, alarmNumber};
	[self sendBytes:message size:sizeof(message)];
	
}
- (void)fetchAlarms{
	for (int i = 1; i<9; i++) {
		[self performSelector:@selector(fetchAlarmWithNumber:) withObject:[NSNumber numberWithInt:i ] afterDelay:i*.3];
		
	}
}
- (void)sendAlarm:(TICKAlarm*)alarm number:(int)alarmNumber{
	
	[self.alarms setObject:alarm forKey: [NSNumber numberWithInt:alarmNumber] ];
	NSLog(@"%@",alarm);
	uint8_t bytes[4];
	[self intToFourBytes:[alarm getIntRepresentation] buffer:bytes];
	uint8_t message[] = {SETALARM, alarmNumber, bytes[0], bytes[1], alarm.binaryRepresentation.repeatSchedule, bytes[3]};
	[self sendBytes:message size:sizeof(message)];
}
- (void)clearAlarm:(int)alarmNumber{
	TICKAlarm* alarm = [[TICKAlarm alloc] initWithInt:0];
	[self sendAlarm:alarm number:alarmNumber];
}
- (int)numberOfAlarms{
	int number = 0;
	for(id key in self.alarms) {
		TICKAlarm *alarm = (TICKAlarm*)[self.alarms objectForKey:key];
		if (alarm.getIntRepresentation != 0)
			number++;
	}
	return number;
}
- (int)firstEmptyAlarm{
	for (int i = 1; i < 10; i++) {
		TICKAlarm *alarm = (TICKAlarm*)[self.alarms objectForKey:[NSNumber numberWithInt:i]];
		if (alarm.getIntRepresentation == 0)
			return i;
		
	}
	return 9;
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
-(void)testConnection{
	unsigned char message[] = {TESTCONNECTION};
	[self sendBytes:message size:sizeof(message)];
}
-(void)fetchSettings{
	for (int i = 0; i < 5; i++) {
		[self performSelector:@selector(fetchSettingWithNumber:) withObject:[NSNumber numberWithInt:i ] afterDelay:i*.3];
	}

}
-(void)fetchSettingWithNumber:(NSNumber*)number{
	unsigned char message[] = {GETSETTING, number.intValue};
	[self sendBytes:message size:sizeof(message)];
}
#pragma mark Bitpacking Utilities

//Little endian: Least significant byte first
-(uint32_t)fourBytesToInt:(uint8_t[]) bytes{
	return  (uint32_t)bytes[0] + ((uint32_t)bytes[1] << 8) + ((uint32_t)bytes[2] << 16) + ((uint32_t)bytes[3] << 24);
}
-(uint32_t)fourBytesToInt:(uint8_t) byte1 byte2:(uint8_t) byte2 byte3:(uint8_t) byte3 byte4:(uint8_t) byte4{
	uint8_t bytes[] = {byte1,byte2,byte3,byte4};
	return  [self fourBytesToInt:bytes];
}

-(BOOL)intToFourBytes:(uint32_t)integer buffer:(uint8_t[]) bytes{
	bytes[0] = (integer >> 0);
	bytes[1] = (integer >> 8);
	bytes[2] = (integer >> 16);
	bytes[3] = (integer >> 24);
	
	return true;
}
@end
