//
//  LEDragViewController.m
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEDragViewController.h"
#import "LEDraggableView.h"

const CGFloat kShapeDimension = 100.0f;

@interface LEDragViewController ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@end

@implementation LEDragViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    CGRect frame = CGRectMake(100, 100, kShapeDimension, kShapeDimension);
    LEDraggableView *dragView = [[LEDraggableView alloc]initWithFrame:frame animator:self.dynamicAnimator];
    
    [self.view addSubview:dragView];
}

@end
