//
//  LEDynamicBallViewController.m
//  DynamicLearning
//
//  Created by 陈记权 on 8/3/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEDynamicBallViewController.h"

@interface LEDynamicBallViewController ()

@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *ballView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior *panGravity;

@end

@implementation LEDynamicBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setPanViewShadow];
    [self addGradientLayerToPanView];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [_panView addGestureRecognizer:pan];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self resetPanViewFrame];
    [self resetPanViewShadow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupBehaviors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPanViewShadow
{
    [self.panView setAlpha:0.5f];
    [self.panView.layer setShadowOffset:CGSizeMake(-1, 2)];
    [self.panView.layer setShadowOpacity:0.5];
    [self.panView.layer setShadowRadius:5.0f];
    [self.panView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.panView.layer setShadowPath:[UIBezierPath bezierPathWithRect:_panView.bounds].CGPath];
}

- (void)resetPanViewShadow
{
    [self setPanViewShadow];
}

- (void)addGradientLayerToPanView
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.frame = self.panView.bounds;
    gradientLayer.colors = @[(__bridge id)([UIColor colorWithRed:0.0
                                                           green:191.0f / 255.0f
                                                            blue:1
                                                           alpha:1.0f].CGColor),
                             (__bridge id)([UIColor yellowColor].CGColor),
                             (__bridge id)([UIColor whiteColor].CGColor)
                             ];
    [self.panView.layer insertSublayer:gradientLayer below:self.topView.layer];
    
    self.gradientLayer = gradientLayer;
}

- (void)resetPanViewFrame
{
    self.gradientLayer.frame = self.panView.bounds;
}

- (void)setupBehaviors
{
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    self.panGravity = [[UIGravityBehavior alloc]initWithItems:@[self.panView, self.topView, self.ballView, self.bottomView]];
    [self.dynamicAnimator addBehavior:self.panGravity];
    
    
    __weak __typeof(&* self)weakSelf = self;
    self.panGravity.action = ^{
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:weakSelf.panView.center];
        [bezierPath addCurveToPoint:weakSelf.ballView.center controlPoint1:weakSelf.topView.center controlPoint2:weakSelf.bottomView.center];
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        bezierPath.lineCapStyle = kCGLineCapRound;

        if (!weakSelf.shapeLayer) {
            weakSelf.shapeLayer = [[CAShapeLayer alloc]init];
            weakSelf.shapeLayer.fillColor = [UIColor clearColor].CGColor;
            weakSelf.shapeLayer.strokeColor = [UIColor colorWithRed:224.0/255.0 green:0.0/255.0 blue:35.0/255.0 alpha:1.0].CGColor;
            weakSelf.shapeLayer.lineWidth = 2.0f;
            
            [weakSelf.shapeLayer setShadowOffset:CGSizeMake(-1, 2)];
            [weakSelf.shapeLayer setShadowOpacity:0.5];
            [weakSelf.shapeLayer setShadowRadius:5.0f];
            [weakSelf.shapeLayer setShadowColor:[UIColor blackColor].CGColor];
            [weakSelf.shapeLayer setMasksToBounds:NO];
    
            [weakSelf.view.layer insertSublayer:weakSelf.shapeLayer below:weakSelf.ballView.layer];
        }
        
        weakSelf.shapeLayer.path = bezierPath.CGPath;
    };
    
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[self.panView]];
    [collision addBoundaryWithIdentifier:@"left"
                               fromPoint:CGPointMake(-1, 0)
                                 toPoint:CGPointMake(-1, screenHeight)];
    
    [collision addBoundaryWithIdentifier:@"right"
                               fromPoint:CGPointMake(screenWidth + 1, 0)
                                 toPoint:CGPointMake(screenWidth + 1,screenHeight)];
    
    [collision addBoundaryWithIdentifier:@"middle"
                               fromPoint:CGPointMake(0, screenHeight / 2.0f)
                                 toPoint:CGPointMake(screenWidth,screenHeight / 2.0f)];
    
    [self.dynamicAnimator addBehavior:collision];
    
    UIAttachmentBehavior *attachment1 = [[UIAttachmentBehavior alloc]initWithItem:self.topView
                                                                   attachedToItem:self.panView];
    [self.dynamicAnimator addBehavior:attachment1];
    
    UIAttachmentBehavior *attachment2 = [[UIAttachmentBehavior alloc]initWithItem:self.bottomView
                                                                   attachedToItem:self.topView];
    [self.dynamicAnimator addBehavior:attachment2];
    
    UIAttachmentBehavior *attachment3 = [[UIAttachmentBehavior alloc]initWithItem:self.ballView
                                                                 offsetFromCenter:UIOffsetMake(0, -CGRectGetHeight(self.ballView.bounds) / 2.0f)
                                                                   attachedToItem:self.bottomView
                                                                 offsetFromCenter:UIOffsetMake(0, 0)];
    [self.dynamicAnimator addBehavior:attachment3];
    
    UIDynamicItemBehavior *panItem = [[UIDynamicItemBehavior alloc]initWithItems:@[self.panView, self.topView, self.bottomView, self.ballView]];
    panItem.elasticity = 0.5f;
    [self.dynamicAnimator addBehavior:panItem];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //[self.dynamicAnimator removeBehavior:self.panGravity];
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:panGesture.view];
            
            if (!(self.panView.center.y + translation.y >
                  CGRectGetHeight(self.view.bounds) / 2.0f - CGRectGetHeight(self.panView.bounds) / 2.0f)) {
                self.panView.center = CGPointMake(self.panView.center.x, translation.y + self.panView.center.y);
                
                [panGesture setTranslation:CGPointZero inView:panGesture.view];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            //[self.dynamicAnimator addBehavior:self.panGravity];
            break;
            
        default:
            break;
    }
    
    /**
     *  Asks a dynamic animator to read the current state of a dynamic item, 
     *  replacing the animator’s internal representation of the item’s state.
     *  A dynamic animator automatically reads the initial state (position and rotation) of 
     *  each dynamic item you add to it, and then takes responsibility for updating the item’s state. 
     *  If you actively change the state of a dynamic item after you’ve added it to a dynamic animator, 
     *  call this method to ask the animator to read and incorporate the new state.
     */
    
    [self.dynamicAnimator updateItemUsingCurrentState:panGesture.view];
}

@end
