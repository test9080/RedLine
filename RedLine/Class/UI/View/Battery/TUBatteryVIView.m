//
//  TUBatteryVIView.m
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryVIView.h"
#import "BEMSimpleLineGraphView.h"
#import "UIColor+GGColor.h"

#define LOAD_NIB(name) [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject]

@interface TUBatteryVIView ()<BEMSimpleLineGraphDelegate,BEMSimpleLineGraphDataSource>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *voltageGraphView;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *currentGraphView;

@property (strong, nonatomic)NSMutableArray *voltageArray;//电压valueArray
@property (strong, nonatomic)NSMutableArray *currentArray;//电流valueArray


@end

@implementation TUBatteryVIView

+ (BEMSimpleLineGraphView *)showGraphView {
    return LOAD_NIB(@"TUBatteryVIView");
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    self.voltageArray = [NSMutableArray array];
    self.currentArray = [NSMutableArray array];
    
    self.voltageGraphView.delegate = self;
    self.currentGraphView.delegate = self;
    self.voltageGraphView.dataSource = self;
    self.currentGraphView.dataSource = self;
    
    [self setup];
}

- (void)setup {
//    for (int i = 0 ; i < 9; i ++ ) {
//        [self.voltageArray addObject:@([self getRandomFloat])]; // Random values for the graph
//        [self.currentArray addObject:@([self getRandomFloat])]; // Random values for the graph
//    }
    
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.3, 0.4, 0.8, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // Apply the gradient to the bottom portion of the graph
    self.voltageGraphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.voltageGraphView.enableTouchReport = YES;
    self.voltageGraphView.enablePopUpReport = YES;
    self.voltageGraphView.enableYAxisLabel = YES;
    self.voltageGraphView.autoScaleYAxis = NO;
    self.voltageGraphView.alwaysDisplayDots = NO;
    self.voltageGraphView.enableReferenceXAxisLines = YES;
    self.voltageGraphView.enableReferenceYAxisLines = YES;
    self.voltageGraphView.enableReferenceAxisFrame = YES;
    
    // Draw an average line
//    self.voltageGraphView.averageLine.enableAverageLine = YES;
//    self.voltageGraphView.averageLine.alpha = 0.6;
//    self.voltageGraphView.averageLine.color = [UIColor darkGrayColor];
//    self.voltageGraphView.averageLine.width = 2.5;
//    self.voltageGraphView.averageLine.dashPattern = @[@(2),@(2)];
    
    // Set the graph's animation style to draw, fade, or none
//    self.voltageGraphView.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.voltageGraphView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.voltageGraphView.formatStringForValues = @"%.1f";
    
    self.voltageGraphView.enableBezierCurve = YES;
    
    self.voltageGraphView.alphaBottom = 0.8;
    self.voltageGraphView.colorBottom = [UIColor colorWithARGB:0xff60b1ce];
    self.voltageGraphView.colorTop = [UIColor clearColor];
    
    

    self.currentGraphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.currentGraphView.enableTouchReport = YES;
    self.currentGraphView.enablePopUpReport = YES;
    self.currentGraphView.enableYAxisLabel = YES;
    self.currentGraphView.autoScaleYAxis = YES;
    self.currentGraphView.alwaysDisplayDots = NO;
    self.currentGraphView.enableReferenceXAxisLines = YES;
    self.currentGraphView.enableReferenceYAxisLines = YES;
    self.currentGraphView.enableReferenceAxisFrame = YES;
    
    // Draw an average line
    self.currentGraphView.averageLine.enableAverageLine = NO;
    self.currentGraphView.averageLine.alpha = 0.6;
    self.currentGraphView.averageLine.color = [UIColor darkGrayColor];
    self.currentGraphView.averageLine.width = 2.5;
    self.currentGraphView.averageLine.dashPattern = @[@(2),@(2)];
    
    // Set the graph's animation style to draw, fade, or none
    self.currentGraphView.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.currentGraphView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.currentGraphView.formatStringForValues = @"%.1f";
    
    self.currentGraphView.enableBezierCurve = YES;
    self.currentGraphView.animationGraphStyle = BEMLineAnimationFade;
    
    self.currentGraphView.colorBottom = [UIColor colorWithARGB:0xff60b1ce];
    self.currentGraphView.colorTop = [UIColor clearColor];

}

- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 100) / 100 ;
    return i1;
}

#pragma updateUI
- (void)updeteDataWithVoltageArray:(NSMutableArray *)voltageArray currentArray:(NSMutableArray *)currentArray {
    self.voltageArray = voltageArray;
    self.currentArray = currentArray;
    [self.voltageGraphView reloadGraph];
    [self.currentGraphView reloadGraph];
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (graph == self.voltageGraphView) {
        return (int)self.voltageArray.count;
    } else {
        return (int)self.currentArray.count;
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (graph == self.voltageGraphView) {
        return [[self.voltageArray objectAtIndex:index] doubleValue];
    } else {
        return [[self.currentArray objectAtIndex:index] doubleValue];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
