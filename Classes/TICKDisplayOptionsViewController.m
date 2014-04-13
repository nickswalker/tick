#import "TICKDisplayOptionsViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueShield.h"
#import "BSDefines.h"


@interface TICKDisplayOptionsViewController ()

@end

@implementation TICKDisplayOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setShield:(BlueShield *)shield andPeripheral:(CBPeripheral *) peripheral{
	self.peripheral = peripheral;
	self.shield = shield;
}

@end
