//
//  TICKAlarm.m
//  Tick
//
//  Created by Nick Walker on 4/26/14.
//  Copyright (c) 2014 Linlinqi. All rights reserved.
//

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
	return @"yo dawg";
}

- (NSArray*) repeatSchedule{
	NSArray* tempArray;
	NSNumber* tempBool;
	for(int i =0; i<7; i++){
		int placesToShift =7-i;
		tempBool =  [NSNumber numberWithInt:((self.binaryRepresentation.repeatSchedule >> placesToShift) & 0b11111111)];
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
