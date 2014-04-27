//
//  TICKTock.h
//  Tick
//
//  Created by Nick Walker on 4/27/14.
//  Copyright (c) 2014 Linlinqi. All rights reserved.
//

#import "BlueShield.h"

@interface TICKTock : BlueShield

-(void) attachToTock;
-(void)syncCurrentDateAndTime;

@end
