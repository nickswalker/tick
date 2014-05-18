#import "BlueShield.h"
#import "BSDefines.h"

@class TICKAlarm;

@interface TICKTock : BlueShield

@property NSMutableDictionary* alarms;

-(void)attachToTock;
-(void)detachFromTock;
-(void)syncCurrentDateAndTime;
-(void)resetToDefaults;

-(void)fetchAlarm:(int)alarmNumber;
-(void)fetchAlarms;
-(void)sendAlarm:(TICKAlarm*)alarm number:(int)alarmNumber;
-(void)clearAlarm:(int)alarmNumber;
-(int)numberOfAlarms;
-(int)firstEmptyAlarm;

-(void)sendColor:(uint8_t)r green:(int8_t)g blue:(uint8_t)b;
-(void)sendSetting:(Option)option value:(uint8_t)value;
-(void)testConnection;

@end
