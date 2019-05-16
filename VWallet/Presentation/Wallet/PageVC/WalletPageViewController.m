//
//  WalletPageViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "WalletPageViewController.h"
#import "Language.h"
#import "WalletHeadSegmentedView.h"
#import "AccountTableViewController.h"
#import "WalletMgr.h"
#import "VColor.h"
#import "UIImage+Color.h"
#import "UIViewController+NavigationBar.h"

@interface WalletPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) WalletHeadSegmentedView *segmentedView;

@property (nonatomic, strong) NSArray *childVCArray;

@property (nonatomic, weak) UIViewController *pendingViewController;

@end

@implementation WalletPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [WalletMgr.shareInstance loadWallet: WalletMgr.shareInstance.password];
    self.navigationItem.title = VLocalize(@"nav.title.wallet");
    self.view.backgroundColor = VColor.rootViewBgColor;
    self.dataSource = self;
    self.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.segmentedView = [[WalletHeadSegmentedView alloc] initWithSelectedBlock:^(NSInteger oldIndex, NSInteger newIndex) {
        if (newIndex >= 0 && newIndex < weakSelf.childVCArray.count) {
            weakSelf.view.userInteractionEnabled = NO;
            [weakSelf setViewControllers:@[weakSelf.childVCArray[newIndex]]
                               direction:(newIndex > oldIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse)
                                animated:YES
                              completion:^(BOOL finished) {
                                  weakSelf.view.userInteractionEnabled = finished;
                              }];
        }
    }];
    self.navigationItem.titleView = self.segmentedView;
    self.childVCArray = @[[[AccountTableViewController alloc] initWithAccountType:AccountTypeWallet],
                          [[AccountTableViewController alloc] initWithAccountType:AccountTypeMonitor]];
    [self setViewControllers:@[self.childVCArray.firstObject] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeToWhiteNavigationBar];
}

#pragma mark - UIPageViewController DataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.segmentedView.currentIndex < self.childVCArray.count - 1) {
        return self.childVCArray[self.segmentedView.currentIndex + 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (self.segmentedView.currentIndex > 0) {
        return self.childVCArray[self.segmentedView.currentIndex - 1];
    }
    return nil;
}

#pragma mark - UIPageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.pendingViewController = pendingViewControllers.firstObject;
    self.view.userInteractionEnabled = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.view.userInteractionEnabled = finished;
    if (finished && completed && self.pendingViewController != previousViewControllers.firstObject) {
        self.segmentedView.currentIndex = [self.childVCArray indexOfObject:self.pendingViewController];
    }
}

@end
