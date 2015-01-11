//
//  PlayerHeaderUITableViewHeaderFooterView.h
//  Task1
//
//  Created by Vladislav Posashkov on 08.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayersHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;

@end
