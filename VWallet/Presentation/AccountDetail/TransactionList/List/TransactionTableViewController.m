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

static NSString *const CellIdentifier = @"TransactionTableViewCell";

@interface TransactionTableViewController ()

@property (nonatomic, assign) TransactionListType listType;
@property (nonatomic, weak) Account *account;

@property (nonatomic, weak) NSArray<Transaction *> *transactionArray;

@property (nonatomic, strong) NSArray<Transaction *> *showAllTransactionArray;

@property (nonatomic, strong) NSArray<Transaction *> *showTransactionArray;

@end

@implementation TransactionTableViewController

- (instancetype)initWithListType:(TransactionListType)listType transactionArray:(NSArray<Transaction *> *)transactionArray account:(nonnull Account *)account {
    if (self = [super init]) {
        self.listType = listType;
        self.transactionArray = transactionArray;
        self.account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 57;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView ed_setupEmptyDataDisplay];
    self.tableView.ed_empty_offset = -100;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self changeToThemeNavigationBar];
}

- (void)setDateRangeType:(DateRangeType)dateRangeType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT), ^{
        NSMutableArray<Transaction *> *showTransactionArray = [NSMutableArray array];
        if (weakSelf.showAllTransactionArray.count) {
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
        } else {
            switch (weakSelf.listType) {
                case TransactionListTypeAll:
                    showTransactionArray = weakSelf.transactionArray.mutableCopy;
                    break;
                case TransactionListTypeSent: {
                    [weakSelf.transactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.transactionType == 1) {
                            [showTransactionArray addObject:obj];
                        }
                    }];
                } break;
                case TransactionListTypeReceive: {
                    [weakSelf.transactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.transactionType == 2) {
                            [showTransactionArray addObject:obj];
                        }
                    }];
                } break;
                case TransactionListTypeLease: {
                    [weakSelf.transactionArray enumerateObjectsUsingBlock:^(Transaction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.originTransaction.txType == 3 || obj.originTransaction.txType == 4) {
                            [showTransactionArray addObject:obj];
                        }
                    }];
                } break;
            }
            self.showAllTransactionArray = showTransactionArray.copy;
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

@end
