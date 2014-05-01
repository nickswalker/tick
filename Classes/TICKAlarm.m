#import "TICKAlarm.h"

@implementation TICKAlarm
@synthesize repeatSchedule = _repeatSchedule;

- (id)initWithBinary: (alarm_t) alarm
{
    self = [super init];
    if (self)
    {
        self.binaryRepresentation = alarm;
    }
    return self;
}

- (BOOL) repeatsForDayOfWeek: (DayOfWeek) dayOfWeek{
	return [[self.repeatSchedule objectAtIndex:dayOfWeek] boolValue];
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
	if((rs[1] && rs[2] && rs[3] && rs [4] && rs[5]) && !(rs[0] || rs[6]) ) temp = @"Weekdays";
	if(rs[1] && rs[2] && rs[3] && rs [4] && rs[5] && rs[0] && rs[6] ) temp = @"Every day";
	return temp;
}

- (NSArray*) repeatSchedule{
	NSArray* tempArray = [[NSArray alloc] init];
	NSNumber* tempBool;
	for(int i =0; i<7; i++){
		int placesToShift =7-i;
		tempBool =  [NSNumber numberWithBool:((self.binaryRepresentation.repeatSchedule >> placesToShift) & 0b00000001)];
		tempArray = [tempArray arrayByAddingObject:tempBool];
	}
	NSLog(@"%@",tempArray);
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
	self.binaryRepresentation= tempAlarm;
	
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

@end
