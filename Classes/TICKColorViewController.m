#import "TICKColorViewController.h"
#import "TICKTock.h"
#import "BSDefines.h"
#import <QuartzCore/QuartzCore.h>

@interface TICKColorViewController ()

@end

@implementation TICKColorViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.colorPreview.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:1 alpha:.5] CGColor], nil];
	[self.colorPreview.layer insertSublayer:gradient atIndex:0];
	
}

- (IBAction)updateColorPreview:(UISlider *)sender {
	float r = self.rSlider.value/255;
	float g = self.gSlider.value/255;
	float b = self.bSlider.value/255;

	[self.colorPreview setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:1]];
}
- (IBAction)sendColorToTock:(UISlider *)sender {
	unsigned char r = (char)self.rSlider.value;
	unsigned char g = (char)self.gSlider.value;
	unsigned char b = (char)self.bSlider.value;
	unsigned char message[] = {SETLIGHTCOLOR, r, g, b};
	
	[self.tock sendBytes:message size:sizeof(message)];
}


@end
