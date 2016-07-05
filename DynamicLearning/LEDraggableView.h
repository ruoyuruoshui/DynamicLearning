//
//  LEDraggableView.h
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEDraggableView : UIView

@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;

- (instancetype)initWithFrame:(CGRect)frame animator:(UIDynamicAnimator *)animator;

@end
