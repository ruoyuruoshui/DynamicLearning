//
//  LEDefaultAnimator.m
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEDefaultBehavior.h"

@implementation LEDefaultBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        UICollisionBehavior *collisionBehavior = [UICollisionBehavior new];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        [self addChildBehavior:collisionBehavior];
        
        
        [self addChildBehavior:[UIGravityBehavior new]];
    }
    return self;
}

- (void)addItem:(id <UIDynamicItem>)item
{
    for (id behavior in self.childBehaviors) {
        [behavior addItem:item];
    }
}

- (void)removeItem:(id <UIDynamicItem>)item
{
    for (id behavior in self.childBehaviors) {
        [behavior removeItem:item];
    }
}

@end
