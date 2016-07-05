//
//  LETearOffViewController.m
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LETearOffViewController.h"
#import "LETearOffBehavior.h"
#import "LEDraggableView.h"
#import "LEDefaultBehavior.h"

@interface LETearOffViewController ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) LEDefaultBehavior *defaultBehavior;

@end

@implementation LETearOffViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    CGRect frame = CGRectMake(0, 0, 80, 80);
    
    LEDraggableView *dragView = [[LEDraggableView alloc]initWithFrame:frame animator:self.dynamicAnimator];
    dragView.center = self.view.center;
    
    [self.view addSubview:dragView];

    self.defaultBehavior = [LEDefaultBehavior new];
    [self.dynamicAnimator addBehavior:self.defaultBehavior];
   LETearOffBehavior *tearOffBehavior = [[LETearOffBehavior alloc]initWithDraggableView:dragView
                                                                                 anchor:self.view.center
                                                                                handler:^(LEDraggableView *tornView, LEDraggableView *newPinView) {
      
                                                                                    tornView.alpha = 1;
                                                                                    [self.defaultBehavior addItem:tornView];
                                                                                    //[tornView removeFromSuperview];
                                                                                    
                                                                                    UITapGestureRecognizer *
                                                                                    tap = [[UITapGestureRecognizer alloc]
                                                                                           initWithTarget:self
                                                                                           action:@selector(trash:)];
                                                                                    tap.numberOfTapsRequired = 2;
                                                                                    [tornView addGestureRecognizer:tap];
   }];
    
    [self.dynamicAnimator addBehavior:tearOffBehavior];
}

- (void)trash:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    
    NSArray *subViews = [self sliceView:view intoRows:10 columns:10];
    
    UIDynamicAnimator *trashAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    LEDefaultBehavior *defaultBehavior = [[LEDefaultBehavior alloc]init];
    
    for (UIView *subView in subViews) {
        [self.view addSubview:subView];
        
        [defaultBehavior addItem:subView];
        
        UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[subView] mode:UIPushBehaviorModeInstantaneous];
        
        [push setPushDirection:CGVectorMake((float) rand() / RAND_MAX- 0.5, (float) rand() / RAND_MAX - 0.5)];
        push.magnitude = 0.05;
        [trashAnimator addBehavior:push];
        
        [UIView animateWithDuration:2 animations:^{
            subView.alpha = 0;
        } completion:^(BOOL finished) {
            [subView removeFromSuperview];
            [trashAnimator removeBehavior:push];
        }];
    }
    
    [self.defaultBehavior removeItem:view];
    [view removeFromSuperview];
}

- (NSArray *)sliceView:(UIView *)view intoRows:(NSUInteger)rows columns:(NSUInteger)columns
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    
    CGImageRef image = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    
    NSMutableArray *views = [NSMutableArray new];
    
    for (NSUInteger row = 0; row < rows; ++ row) {
        for (NSUInteger column = 0; column < columns; ++ column) {
            CGRect rect = CGRectMake(column * (width / columns), row * (height / rows), width / columns, height / rows);
            CGImageRef subImage = CGImageCreateWithImageInRect(image, rect);
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:subImage]];
            imageView.frame = CGRectOffset(rect, CGRectGetMinX(view.frame), CGRectGetMinY(view.frame));
            CGImageRelease(subImage);
            subImage = NULL;
            
            [views addObject:imageView];
        }
    }
    
    return views;
}

@end
