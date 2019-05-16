//
//  VerticalAnimatorDelegate.m
//  Wallet
//
//  All rights reserved.
//

#import "VerticalAnimatorDelegate.h"
#import "VerticalPushAnimator.h"
#import "VerticalPopAnimator.h"
@import UIKit;

@interface VerticalAnimatorDelegate()

@property (nonatomic, strong) VerticalPopAnimator *popAnimator;
@property (nonatomic, strong) VerticalPushAnimator *pushAnimator;

@end

@implementation VerticalAnimatorDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        if (!self.pushAnimator) {
            self.pushAnimator = [[VerticalPushAnimator alloc] init];
        }
        return self.pushAnimator;
    }
    
    if (operation == UINavigationControllerOperationPop) {
        if (!self.popAnimator) {
            self.popAnimator = [[VerticalPopAnimator alloc] init];
        }
        return self.popAnimator;
    }
    
    return nil;
}

@end
