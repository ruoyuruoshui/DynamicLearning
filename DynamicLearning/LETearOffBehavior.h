//
//  LETearOffBehavior.h
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LEDraggableView;

typedef void(^ LETearOffHandler)(LEDraggableView *tornView, LEDraggableView *newPinView);

@interface LETearOffBehavior : UIDynamicBehavior

@property (nonatomic, assign) BOOL active;

- (instancetype)initWithDraggableView:(LEDraggableView *)view anchor:(CGPoint)anchor handler:(LETearOffHandler)handler;

@end
