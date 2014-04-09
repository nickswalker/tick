#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BlueShield;

@interface TICKViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) BlueShield *shield;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property IBOutlet UIButton *refresh;
@property IBOutlet UISlider *rSlider;
@property IBOutlet UISlider *gSlider;
@property IBOutlet UISlider *bSlider;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
