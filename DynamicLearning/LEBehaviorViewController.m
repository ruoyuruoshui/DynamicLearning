//
//  LEBehaviorViewController.m
//  DynamicLearning
//
//  Created by 陈记权 on 7/4/16.
//  Copyright © 2016 LeEco. All rights reserved.
//

#import "LEBehaviorViewController.h"

#define kScreenHeight (CGRectGetHeight([UIScreen mainScreen].bounds))
#define kScreenWidth (CGRectGetWidth([UIScreen mainScreen].bounds))

#define kPanAttachTest 1

@interface LEBehaviorViewController ()

@property (weak, nonatomic) IBOutlet UIView *boxView1;
@property (weak, nonatomic) IBOutlet UIView *boxView2;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIAttachmentBehavior *attachBehavior;

@end

@implementation LEBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
#if kPanAttachTest
    [self createGestureRecognizer];
#endif
}

- (IBAction)snapBehavior:(id)sender
{
    CGPoint snapPoint = CGPointMake(kScreenWidth / 2 - 100, kScreenHeight - 50);
    
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.boxView1 snapToPoint:snapPoint];
    
    snap.damping = 0.25;
    
    [self.dynamicAnimator addBehavior:snap];
}

- (void) createGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}


- (IBAction)attachBehavior:(id)sender
{
#if kPanAttachTest
    [self panAttach];
#else
    [self pushAttach];
#endif
}

- (void)pushAttach
{
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[self.boxView1, self.boxView2]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:collision];
    
    
#if 0
    UIAttachmentBehavior *attachSelf = [[UIAttachmentBehavior alloc]initWithItem:self.boxView1
                                                                offsetFromCenter:UIOffsetMake(20, 20)
                                                                attachedToAnchor:self.boxView1.center];
    
    [self.dynamicAnimator addBehavior:attachSelf];
    
#else
    CGRect bounds = self.boxView1.bounds;
    CGPoint center = self.boxView1.center;
    
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    
    CGFloat offsetWidth = width / 2.0f;
    CGFloat offsetHeight = height / 2.0f;
    
    UIOffset offsetUL = UIOffsetMake(-offsetWidth, -offsetHeight);
    UIOffset offsetUR = UIOffsetMake(offsetWidth, -offsetHeight);
    UIOffset offsetLL = UIOffsetMake(-offsetWidth, offsetHeight);
    UIOffset offsetLR = UIOffsetMake(offsetWidth, offsetHeight);
    
    CGFloat anchorWidth = width / 2.0f;
    CGFloat anchorHeight = height / 2.0f;
    
    CGPoint anchorUL = CGPointMake(center.x - anchorWidth, center.y - anchorHeight);
    CGPoint anchorUR = CGPointMake(center.x + anchorWidth, center.y - anchorHeight);
    CGPoint anchorLL = CGPointMake(center.x - anchorWidth, center.y + anchorHeight);
    CGPoint anchorLR = CGPointMake(center.x + anchorWidth, center.y + anchorHeight);
    
    [self.dynamicAnimator addBehavior:[[UIAttachmentBehavior alloc] initWithItem:self.boxView1
                                                                offsetFromCenter:offsetUL
                                                                attachedToAnchor:anchorUL]];
    
    [self.dynamicAnimator addBehavior:[[UIAttachmentBehavior alloc] initWithItem:self.boxView1
                                                                offsetFromCenter:offsetUR
                                                                attachedToAnchor:anchorUR]];
    
    [self.dynamicAnimator addBehavior:[[UIAttachmentBehavior alloc] initWithItem:self.boxView1
                                                                offsetFromCenter:offsetLL
                                                                attachedToAnchor:anchorLL]];
    
    [self.dynamicAnimator addBehavior:[[UIAttachmentBehavior alloc] initWithItem:self.boxView1
                                                                offsetFromCenter:offsetLR
                                                                attachedToAnchor:anchorLR]];
#endif
    
    
    UIAttachmentBehavior *attach2= [[UIAttachmentBehavior alloc]initWithItem:self.boxView2 attachedToItem:self.boxView1];
    [self.dynamicAnimator addBehavior:attach2];
    
    UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[self.boxView2] mode:UIPushBehaviorModeInstantaneous];
    
    push.pushDirection = CGVectorMake(0, 2);
    
    [self.dynamicAnimator addBehavior:push];
}

- (void)panAttach
{
    /*
     
     Initializes a behavior where the specified point in a dynamic item is attached to an anchor point.
     The initialized attachment behavior, or nil if there was a problem initializing the object.
     Parameters
     item
     The dynamic item to attach to the specified point.
     p1
     The offset from the center of item at which to create the attachment.
     Specifying UIOffsetZero creates the attachment at the center of item.
     
     point
     The anchor point for the item. Specify this point in the coordinate system of the dynamic animator’s reference view. For more information about coordinate systems, see UIDynamicAnimator Class Reference.
     Returns	The initialized attachment behavior, or nil if there was a problem initializing the object.
     
     */
    
    UIAttachmentBehavior *attach1 = [[UIAttachmentBehavior alloc]initWithItem:self.boxView2 offsetFromCenter:UIOffsetMake(0, 0) attachedToAnchor:self.boxView1.center];
    self.attachBehavior = attach1;
    [self.dynamicAnimator addBehavior:attach1];
}

- (void) handlePan:(UIPanGestureRecognizer *)paramPan
{
    CGPoint tapPoint = [paramPan locationInView:self.view];
    
    [self.attachBehavior setAnchorPoint:tapPoint];
    
    self.boxView1.center = tapPoint;
}


- (IBAction)resetBehavior:(id)sender
{
    [self.dynamicAnimator removeAllBehaviors];
    self.boxView1.center = CGPointMake(kScreenWidth / 2.0f - 100, kScreenHeight / 2.0f - 100);
    self.boxView1.transform = CGAffineTransformIdentity;
    
    self.boxView2.center = CGPointMake(kScreenWidth / 2.0f + 50 , kScreenHeight / 2.0f - 100);
}

- (IBAction)pushBehavior:(id)sender
{
    UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[self.boxView1, self.boxView2] mode:UIPushBehaviorModeInstantaneous];
    push.pushDirection = CGVectorMake(0, 1);
    
    [self.dynamicAnimator addBehavior:push];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
