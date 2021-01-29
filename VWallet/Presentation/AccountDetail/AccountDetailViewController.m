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
#import "TransactionListType.h"
#import "UIViewController+NavigationBar.h"
#import "UIScrollView+EmptyData.h"

#import "TransactionOperateViewController.h"
#import "ReceiveViewController.h"
#import "TokenViewController.h"
#import "TransactionDetailViewController.h"
#import "UIViewController+Alert.h"
#import "AddressDetailViewController.h"
#import "NSString+Asterisk.h"
#import "NSString+Decimal.h"
#import "TransactionRecordsPageViewController.h"
#import "TokenMgr.h"
#import "MessageSignViewController.h"
#import "DepositWithdrawViewController.h"

static NSString *const CellIdentifier = @"TransactionTableViewCell";
static NSInteger const TransactionPageSize = 100;

@interface AccountDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Account *account;

@property (weak, nonatomic) IBOutlet UIView *naviBar;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet AccountDetailHeadView *headView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<Transaction *> *transactionArray;

@property (nonatomic, strong) NSArray<VsysToken *> *watchingTokenArray;

@property (strong, nonatomic) NSMutableDictionary *canceledLeaseTx;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) BOOL loading;

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
    [self initData];
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
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refresh;
}

- (void)initData {
    [self loadCertifiedTokenInfo];
    self.canceledLeaseTx = [NSMutableDictionary new];
    self.page = 1;
    [self loadTransaction:self.page];
}

- (void)loadCertifiedTokenInfo {
    NSArray<VsysToken *> *watchedList = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
    self.watchingTokenArray = watchedList;
    for (VsysToken *one in watchedList) {
        NSInteger index = [watchedList indexOfObject:one];
        __weak typeof(self) weakSelf = self;
        [ApiServer getTokenInfo:one.tokenId callback:^(BOOL isSuc, VsysToken * _Nonnull token) {
            [ApiServer getContractContent:VsysTokenId2ContractId(token.tokenId) callback:^(BOOL isSuc, ContractContent * _Nonnull contractContent) {
                watchedList[index].unity = token.unity;
                if (contractContent.textual && contractContent.textual.descriptors) {
                    token.textualDescriptor = contractContent.textual.descriptors;
                    NSString *funcJson = VsysDecodeContractTexture(token.textualDescriptor);
                    if ([funcJson containsString:@"split"]) {
                        watchedList[index].splitable = true;
                    }
                }
                weakSelf.watchingTokenArray = watchedList;
                [TokenMgr.shareInstance saveToStorage:self.account.originAccount.address list:[watchedList mutableCopy]];
            }];
        }];
    }
}

- (void)refreshData {
    [self loadTransaction:1];
}

- (void)loadTransaction:(NSInteger)page {
    if (self.loading) {
        return;
    }
    self.loading = YES;
    __weak typeof(self) weakSelf = self;
    [ApiServer transactionList:self.account.originAccount.address offset:(page - 1) * TransactionPageSize limit:TransactionPageSize type:TransactionListTypeAll callback:^(BOOL isSuc, NSArray<Transaction *> * _Nonnull txArr) {
        if (txArr.count < TransactionPageSize) {
            self.hasMore = NO;
        }else {
            self.hasMore = YES;
        }
        weakSelf.tableView.ed_loading = NO;
        weakSelf.loading = NO;
        [weakSelf.tableView.refreshControl endRefreshing];
        
        NSArray<VsysToken *> *watchedList = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
        NSMutableArray<NSString *> *watchedCertifiedList = [NSMutableArray new];
        for (VsysToken *one in watchedList) {
            [watchedCertifiedList addObject: VsysTokenId2ContractId(one.tokenId)];
        }
        
        NSMutableArray<Transaction *> *txs = [NSMutableArray new];
        for (Transaction *one in txArr) {
            if (one.transactionType == 4) {
                weakSelf.canceledLeaseTx[one.originTransaction.txId] = @(YES);
            }
            if (one.transactionType == 3 && one.canCancel) {
                if (weakSelf.canceledLeaseTx[one.originTransaction.txId] || !one.canCancel) {
                    one.canCancel = NO;
                }else {
                    one.canCancel = YES;
                }
            }
            if (one.transactionType == 9) {
                if ([watchedCertifiedList containsObject:one.originTransaction.contractId]) {
                    VsysToken *t  = [self getWatchingTokenInfo:one.originTransaction.contractId];
                    if(!t) {
                        continue;
                    }
                    one.symbol = t.name;
                    one.unity = t.unity;
                    one.contractFuncName = [one getFunctionName:t];
                    if ([one.contractFuncName isEqualToString:VsysActionSend]) {
                        VsysContract *contract = [VsysContract new];
                        if([t isNFTToken]) {
                            [contract decodeNFTSend:one.originTransaction.data];
                            one.contractFuncName = VsysActionSend;
                        }else {
                            [contract decodeSend:one.originTransaction.data];
                        }
                        one.originTransaction.recipient = contract.recipient;
                        one.originTransaction.amount = contract.amount;
                    }else if([one.contractFuncName isEqualToString:VsysActionDeposit]) {
                        VsysContract *contract = [VsysContract new];
                        [contract decodeDeposit:one.originTransaction.data];
                        one.originTransaction.recipient = contract.contractId;
                        one.originTransaction.amount = contract.amount;
                    } else if([one.contractFuncName isEqualToString:VsysActionWithdraw]) {
                        VsysContract *contract = [VsysContract new];
                        [contract decodeWithdraw:one.originTransaction.data];
                        one.senderAddress = contract.contractId;
                        one.originTransaction.amount = contract.amount;
                    }
                    one.originTransaction.tokenIdx = VsysTokenId2TokenIdx(t.tokenId);
                }
            }
            [txs addObject:one];
            if ([one.senderAddress isEqualToString:one.originTransaction.recipient]) {
                Transaction *sameTrx = [one mutableCopy];
                sameTrx.direction = @"in";
                [txs addObject:sameTrx];
            }
        }
        self.page = page;
        if (page == 1) {
            [weakSelf.transactionArray removeAllObjects];
            [weakSelf.transactionArray addObjectsFromArray:txs];
        }else {
            [weakSelf.transactionArray addObjectsFromArray:txs];
        }
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
    Transaction *tx = self.transactionArray[indexPath.row];
    cell.transaction = tx;
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

#pragma mark - UITableView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    if (currentOffsetY + scrollView.frame.size.height  > scrollView.contentSize.height &&  self.tableView.refreshControl.isRefreshing == NO && self.hasMore) {
        [self loadTransaction:self.page + 1];
    }
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
- (IBAction)recordsBtnClick:(id)sender {
    TransactionRecordsPageViewController *transactionRecordsPageVC = [[TransactionRecordsPageViewController alloc] initWithAccount:self.account transationArray:self.transactionArray];
    [self.navigationController pushViewController:transactionRecordsPageVC animated:YES];
}

#pragma mark - Token
- (IBAction)tokenBtnClick {
    TokenViewController *tokenVC = [[TokenViewController alloc] initWithAccount:self.account];
    [self.navigationController pushViewController:tokenVC animated:YES];
}

- (IBAction)moreOperateBtnClick {
    __weak typeof(self) weakSelf = self;
    [self actionSheetWithSelectedIndex:-1 withActionDatas:@[VLocalize(@"action.address.detail"), VLocalize(@"action.address.copy"), VLocalize(@"action.address.records"), VLocalize(@"action.address.message.sign"), VLocalize(@"action.address.deposit"), VLocalize(@"action.address.withdraw")] handler:^(NSInteger index) {
        if (index == 0) {
            AddressDetailViewController *addressDetailsVC = [VStoryboard.Address instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
            [addressDetailsVC updateAccout:self.account];
            addressDetailsVC.popToRoot = YES;
            [weakSelf.navigationController pushViewController:addressDetailsVC animated:YES];
        } else if (index == 1) {
            UIPasteboard.generalPasteboard.string = weakSelf.account.originAccount.address;
            [weakSelf remindWithMessage:VLocalize(@"tip.account.address.copy.success")];
        } else if (index == 2) {
            TransactionRecordsPageViewController *transactionRecordsPageVC = [[TransactionRecordsPageViewController alloc] initWithAccount:self.account transationArray:self.transactionArray];
            [self.navigationController pushViewController:transactionRecordsPageVC animated:YES];
        } else if (index == 3) {
            MessageSignViewController *messageSignVc = [[MessageSignViewController alloc] initWithAccount:self.account];
            [self.navigationController pushViewController:messageSignVc animated:YES];
        } else if (index == 4) {
            DepositWithdrawViewController *depositVc = [[DepositWithdrawViewController alloc] initWithAccount:self.account operateType:TransactionOperateTypeDeposit];
            [self.navigationController pushViewController:depositVc animated:YES];
        } else if (index == 5) {
            DepositWithdrawViewController *withdrawVc = [[DepositWithdrawViewController alloc] initWithAccount:self.account operateType:TransactionOperateTypeWithdraw];
            [self.navigationController pushViewController:withdrawVc animated:YES];
        }
    }];
}

#pragma mark - Back
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray<Transaction *> *)transactionArray {
    if (_transactionArray == nil) {
        _transactionArray = [NSMutableArray new];
    }
    return _transactionArray;
}

- (VsysToken *) getWatchingTokenInfo:(NSString *)contractId {
    for (VsysToken *one in self.watchingTokenArray) {
        if ([one.contractId isEqualToString:contractId]) {
            return one;
        }
    }
    return nil;
}

@end
