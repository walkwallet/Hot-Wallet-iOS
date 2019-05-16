//
//  AlertNavControllerDelegate.m
//  Wallet
//
//  All rights reserved.
//

#import "AlertNavControllerDelegate.h"
#import "PushAnimatorObject.h"
#import "PopAnimatorObject.h"
@import UIKit;

@interface AlertNavControllerDelegate()

@property (nonatomic, strong) PopAnimatorObject *popAnimator;
@property (nonatomic, strong) PushAnimatorObject *pushAnimator;

@end
@implementation AlertNavControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        if (!self.pushAnimator) {
            self.pushAnimator = [[PushAnimatorObject alloc] init];
        }
        return self.pushAnimator;
    }
    
    if (operation == UINavigationControllerOperationPop) {
        if (!self.popAnimator) {
            self.popAnimator = [[PopAnimatorObject alloc] init];
        }
        return self.popAnimator;
    }
    
    return nil;
}

@end
