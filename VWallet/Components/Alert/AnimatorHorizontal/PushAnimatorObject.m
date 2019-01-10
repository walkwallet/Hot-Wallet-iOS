//
//  PushAnimatorObject.m
//  Wallet
//
//  All rights reserved.
//

#import "PushAnimatorObject.h"

@implementation PushAnimatorObject

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return .2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    [toView setFrame:CGRectMake(CGRectGetWidth(toView.bounds), 0, CGRectGetWidth(toView.bounds), CGRectGetHeight(toView.bounds))];
    
    [[transitionContext containerView] addSubview:toView];
    
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    
    [UIView animateWithDuration: [self transitionDuration:transitionContext]
                     animations:^{
                         [toView setFrame:toViewFinalFrame];
                     }
                     completion:^(BOOL finished) {
                         if (![transitionContext transitionWasCancelled]) {
                             [fromView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }
                         else {
                             [toView removeFromSuperview];
                             [transitionContext completeTransition:NO];
                         }
                     }];
}

@end
