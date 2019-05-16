//
// TransactionDetailViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "TransactionDetailTableViewCell.h"
#import "Language.h"
#import "Transaction.h"
#import "NSString+Decimal.h"
#import "NSDate+FormatString.h"
#import "UIViewController+Transaction.h"
#import "UIViewController+ColdWalletTransaction.h"
#import "Account.h"
#import "VColor.h"
#import "Transaction+Extension.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+Alert.h"

static NSString *const CellIdentifier = @"TransactionDetailTableViewCell";

@interface TransactionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) Account *account;
@property (nonatomic, weak) Transaction *transaction;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnBottomLC;

@property (nonatomic, strong) NSArray *showData;
@end

@implementation TransactionDetailViewController

- (instancetype)initWithTransaction:(Transaction *)transaction account:(Account *)account {
    if (self = [super init]) {
        self.transaction = transaction;
        self.account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.transaction.detail");
    [self.cancelBtn setTitle:VLocalize(@"transaction.detail.cancel.out.leasing") forState:UIControlStateNormal];
    self.cancelBtn.layer.borderColor = VColor.themeColor.CGColor;
    [self.cancelBtn setTitleColor:VColor.themeColor forState:UIControlStateNormal];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    VsysTransaction *oriTx = self.transaction.originTransaction;
    
    NSString *amountStr = [[NSString stringWithDecimal:(self.transaction.originTransaction.amount * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES] stringByAppendingString:@" VSYS"];
    NSString *feeStr = [[NSString stringWithDecimal:(self.transaction.originTransaction.fee * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES] stringByAppendingString:@" VSYS"];
    NSString *timeStr = [[[NSDate dateWithTimeIntervalSince1970:self.transaction.originTransaction.timestamp / VTimestampMultiple] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"] stringByAppendingFormat:@" (%@)", VLocalize(@"transaction.detail.chinese.standard.time")];
    
    NSMutableArray *showData = @[
                                 @{@"title" : VLocalize(@"transaction.detail.mine"), @"value" : self.transaction.ownerAddress?:@""},
                                 ].mutableCopy;
    
    if (oriTx.txType == VsysTxTypePayment) {
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.sender"), @"value" : self.transaction.senderAddress?:@""}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.receive"), @"value" : oriTx.recipient?:@""}];
        }
    } else if (oriTx.txType == VsysTxTypeLease) {
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.in.sender"), @"value" : self.transaction.senderAddress?:@""}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.out.receive"), @"value" : oriTx.recipient?:@""}];
        }
    } else if (oriTx.txType == VsysTxTypeCancelLease) {
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.in.sender"), @"value" : self.transaction.senderAddress?:@""}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.out.receive"), @"value" : oriTx.recipient?:@""}];
        }
    } else if (oriTx.txType == VsysTxTypeMining) {
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.sender"), @"value" : self.transaction.senderAddress?:@""}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.receive"), @"value" : oriTx.recipient?:@""}];
        }
    } 
    
    if (self.transaction.originTransaction.txId && ![self.transaction.originTransaction.txId isEqualToString:@""] && self.isDetailPage) {
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.tx.id"), @"value" : self.transaction.originTransaction.txId?:@""}];
    }
    
    [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : [self.transaction TypeDesc]}];
    
    
    if (self.transaction.originTransaction.txType != VsysTxTypeCancelLease || self.isDetailPage) {
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : amountStr}];
    }
    
    [showData addObject: @{@"title" : VLocalize(@"transaction.detail.fee"), @"value" : feeStr}];
    [showData addObject: @{@"title" : VLocalize(@"transaction.detail.time"), @"value" : timeStr}];
    
    if (self.transaction.originTransaction.attachment) {
        NSString *str;
        // will send transaction is not base58 encode
        if ([self.transaction.originTransaction.txId isEqualToString:@""]) {
            str = [[NSString alloc] initWithData:self.transaction.originTransaction.attachment encoding:NSUTF8StringEncoding];
        } else {
        // sented transaction is base58 encode
            str = [[NSString alloc] initWithData:VsysBase58Decode(self.transaction.originTransaction.attachment) encoding:NSUTF8StringEncoding];
        }
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.desc"), @"value" :str}];
    }

    self.showData = showData.copy;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cancelBtnBottomLC.constant = self.transaction.canCancel ? 24 : -CGRectGetHeight(self.cancelBtn.bounds)-8;
    self.cancelBtn.hidden = !self.transaction.canCancel;
    [self changeToThemeNavigationBar];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.showInfo = self.showData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        UIPasteboard.generalPasteboard.string = self.showData[indexPath.row][@"value"];
        [self remindWithMessage:VLocalize(@"tip.copy.success")];
    }
}

- (IBAction)cancelBtnClick {
    VsysTransaction *tx = VsysNewCancelLeaseTransaction(self.transaction.originTransaction.txId);
    tx.recipient = self.transaction.originTransaction.recipient;
    tx.amount = self.transaction.originTransaction.amount;
    Transaction *transaction = [[Transaction alloc] init];
    transaction.originTransaction = tx;
    transaction.senderAddress = self.transaction.senderAddress;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    if (![self.account.originAccount.privateKey isEqualToString:@""]) {
        transaction.signature = [self.account.originAccount signData:tx.buildTxData];
        [self beginTransactionConfirmWithTransaction:transaction account:self.account];
    } else {
        [self coldWalletSendTransactionWithTransation:transaction account:self.account];
    }
}

@end
