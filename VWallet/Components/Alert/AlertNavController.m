//
//  AlertNavController.m
//  Wallet
//
//  All rights reserved.
//

#import "AlertNavController.h"
#import "AlertNavControllerDelegate.h"

@interface AlertNavController () <UINavigationControllerDelegate>
@property (nonatomic, strong) AlertNavControllerDelegate *navigationDelegate;
@end

@implementation AlertNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.navigationDelegate = [AlertNavControllerDelegate new];
    self.delegate = _navigationDelegate;
    self.navigationBarHidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView animateWithDuration:.2f animations:^{
        self.presentingViewController.view.layer.opacity = 0.7f;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:.2f animations:^{
        self.presentingViewController.view.layer.opacity = 1.f;
    }];
}

@end
