//
//  TICKAlarmTableViewCell.m
//  Tick
//
//  Created by Nick Walker on 4/27/14.
//  Copyright (c) 2014 Linlinqi. All rights reserved.
//

#import "TICKAlarmTableViewCell.h"

@implementation TICKAlarmTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
