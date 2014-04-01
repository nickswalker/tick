#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueShield.h"
#import "BSDefines.h"

@class BlueShield;

@interface TICKDebugConsoleViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) BlueShield *shield;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (strong, nonatomic) IBOutlet UITextField *sendText;
@property (strong, nonatomic) IBOutlet UILabel *rxLabel;

- (void)setShield:(BlueShield *)shield andPeripheral:(CBPeripheral *) peripheral;

@end
