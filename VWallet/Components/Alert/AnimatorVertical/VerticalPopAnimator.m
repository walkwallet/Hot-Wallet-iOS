//
//  VerticalPopAnimator.m
//  Wallet
//
//  All rights reserved.
//

#import "VerticalPopAnimator.h"

@implementation VerticalPopAnimator


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGRect thumbFrame = CGRectMake(0, CGRectGetHeight(fromView.bounds), CGRectGetWidth(fromView.bounds), CGRectGetHeight(fromView.bounds));
    
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         [fromView setFrame:thumbFrame];
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
