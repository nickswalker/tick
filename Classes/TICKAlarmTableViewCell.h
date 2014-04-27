//
//  TICKAlarmTableViewCell.h
//  Tick
//
//  Created by Nick Walker on 4/27/14.
//  Copyright (c) 2014 Linlinqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TICKAlarmTableViewCell : UITableViewCell

@property IBOutlet UISwitch* activationSwitch;
@property IBOutlet UILabel* timeLabel;
@property IBOutlet UILabel* repeatScheduleLabel;

@end
