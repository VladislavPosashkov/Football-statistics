//
//  StatisticsViewController.h
//  Task1
//
//  Created by Vladislav Posashkov on 08.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@class Team;

@interface StatisticsViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *graphHostView;
@property (strong, nonatomic) CPTBarPlot *teamBarPlot;

- (void)setPlayersWithArray:(NSArray *)array;

@end
