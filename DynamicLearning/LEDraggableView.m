//
//  LEDraggableView.h
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEDraggableView.h"

@implementation LEDraggableView

- (instancetype)initWithFrame:(CGRect)frame animator:(UIDynamicAnimator *)animator
{
    self = [super initWithFrame:frame];
    if (self) {
        _dynamicAnimator = animator;
        
        self.backgroundColor = [UIColor yellowColor];
        
        self.layer.borderWidth = 2.0f;
        self.gestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        
        [self addGestureRecognizer:self.gestureRecognizer];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self stopDragging];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self dragToPoint:[gestureRecognizer locationInView:self.superview]];
            break;
            
        default:
            break;
    }
}

- (void)dragToPoint:(CGPoint)point
{
    [self.dynamicAnimator removeBehavior:self.snapBehavior];
    
    self.snapBehavior = [[UISnapBehavior alloc]initWithItem:self snapToPoint:point];
    
    self.snapBehavior.damping = 0.25;
    
    [self.dynamicAnimator addBehavior:self.snapBehavior];
}


- (void)stopDragging
{
    [self.dynamicAnimator removeBehavior:self.snapBehavior];
    
    self.snapBehavior = nil;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    LEDraggableView *newView = [[[self class] alloc]initWithFrame:CGRectZero animator:self.dynamicAnimator];
    
    newView.bounds = self.bounds;
    newView.center = self.center;
    newView.transform = self.transform;
    newView.alpha = self.alpha;
    
    return newView;
}

@end
