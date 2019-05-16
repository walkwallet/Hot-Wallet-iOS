//
// TransactionRecordsPageViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionRecordsPageViewController.h"
#import <Masonry.h>
#import "VStoryboard.h"
#import "Language.h"
#import "Account.h"
#import "TransactionRecordHeadSegmentedView.h"
#import "DateRangeView.h"
#import "TransactionTableViewController.h"
#import "DateRangePickerViewController.h"

@interface TransactionRecordsPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) NSArray<Transaction *> *transactionArray;
@property (nonatomic, weak) Account *account;

@property (nonatomic, strong) UIPageViewController *pageVC;
@property (weak, nonatomic) IBOutlet TransactionRecordHeadSegmentedView *segmentedView;
@property (weak, nonatomic) IBOutlet DateRangeView *dateRangeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateRangeViewHeightLC;
@property (nonatomic, strong) NSArray<UIViewController *> *childVCArray;
@property (nonatomic, weak) UIViewController *pendingViewController;

@end

@implementation TransactionRecordsPageViewController

- (instancetype)initWithAccount:(Account *)account transationArray:(NSArray<Transaction *> *)transactionArray {
    self = [VStoryboard.Wallet instantiateViewControllerWithIdentifier:@"TransactionRecordsPageViewController"];
    self.account = account;
    self.transactionArray = transactionArray;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self addChildViewController:_pageVC];
        [self.view insertSubview:_pageVC.view belowSubview:self.segmentedView];
        __weak typeof(self) weakSelf = self;
        [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.dateRangeView.mas_bottom);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
    }
    return _pageVC;
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.transaction.records");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterBtnLick)];
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedView setSelectedBlock:^(NSInteger oldIndex, NSInteger newIndex) {
        if (newIndex >= 0 && newIndex < self.childVCArray.count) {
            [weakSelf.pageVC setViewControllers:@[weakSelf.childVCArray[newIndex]]
                                      direction:(newIndex > oldIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse)
                                       animated:YES completion:nil];
        }
    }];
    self.childVCArray = @[[[TransactionTableViewController alloc] initWithListType:TransactionListTypeAll transactionArray:self.transactionArray account:self.account],
                          [[TransactionTableViewController alloc] initWithListType:TransactionListTypeSent transactionArray:self.transactionArray account:self.account],
                          [[TransactionTableViewController alloc] initWithListType:TransactionListTypeReceive transactionArray:self.transactionArray account:self.account],
                          [[TransactionTableViewController alloc] initWithListType:TransactionListTypeLease transactionArray:self.transactionArray account:self.account]];
    [self.pageVC setViewControllers:@[self.childVCArray.firstObject] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    [self setDateRangeType:DateRangeTypeNone startTimestamp:0 endTimestamp:0 animated:NO];
    
    for (UIView *subV in self.pageVC.view.subviews) {
        if ([subV isKindOfClass:UIScrollView.class]) {
            [((UIScrollView *)subV).panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
            break;
        }
    }
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
    self.pageVC.view.userInteractionEnabled = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.pageVC.view.userInteractionEnabled = finished;
    if (finished && completed && self.pendingViewController != previousViewControllers.firstObject) {
        self.segmentedView.currentIndex = [self.childVCArray indexOfObject:self.pendingViewController];
    }
}

#pragma mark - date select
- (void)filterBtnLick {
    __weak typeof(self) weakSelf = self;
    DateRangePickerViewController *pickerVC = [[DateRangePickerViewController alloc] initWithRangeType:self.dateRangeView.rangeType startTimestamp:self.dateRangeView.startTimestamp endTimestamp:self.dateRangeView.endTimestamp result:^(DateRangeType rangType, NSTimeInterval startTimestamp, NSTimeInterval endTimestamp) {
        [weakSelf setDateRangeType:rangType startTimestamp:startTimestamp endTimestamp:endTimestamp animated:YES];
    }];
    [self.navigationController pushViewController:pickerVC animated:YES];
}

- (void)setDateRangeType:(DateRangeType)rangType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp animated:(BOOL)animated {
    [self.dateRangeView setDateRangeType:rangType startTimestamp:startTimestamp endTimestamp:endTimestamp];
    if (self.dateRangeView.rangeType == DateRangeTypeNone && self.dateRangeViewHeightLC.constant > 0) {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.dateRangeViewHeightLC.constant = 0;
                [self.view layoutIfNeeded];
            }];
        } else {
            self.dateRangeViewHeightLC.constant = 0;
        }
    } else if (self.dateRangeView.rangeType != DateRangeTypeNone && self.dateRangeViewHeightLC.constant == 0) {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.dateRangeViewHeightLC.constant = 44;
                [self.view layoutIfNeeded];
            }];
        } else {
            self.dateRangeViewHeightLC.constant = 44;
        }
    }
    for (TransactionTableViewController *transactionListVC in self.childVCArray) {
        [transactionListVC setDateRangeType:self.dateRangeView.rangeType startTimestamp:self.dateRangeView.startTimestamp endTimestamp:self.dateRangeView.endTimestamp];
    }
}

- (IBAction)closeDateRange {
    [self setDateRangeType:DateRangeTypeNone startTimestamp:0 endTimestamp:0 animated:YES];
}

@end
