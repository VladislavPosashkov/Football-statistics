//
//  PlayerTableViewCell.h
//  Task1
//
//  Created by Vladislav Posashkov on 07.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;

@end
