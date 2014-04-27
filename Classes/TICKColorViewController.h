#import <UIKit/UIKit.h>

@class TICKTock;

@interface TICKColorViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) TICKTock *tock;

@property IBOutlet UISlider *rSlider;
@property IBOutlet UISlider *gSlider;
@property IBOutlet UISlider *bSlider;
@property IBOutlet UIView *colorPreview;

- (IBAction)updateColorPreview:(UISlider *)sender;
- (IBAction)sendColorToTock:(UISlider *)sender;

@end
