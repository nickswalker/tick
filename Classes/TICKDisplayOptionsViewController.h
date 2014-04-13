#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueShield.h"
#import "BSDefines.h"

@class BlueShield;

@interface TICKDisplayOptionsViewController : UITableViewController

@property (nonatomic, strong) BlueShield *shield;
@property (nonatomic, strong) CBPeripheral *peripheral;

@end
