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
#import "Masonry.h"
#import "UIViewController+NavigationBar.h"

@interface WalletPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIView *topWrapView;

@property (nonatomic, strong) WalletHeadSegmentedView *segmentedView;

@property (nonatomic, strong) NSArray *childVCArray;

@property (nonatomic, weak) UIViewController *pendingViewController;

@end

@implementation WalletPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)initView {
    [WalletMgr.shareInstance loadWallet: WalletMgr.shareInstance.password];
    [self.view addSubview:self.topWrapView];
    [self.topWrapView addSubview:self.segmentedView];
    [self.topWrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
        } else {
            make.height.mas_equalTo(64);
        };
    }];
    [self.segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.topWrapView);
            make.height.mas_equalTo(44);
    }];
    self.view.backgroundColor = VColor.rootViewBgColor;
    self.dataSource = self;
    self.delegate = self;
    self.childVCArray = @[
        [[AccountTableViewController alloc] initWithAccountType:AccountTypeWallet],
        [[AccountTableViewController alloc] initWithAccountType:AccountTypeMonitor]];
    [self setViewControllers:@[self.childVCArray.firstObject] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeToWhiteNavigationBar];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeToWhiteNavigationBar];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : VColor.textColor};
    self.navigationController.navigationBar.tintColor = VColor.navigationTintColor;
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar layoutIfNeeded];
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

- (UIView *)topWrapView {
    if (!_topWrapView) {
        _topWrapView = [[UIView alloc] init];
        _topWrapView.backgroundColor = UIColor.whiteColor;
    }
    return _topWrapView;
}

- (WalletHeadSegmentedView *)segmentedView {
    if (!_segmentedView) {
        __weak typeof(self) weakSelf = self;
        _segmentedView = [[WalletHeadSegmentedView alloc] initWithSelectedBlock:^(NSInteger oldIndex, NSInteger newIndex) {
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
    }
    
    return _segmentedView;
}

@end
