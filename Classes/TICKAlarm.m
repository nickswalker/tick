#import "TICKAlarm.h"


@implementation TICKAlarm
@synthesize repeatSchedule = _repeatSchedule,
			binaryRepresentation = _binaryRepresentation;

- (id)init
{
    self = [super init];
    if (self)
    {
		NSDate *date = [NSDate date];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];

		_binaryRepresentation.hour = [components hour];
		_binaryRepresentation.minute = [components minute];
		_binaryRepresentation.repeatSchedule = 0b10000000;
		
    }
    return self;
}
- (id)initWithBinary: (alarm_t) alarm
{
    self = [super init];
    if (self)
    {
        _binaryRepresentation = alarm;
    }
    return self;
}
- (id)initWithInt: (uint32_t) integer
{
	uint8_t bytes[4];
	[self intToFourBytes:integer buffer:bytes];
	alarm_t alarm;
	alarm.minute=bytes[0];
	alarm.hour=bytes[1];
	alarm.repeatSchedule=bytes[2];
	
	return [self initWithBinary:alarm];
}

- (BOOL) repeatsForDayOfWeek: (DayOfWeek) dayOfWeek{
	return [[self.repeatSchedule objectAtIndex:dayOfWeek] boolValue];
}

- (void) setRepeatForDayOfWeek:(DayOfWeek) dayOfWeek withValue:(BOOL) value{
	uint8_t tempRepeatSchedule = self.binaryRepresentation.repeatSchedule;
	int numberOfPlacesToShift = 6-dayOfWeek;
	tempRepeatSchedule &= ~(1 << numberOfPlacesToShift);
	tempRepeatSchedule |= (value << numberOfPlacesToShift);
	alarm_t tempAlarm;
	tempAlarm.repeatSchedule = tempRepeatSchedule;
	tempAlarm.hour = self.binaryRepresentation.hour;
	tempAlarm.minute = self.binaryRepresentation.minute;
	_binaryRepresentation= tempAlarm;
	
}

- (NSString*) getStringRepresentationOfRepeatSchedule{
	NSString* temp = @"";
	bool rs[7];
	for (int i = 0; i<7; i++) {
		if ([self.repeatSchedule[i] isEqual:@1]) rs[i] = true;
		else rs[i] = false;
	}
	
	if(rs[0])temp =[temp stringByAppendingString:@"Sun "];
	if(rs[1]) temp =[temp stringByAppendingString:@"Mon "];
	if(rs[2]) temp =[temp stringByAppendingString:@"Tues "];
	if(rs[3]) temp =[temp stringByAppendingString:@"Wed "];
	if(rs[4]) temp =[temp stringByAppendingString:@"Thurs "];
	if(rs[5]) temp =[temp stringByAppendingString:@"Fri "];
	if(rs[6]) temp =[temp stringByAppendingString:@"Sat "];
	
	if(rs[0] && rs[6] && !(rs[1] || rs[2] || rs[3] || rs [4] || rs[5])) temp = @"Weekends";
	if((rs[1] && rs[2] && rs[3] && rs[4] && rs[5]) && !(rs[0] || rs[6]) ) temp = @"Weekdays";
	if(rs[1] && rs[2] && rs[3] && rs[4] && rs[5] && rs[0] && rs[6] ) temp = @"Every day";
	if(!rs[1] && !rs[2] && !rs[3] && !rs[4] && !rs[5] && !rs[0] && !rs[6] ) temp =@"Never";
	return temp;
}


- (NSArray*) repeatSchedule{
	NSArray* tempArray = [[NSArray alloc] init];
	NSNumber* tempBool;
	for(int i =0; i<7; i++){
		int placesToShift =6-i;
		tempBool =  [NSNumber numberWithBool:((self.binaryRepresentation.repeatSchedule >> placesToShift) & 0b00000001)];
		tempArray = [tempArray arrayByAddingObject:tempBool];
	}
	return tempArray;
}
- (void) setRepeatSchedule:(NSArray *)repeatSchedule{
	uint8_t tempRepeatSchedule = 0;
	for(int i =0; i<7; i++){
		
		//0 is sunday
		[[repeatSchedule objectAtIndex:i] boolValue];
		
		int placesToShift =7-i;
		tempRepeatSchedule ^= ( 1 << placesToShift);
	}
	alarm_t tempAlarm;
	tempAlarm.repeatSchedule = tempRepeatSchedule;
	tempAlarm.hour = self.binaryRepresentation.hour;
	tempAlarm.minute = self.binaryRepresentation.minute;
	_binaryRepresentation= tempAlarm;
	
	_repeatSchedule = repeatSchedule;
}

- (uint8_t) hour{
	return self.binaryRepresentation.hour;
}
- (void) setHour:(uint8_t)hour{
	_binaryRepresentation.hour = hour;
}

- (uint8_t) minute{
	return self.binaryRepresentation.minute;
}
- (void) setMinute:(uint8_t)minute{
	_binaryRepresentation.minute = minute;
}

-(uint32_t)getIntRepresentation{
	uint8_t bytes[4] = {self.minute, self.hour, self.binaryRepresentation.repeatSchedule, 0};
	return [self fourBytesToInt:bytes];
}
#pragma Bitpacker

-(BOOL)intToFourBytes:(uint32_t)integer buffer:(uint8_t[]) bytes{
	bytes[0] = (integer >> 0);
	bytes[1] = (integer >> 8);
	bytes[2] = (integer >> 16);
	bytes[3] = (integer >> 24);
	
	return true;
}
-(uint32_t)fourBytesToInt:(uint8_t[]) bytes{
	return  (uint32_t)bytes[0] + ((uint32_t)bytes[1] << 8) + ((uint32_t)bytes[2] << 16) + ((uint32_t)bytes[3] << 24);
}

- (NSString *)description {
	return [NSString stringWithFormat: @"Alarm: Time=%d:%d Repeats=%@", self.hour, self.minute, self.getStringRepresentationOfRepeatSchedule];
}

@end
