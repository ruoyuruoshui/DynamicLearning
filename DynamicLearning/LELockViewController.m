//
//  LELockViewController.m
//  DynamicLearning
//
//  Created by 陈记权 on 8/2/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LELockViewController.h"

@interface LELockViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *lockScreenView;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;

@end

@implementation LELockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lockScreenView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.lockScreenView.image = [UIImage imageNamed:@"lock_screen"];
    self.lockScreenView.contentMode = UIViewContentModeScaleToFill;
    self.lockScreenView.userInteractionEnabled = YES;
    [self.view addSubview:_lockScreenView];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    self.gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.lockScreenView]];
    self.gravityBehavior.gravityDirection = CGVectorMake(0.0, 1.0f);
    self.gravityBehavior.magnitude = 2.6f;
    
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.lockScreenView]];
    self.itemBehavior.elasticity = 0.35f; // elasticity:弹性
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    [panGesture addTarget:self action:@selector(panGestureAction:)];
    [self.lockScreenView addGestureRecognizer:panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.collisionBehavior) {
        self.collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.lockScreenView]];
        CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-screenHeight, 0, 0, 0)];
        [self.dynamicAnimator addBehavior:self.collisionBehavior];
    }
    
    if (!self.pushBehavior) {
        self.pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.lockScreenView] mode:UIPushBehaviorModeInstantaneous];
        self.pushBehavior.magnitude = 2.0;
        self.pushBehavior.angle = M_PI;
        
        [self.dynamicAnimator addBehavior:self.pushBehavior];
    }
    
    [self.dynamicAnimator addBehavior:self.itemBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dynamicAnimator removeAllBehaviors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint location = CGPointMake(CGRectGetMidX(self.lockScreenView.bounds), [panGesture locationInView:self.view].y);
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.dynamicAnimator removeBehavior:self.gravityBehavior];
            
            self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.lockScreenView attachedToAnchor:location];
            [self.dynamicAnimator addBehavior:self.attachmentBehavior];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.attachmentBehavior.anchorPoint = location;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self.dynamicAnimator removeBehavior:self.attachmentBehavior];
            self.attachmentBehavior = nil;

            CGPoint velocity = [panGesture velocityInView:self.lockScreenView];
            
            if (velocity.y < -1300.0f) {

                self.gravityBehavior.gravityDirection = CGVectorMake(0.0, -1.0f);
                self.gravityBehavior.magnitude = 2.6f;
                [self.dynamicAnimator addBehavior:self.gravityBehavior];
                
                self.itemBehavior.elasticity = 0.0f;
                [self.dynamicAnimator addBehavior:self.itemBehavior];
                
                self.pushBehavior.pushDirection = CGVectorMake(0, -200.0f);
                self.pushBehavior.active = YES;
            } else {
                [self restore:nil];
            }
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)lockMe:(id)sender {
    [self restore:self];
}

- (void)restore:(id)sender
{
    self.gravityBehavior.gravityDirection = CGVectorMake(0.0, 1.0f);
    self.gravityBehavior.magnitude = 2.0f;
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    
    self.itemBehavior.elasticity = 0.35f;
    
    [self.dynamicAnimator addBehavior:self.itemBehavior];
}
@end
