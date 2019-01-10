//
// AccountDetailViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountDetailViewController.h"
#import "VStoryboard.h"
#import "Language.h"
#import "VColor.h"
#import "Account.h"
#import "ApiServer.h"

#import "LoadingView.h"
#import "AccountDetailHeadView.h"
#import "TransactionTableHeadView.h"
#import "TransactionTableViewCell.h"
#import "UIViewController+NavigationBar.h"
#import "UIScrollView+EmptyData.h"

#import "TransactionOperateViewController.h"
#import "ReceiveViewController.h"
#import "TransactionRecordsPageViewController.h"
#import "TransactionDetailViewController.h"
#import "UIViewController+Alert.h"
#import "AddressDetailViewController.h"
#import "NSString+Asterisk.h"

static NSString *const CellIdentifier = @"TransactionTableViewCell";

@interface AccountDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Account *account;

@property (weak, nonatomic) IBOutlet UIView *naviBar;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet AccountDetailHeadView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<Transaction *> *transactionArray;

@end

@implementation AccountDetailViewController

- (instancetype)initWithAccount:(Account *)account{
    self = [VStoryboard.Wallet instantiateViewControllerWithIdentifier:@"AccountDetailViewController"];
    self.account = account;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self setupNaviBar];
    self.headView.account = self.account;
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView ed_setupEmptyDataDisplay];
    CGFloat offsetY = CGRectGetHeight(self.headView.bounds) - (CGRectGetHeight(UIScreen.mainScreen.bounds) - CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame) - 44) / 2 + self.tableView.sectionHeaderHeight;
    self.tableView.ed_loading_offset = offsetY + 50;
    self.tableView.ed_empty_offset = offsetY + 70;
    self.tableView.ed_loading = YES;
    
    __weak typeof(self) weakSelf = self;
    [ApiServer transactionList:self.account.originAccount.address callback:^(BOOL isSuc, NSArray<Transaction *> * _Nonnull txArr) {
        weakSelf.tableView.ed_loading = NO;
        weakSelf.transactionArray = txArr;
        [weakSelf.tableView reloadData];
    }];
}

- (void)getAccountInfo {
    __weak typeof(self) weakSelf = self;
    [ApiServer addressBalanceDetail:self.account callback:^(BOOL isSuc, Account * _Nonnull account) {
        if (isSuc && account) {
            weakSelf.headView.account = account;
        }
    }];
}

- (void)setupNaviBar {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.locations = @[@0, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 44 + CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame));
//    NSString *prevPageTitle;
    switch (self.account.accountType) {
        case AccountTypeWallet: {
            gradientLayer.colors = @[(__bridge id)VColor.lightOrangeColor.CGColor, (__bridge id)VColor.mediumOrangeColor.CGColor];
//            prevPageTitle = VLocalize(@"nav.title.wallet");
        } break;
        case AccountTypeMonitor: {
            gradientLayer.colors = @[(__bridge id)VColor.lightBlueColor.CGColor, (__bridge id)VColor.mediumBlueColor.CGColor];
//            prevPageTitle = VLocalize(@"nav.title.monitor");
        } break;
    }
    [self.naviBar.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.backBtn setTitle:[self.account.originAccount.address explicitCount:12 maxAsteriskCount:6] forState:UIControlStateNormal];
    
//    [self.backBtn setTitle:prevPageTitle?:@"" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getAccountInfo];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeToThemeNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.transaction = self.transactionArray[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[TransactionTableHeadView alloc] initWithTitle:VLocalize(@"account.detail.transaction.records")];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransactionDetailViewController *detailVC = [[TransactionDetailViewController alloc] initWithTransaction:self.transactionArray[indexPath.row] account:self.account];
    detailVC.isDetailPage = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Send
- (IBAction)sendBtnClick {
    TransactionOperateViewController *sendVC = [[TransactionOperateViewController alloc] initWithAccount:self.account operateType:TransactionOperateTypeSend];
    [self.navigationController pushViewController:sendVC animated:YES];
}

#pragma mark - Receive
- (IBAction)receiveBtnClick {
    ReceiveViewController *receiveVC = [[ReceiveViewController alloc] initWithAccount:self.account];
    [self.navigationController pushViewController:receiveVC animated:YES];
}

#pragma mark - Lease
- (IBAction)leaseBtnClick {
    TransactionOperateViewController *leaseVC = [[TransactionOperateViewController alloc] initWithAccount:self.account operateType:TransactionOperateTypeLease];
    [self.navigationController pushViewController:leaseVC animated:YES];
}

#pragma mark - Records
- (IBAction)recordsBtnClick {
    TransactionRecordsPageViewController *transactionRecordsPageVC = [[TransactionRecordsPageViewController alloc] initWithAccount:self.account transationArray:self.transactionArray];
    [self.navigationController pushViewController:transactionRecordsPageVC animated:YES];
}

- (IBAction)moreOperateBtnClick {
    __weak typeof(self) weakSelf = self;
    [self actionAheetWithSelectedIndex:-1 withActionDatas:@[VLocalize(@"action.address.detail"), VLocalize(@"action.address.copy")] handler:^(NSInteger index) {
        if (index == 0) {
            AddressDetailViewController *addressDetailsVC = [VStoryboard.Address instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
            [addressDetailsVC updateAccout:self.account];
            addressDetailsVC.popToRoot = YES;
            [weakSelf.navigationController pushViewController:addressDetailsVC animated:YES];
        } else if (index == 1) {
            UIPasteboard.generalPasteboard.string = weakSelf.account.originAccount.address;
            [weakSelf remindWithMessage:VLocalize(@"tip.account.address.copy.success")];
        }
    }];
}

#pragma mark - Back
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
