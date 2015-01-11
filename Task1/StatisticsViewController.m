//
//  StatisticsViewController.m
//  Task1
//
//  Created by Vladislav Posashkov on 08.01.15.
//  Copyright (c) 2015 Vladislav Posashkov. All rights reserved.
//

#import "StatisticsViewController.h"
#import "Player.h"


@interface StatisticsViewController ()

@property (strong, nonatomic) NSArray *players;

- (void)initPlot;
- (void)configureGraph;
- (void)configurePlot;
- (void)configureAxes;

@end

@implementation StatisticsViewController

static const NSString *plotIdentifier = @"Team";
static const NSInteger plotSizeOffset = 2;
static const CGFloat plotOffset = 0.2f;
static const CGFloat barOffset = 0.2f;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPlot];
}


- (void)initPlot{
    self.graphHostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlot];
    [self configureAxes];
}

- (void)configureGraph{
    //Create Graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.graphHostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.graphHostView.hostedGraph = graph;
    
    //Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.paddingLeft = 0.0f;

    graph.plotAreaFrame.paddingTop = 10.0f;
    graph.plotAreaFrame.paddingRight = 20.0f;
    graph.plotAreaFrame.paddingBottom = 100.0f;
    graph.plotAreaFrame.paddingLeft = 45.0f;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    
    CGFloat xMin = 0.0f;
    CGFloat xMax = CPTFloat([_players count] + plotSizeOffset);
    CGFloat yMin = 0.0f;
    CGFloat yMax = CPTFloat([[_players valueForKeyPath:@"@max.goals"] integerValue] + plotSizeOffset);
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(xMin) length:CPTDecimalFromCGFloat(xMax)];
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(yMin) length:CPTDecimalFromCGFloat(yMax)];
}

- (void)configurePlot{
    self.teamBarPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
    self.teamBarPlot.identifier = plotIdentifier;
    
    self.teamBarPlot.barOffset = CPTDecimalFromCGFloat(barOffset);

    
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0f;
    
    
    //Add plots to graph
    CPTGraph *graph = self.graphHostView.hostedGraph;
    self.teamBarPlot.delegate = self;
    self.teamBarPlot.dataSource = self;
    self.teamBarPlot.lineStyle = lineStyle;
    self.teamBarPlot.fill = [CPTFill fillWithColor:[[CPTColor blueColor] colorWithAlphaComponent:0.5f]];
    self.teamBarPlot.barCornerRadius = 10.0f;
    self.teamBarPlot.barWidth = CPTDecimalFromFloat(plotOffset);
    
    [graph addPlot:self.teamBarPlot toPlotSpace:graph.defaultPlotSpace];
}

- (void)configureAxes{
    CPTMutableTextStyle *axisTitleStyle = [[CPTMutableTextStyle alloc] init];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [[CPTMutableLineStyle alloc] init];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:0.8f];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graphHostView.hostedGraph.axisSet;
    
    
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_players count]; ++i) {
        Player *player = [_players objectAtIndex:i];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:player.lastName textStyle:axisTitleStyle];
        label.rotation = M_PI_4;
        label.tickLocation = CPTDecimalFromInt(i);
        label.alignment = CPTAlignmentTop;
        [labels addObject:label];
    }
    
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.axisLabels = [NSSet setWithArray:labels];
    axisSet.xAxis.labelOffset = 0.0f;
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    
    
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
}

- (void)setPlayersWithArray:(NSArray *)array{
    if (array) {
        _players = array;
    }
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [_players count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (fieldEnum == CPTBarPlotFieldBarTip) {
        Player *player = [_players objectAtIndex:index];
        return player.goals;
    }
    return [NSNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
}

@end




