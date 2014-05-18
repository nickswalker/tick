//
//  TICKAlarm.h
//  Tick
//
//  Created by Nick Walker on 4/26/14.
//  Copyright (c) 2014 Linlinqi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct{
	uint8_t repeatSchedule;
	uint8_t hour;
	uint8_t minute;
} alarm_t;

typedef enum {
	SUNDAY = 1,
	MONDAY = 2,
	TUESDAY = 3,
	WEDNESDAY = 4,
	THURSDAY = 5,
	FRIDAY = 6,
	SATURDAY = 7
	
} DayOfWeek;

@interface TICKAlarm : NSObject

@property (readonly) alarm_t binaryRepresentation;
@property uint8_t minute;
@property uint8_t hour;
@property BOOL isActivated;
@property NSArray* repeatSchedule;

- (id) initWithBinary:(alarm_t)alarm;
- (id) initWithInt:(uint32_t)integer;
- (BOOL) repeatsForDayOfWeek: (DayOfWeek) dayOfWeek;
- (void) setRepeatForDayOfWeek:(DayOfWeek) dayOfWeek withValue:(BOOL) value;
- (NSString *) getStringRepresentationOfRepeatSchedule;

- (uint32_t) getIntRepresentation;
@end
