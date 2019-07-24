//
//  PushAnimation.m
//  NavigationCustomPop
//
//  Created by jiang on 2019/7/24.
//  Copyright © 2019 jarvis. All rights reserved.
//

#import "PushAnimation.h"
@interface PushAnimation ()<CAAnimationDelegate>
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@end

@implementation PushAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    // animation1
    UIView *btnView = [fromViewController.view viewWithTag:10];
    UIView *toBtnView = [toViewController.view viewWithTag:20];
    CGRect toFrame = toBtnView.frame;
//    toBtnView.frame = btnView.frame;
//    [UIView animateWithDuration:0.25 animations:^{
//        toBtnView.frame = toFrame;
//    }completion:^(BOOL finished) {
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
//    }];
    //animation2
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRect:btnView.frame];
    CGPoint finalPoint;
    //判断触发点在那个象限
    if(btnView.frame.origin.x > (toViewController.view.bounds.size.width / 2)){
        if (btnView.frame.origin.y < (toViewController.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(0, CGRectGetMaxY(toViewController.view.frame));
        }else{
            //第四象限
            finalPoint = CGPointMake(0, 0);
        }
    }else{
        if (btnView.frame.origin.y < (toViewController.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(CGRectGetMaxX(toViewController.view.frame), CGRectGetMaxY(toViewController.view.frame));
        }else{
            //第三象限
            finalPoint = CGPointMake(CGRectGetMaxX(toViewController.view.frame), 0);
        }
    }
    CGPoint startPoint = CGPointMake(btnView.center.x, btnView.center.y);
    CGFloat radius = sqrt((finalPoint.x-startPoint.x) * (finalPoint.x-startPoint.x) + (finalPoint.y-startPoint.y) * (finalPoint.y-startPoint.y)) - sqrt(btnView.frame.size.width/2 * btnView.frame.size.width/2 + btnView.frame.size.height/2 * btnView.frame.size.height/2);
//    UIBezierPath *endPath = [UIBezierPath bezierPathWithRect:toViewController.view.frame];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(btnView.frame, -radius, -radius)];

    //赋值给toVc视图layer的mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath;
    toViewController.view.layer.mask = maskLayer;
    CABasicAnimation *maskAnimation =[CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id)startPath.CGPath;
    maskAnimation.toValue = (__bridge id)endPath.CGPath;
    maskAnimation.duration = [self transitionDuration:transitionContext];
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskAnimation.delegate = self;
    [maskLayer addAnimation:maskAnimation forKey:@"path"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}
@end
