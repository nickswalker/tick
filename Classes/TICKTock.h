#import "BlueShield.h"

@interface TICKTock : BlueShield

-(void) attachToTock;
-(void)syncCurrentDateAndTime;
-(void)resetToDefaults;

@end
