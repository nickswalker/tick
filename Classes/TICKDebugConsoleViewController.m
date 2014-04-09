#import "TICKDebugConsoleViewController.h"
#import "BlueShield.h"
#import "BSDefines.h"

@interface TICKDebugConsoleViewController ()

@end

@implementation TICKDebugConsoleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShield:(BlueShield *)shield andPeripheral:(CBPeripheral *) peripheral{
	self.peripheral = peripheral;
	self.shield = shield;
}
#pragma mark - custom method

- (void)sendTx:(NSString*)string {
	 NSLog(string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [_shield writeValue:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
     characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_TX_UUID]
                      p:_peripheral
                   data:data];
}
- (void)sendBytes:(const void *)message {
    NSData *data = [NSData dataWithBytes:&message length:sizeof(message)];
    [_shield writeValue:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
     characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_TX_UUID]
                      p:_peripheral
                   data:data];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [self sendTx : textField.text];
}

@end
