#import "TICKDebugConsoleViewController.h"
#import "BlueShield.h"
#import "BSDefines.h"

@interface TICKDebugConsoleViewController ()

@end

@implementation TICKDebugConsoleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.shield didDiscoverCharacteristicsBlock:^(id response, NSError *error) {
		double delayInSeconds = 3.0;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self.shield notification:[CBUUID UUIDWithString:BS_SERIAL_SERVICE_UUID]
			   characteristicUUID:[CBUUID UUIDWithString:BS_SERIAL_RX_UUID]
								p:_peripheral
							   on:YES];
			
			
			[self.shield didUpdateValueBlock:^(NSData *data, NSError *error) {
				self.rxLabel.text = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
				
				
			}];
		});
	}];
}

- (void)setShield:(BlueShield *)shield andPeripheral:(CBPeripheral *) peripheral{
	self.peripheral = peripheral;
	self.shield = shield;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    //[self.shield sendText : textField.text];
}

@end
