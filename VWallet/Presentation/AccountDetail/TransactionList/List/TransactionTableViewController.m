//
// TransactionTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionTableViewController.h"
#import "TransactionTableViewCell.h"
#import "Transaction.h"
#import "TransactionDetailViewController.h"
#import "UIScrollView+EmptyData.h"
#import "UIViewController+NavigationBar.h"
#import "ApiServer.h"
#import "NSString+Decimal.h"
#import "TokenMgr.h"

static NSString *const CellIdentifier = @"TransactionTableViewCell";

static NSInteger const TransactionPageSize = 100;

@interface TransactionTableViewController ()

@property (nonatomic, assign) TransactionListType listType;
@property (nonatomic, weak) Account *account;

@property (nonatomic, weak) NSArray<Transaction *> *transactionArray;

@property (nonatomic, strong) NSArray<Transaction *> *showAllTransactionArray;

@property (nonatomic, strong) NSArray<Transaction *> *showTransactionArray;

@property (nonatomic, strong) NSArray<NSString *> *canceledTxIdArray;

@property (nonatomic, strong) NSArray<VsysToken *> *watchingTokenArray;

@property (nonatomic) DateRangeType dateTrangeType;

@property (nonatomic) NSTimeInterval startTimestamp;

@property (nonatomic) NSTimeInterval endTimestamp;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) BOOL loading;

@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

@implementation TransactionTableViewController

- (instancetype)initWithListType:(TransactionListType)listType transactionArray:(NSArray<Transaction *> *)transactionArray account:(nonnull Account *)account {
    if (self = [super init]) {
        self.listType = listType;
        self.transactionArray = transactionArray;
        self.account = account;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeToThemeNavigationBar];
}

- (void)initView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 57;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView ed_setupEmptyDataDisplay];
    self.tableView.ed_empty_offset = -100;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)initData {
    [self loadWatchingTokenInfo];
    self.page = 1;
    [self loadTransaction:self.page];
}

- (void)loadWatchingTokenInfo {
    self.watchingTokenArray = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
}

- (void)loadTransaction:(NSInteger)page {
    if (self.loading) {
        [self.refreshControl endRefreshing];
        return;
    }
    self.loading = YES;
    __weak typeof (self) weakSelf = self;
    [ApiServer transactionList:self.account.originAccount.address offset:(page - 1) * TransactionPageSize limit:TransactionPageSize type:[self getListTypeFormat:self.listType] callback:^(BOOL isSuc, NSArray<Transaction *> * _Nonnull txArr) {
        if (txArr.count < TransactionPageSize) {
            weakSelf.hasMore = NO;
        }else {
            weakSelf.hasMore = YES;
        }

        if (weakSelf.listType == TransactionListTypeExecuteContract || weakSelf.listType == TransactionListTypeAll) {
            NSArray<VsysToken *> *watchedList = [TokenMgr.shareInstance loadAddressWatchToken:self.account.originAccount.address];
            NSMutableArray<NSString *> *watchedCertifiedList = [NSMutableArray new];
            for (VsysToken *one in watchedList) {
                [watchedCertifiedList addObject: VsysTokenId2ContractId(one.tokenId)];
            }
            
            for (Transaction *one in txArr) {
                NSInteger index = [txArr indexOfObject:one];
                if (one.transactionType == 9) {
                    if ([watchedCertifiedList containsObject:one.originTransaction.contractId]) {
                        VsysToken *t  = [self getWatchingTokenInfo:one.originTransaction.contractId];
                        txArr[index].contractFuncName = [one getFunctionName:t];
                        if ([txArr[index].contractFuncName isEqualToString:VsysActionSend]) {
                            VsysToken *t = [TokenMgr.shareInstance getTokenByAddress:weakSelf.account.originAccount.address tokenId:VsysContractId2TokenId(one.originTransaction.contractId, one.originTransaction.tokenIdx)];
                            VsysContract *contract = [VsysContract new];
                            if([t isNFTToken]) {
                                [contract decodeNFTSend:one.originTransaction.data];
                            }else {
                                [contract decodeSend:one.originTransaction.data];
                            }
                            txArr[index].originTransaction.recipient = contract.recipient;
                            txArr[index].symbol = t.name;
                            txArr[index].unity = t.unity;
                            txArr[index].originTransaction.amount = contract.amount;
                        }
                        txArr[index].originTransaction.tokenIdx = VsysTokenId2TokenIdx(t.tokenId);
                    }
                }
            }
        }else if (weakSelf.listType == TransactionListTypeLease) {
            [self formatLeasingTxs:txArr page:page];
            return;
        }
        NSMutableArray<Transaction *> *tmpTxs = [NSMutableArray new];
        if (page > 1) {
            [tmpTxs addObjectsFromArray:self.transactionArray];
        }
        [tmpTxs addObjectsFromArray:txArr];
        weakSelf.loading = NO;
        self.page = page;
        self.transactionArray = tmpTxs;
        self.showAllTransactionArray = tmpTxs;
        [weakSelf setDateRangeType:weakSelf.dateTrangeType startTimestamp:weakSelf.startTimestamp endTimestamp:weakSelf.endTimestamp];
    }];
}

- (void)formatLeasingTxs:(NSArray<Transaction*> *)leasingTxs page:(NSInteger)page {
    __weak typeof (self) weakSelf = self;
    [ApiServer transactionList:weakSelf.account.originAccount.address offset:(page - 1) * TransactionPageSize limit:TransactionPageSize type:VsysTxTypeCancelLease callback:^(BOOL isSuc, NSArray<Transaction *> * _Nonnull txArr) {
        weakSelf.loading = NO;
        NSMutableArray<NSString *> *tmpCancelIdList = [NSMutableArray new];
        if (page > 1) {
            [tmpCancelIdList addObjectsFromArray:weakSelf.canceledTxIdArray];
        }
        for (Transaction *one in txArr) {
            [tmpCancelIdList addObject:one.originTransaction.txId];
        }
        weakSelf.canceledTxIdArray = tmpCancelIdList;
        for (Transaction *one in leasingTxs) {
            NSInteger index = [leasingTxs indexOfObject:one];
            if ([tmpCancelIdList containsObject:one.originTransaction.txId]) {
                leasingTxs[index].canCancel = NO;
            }else {
                leasingTxs[index].canCancel = YES;
            }
        }
        weakSelf.transactionArray = leasingTxs;
        weakSelf.showAllTransactionArray = leasingTxs;
        [weakSelf setDateRangeType:weakSelf.dateTrangeType startTimestamp:weakSelf.startTimestamp endTimestamp:weakSelf.endTimestamp];
        weakSelf.page = page;
    }];
}

- (void)refresh {
    [self loadTransaction:1];
}

- (void)setDateRangeType:(DateRangeType)dateRangeType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp {
    [self.refreshControl endRefreshing];
    self.dateTrangeType = dateRangeType;
    self.startTimestamp = startTimestamp;
    self.endTimestamp = endTimestamp;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT), ^{
        NSMutableArray<Transaction *> *showTransactionArray = [NSMutableArray array];
        switch (dateRangeType) {
            case DateRangeTypeNone:
                showTransactionArray = weakSelf.showAllTransactionArray.copy;
                break;
            case DateRangeTypePath1Month: {
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
                int64_t minTimestamp = [calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:NSDate.date options:NSCalendarWrapComponents].timeIntervalSince1970 * VTimestampMultiple;
                [weakSelf.showAllTransactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.originTransaction.timestamp >= minTimestamp) {
                        [showTransactionArray addObject:obj];
                    }
                }];
            } break;
            case DateRangeTypePath3Months: {
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
                int64_t minTimestamp = [calendar dateByAddingUnit:NSCalendarUnitMonth value:-3 toDate:NSDate.date options:NSCalendarWrapComponents].timeIntervalSince1970 * VTimestampMultiple;
                [weakSelf.showAllTransactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.originTransaction.timestamp >= minTimestamp) {
                        [showTransactionArray addObject:obj];
                    }
                }];
            } break;
            case DateRangeTypePath1Year: {
                NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
                int64_t minTimestamp = [calendar dateByAddingUnit:NSCalendarUnitYear value:-1 toDate:NSDate.date options:NSCalendarWrapComponents].timeIntervalSince1970 * VTimestampMultiple;
                [weakSelf.showAllTransactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.originTransaction.timestamp >= minTimestamp) {
                        [showTransactionArray addObject:obj];
                    }
                }];
            } break;
            case DateRangeTypeCustom: {
                int64_t minTimestamp = startTimestamp * VTimestampMultiple;
                int64_t maxTimestamp = (endTimestamp + 24 * 60 * 60) * VTimestampMultiple;
                [weakSelf.showAllTransactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.originTransaction.timestamp >= minTimestamp && obj.originTransaction.timestamp <= maxTimestamp) {
                        [showTransactionArray addObject:obj];
                    }
                }];
            } break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.showTransactionArray = showTransactionArray.copy;
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showTransactionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.transaction = self.showTransactionArray[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransactionDetailViewController *detailVC = [[TransactionDetailViewController alloc] initWithTransaction:self.showTransactionArray[indexPath.row] account:self.account];
    detailVC.isDetailPage = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    if (currentOffsetY + scrollView.frame.size.height  > scrollView.contentSize.height &&  self.loading == NO && self.hasMore) {
        [self loadTransaction:self.page + 1];
    }
}

- (NSInteger)getListTypeFormat:(NSInteger)listType {
    if (listType == TransactionListTypeAll) {
        return 0;
    }else if (listType == TransactionListTypePayment) {
        return 2;
    }else if (listType == TransactionListTypeLease) {
        return 3;
    }else if (listType == TransactionListTypeCancelLease) {
        return 4;
    }else if (listType == TransactionListTypeRegisterContract){
        return 8;
    }else if (listType == TransactionListTypeExecuteContract) {
        return 9;
    }else {
        return 0;
    }
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
