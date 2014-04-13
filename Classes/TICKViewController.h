#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BlueShield;

@interface TICKViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) BlueShield *shield;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property IBOutlet UITableViewCell *controlsCell;
@property BOOL controlsVisible;
@property IBOutlet UISlider *rSlider;
@property IBOutlet UISlider *gSlider;
@property IBOutlet UISlider *bSlider;
@property IBOutlet UITableViewCell *colorCell;


- (IBAction)updateColorCell:(UISlider *)sender;
- (IBAction)sendColorToTock:(UISlider *)sender;
- (IBAction)refresh:(id)sender;

@end
