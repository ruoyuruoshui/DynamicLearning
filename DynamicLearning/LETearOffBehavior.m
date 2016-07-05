//
//  LETearOffBehavior.m
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LETearOffBehavior.h"
#import "LEDraggableView.h"

BOOL points_are_within_distances(CGPoint p1, CGPoint p2, CGFloat distance)
{
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    
    CGFloat current_distance = hypotf(dx, dy);
    
    return (current_distance < distance);
}

@implementation LETearOffBehavior

- (instancetype)initWithDraggableView:(LEDraggableView *)view anchor:(CGPoint)anchor handler:(LETearOffHandler)handler
{
    self = [super init];
    if (self) {
        self.active = NO;
        
        [self addChildBehavior:[[UISnapBehavior alloc] initWithItem:view snapToPoint:anchor]];
        
        CGFloat distance = MIN(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        
        __weak __typeof(&* self)weakSelf = self;
        self.action = ^ {
            __strong __typeof(&* self)strongSelf = weakSelf;
            
            if (points_are_within_distances(view.center, anchor, distance)) {
                if (strongSelf.active) {
                    LEDraggableView *newView = [view copy];
                    
                    [view.superview addSubview:newView];
                    
                    LETearOffBehavior *tearOffBehavior = [[LETearOffBehavior alloc]initWithDraggableView:newView
                                                                                                  anchor:anchor
                                                                                                 handler:handler];
                    tearOffBehavior.active = NO;
                    
                    [strongSelf.dynamicAnimator addBehavior:tearOffBehavior];
                    
                    handler(view, newView);
                    
                    [strongSelf.dynamicAnimator removeBehavior:strongSelf];
                }
            } else {
                strongSelf.active = YES;
            }
        };
    }
    
    return self;
}

@end
