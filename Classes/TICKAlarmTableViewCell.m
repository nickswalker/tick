#import "TICKAlarmTableViewCell.h"
#import "TICKAlarm.h"

@implementation TICKAlarmTableViewCell
@synthesize alarm = _alarm;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
	[super setEditing:editing animated:animated];
	if (editing) {
		[UIView animateWithDuration:.25 delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
			[self.activationSwitch setAlpha:0.f];
		} completion:^(BOOL finished) {
			self.activationSwitch.hidden = true;
		}];
		
	}
	else{
	self.activationSwitch.hidden = false;
	[UIView animateWithDuration:.35 delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
		[self.activationSwitch setAlpha:1.f];
	} completion:^(BOOL finished) {
		
	}];
	}
}

- (IBAction)toggledActivation:(UISwitch*)sender{

	if (sender.on) {
		[UIView animateWithDuration:.35 delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
			[self setBackgroundColor: [UIColor whiteColor]];
			self.timeLabel.textColor = [UIColor blackColor];
		} completion:^(BOOL finished) {
			
		}];
	}
	else{
	[UIView animateWithDuration:.35 delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
		[self setBackgroundColor: [UIColor colorWithRed:.933 green:.933 blue:.9531 alpha:1]];
		self.timeLabel.textColor = [UIColor colorWithRed:.556 green:.556 blue:.576 alpha:1];
	} completion:^(BOOL finished) {
		
	}];
	}
}
- (void) setAlarm:(TICKAlarm *)alarm{
	_alarm = alarm;
	self.timeLabel.text =  [NSString stringWithFormat:@"%02d:%02d", alarm.hour, alarm.minute ];
	self.repeatScheduleLabel.text = [alarm getStringRepresentationOfRepeatSchedule];
	
}
- (TICKAlarm*) alarm{
	return _alarm;
}
- (void) alarmDetailWasDismissed:(TICKAlarm *)alarm{
	self.alarm = alarm;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
