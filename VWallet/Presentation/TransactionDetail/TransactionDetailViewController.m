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
#import "TokenMgr.h"
#import "VsysToken.h"

static NSString *const CellIdentifier = @"TransactionDetailTableViewCell";

@interface TransactionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) Account *account;
@property (nonatomic, weak) Transaction *transaction;
@property (nonatomic, weak) VsysToken *token;
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

- (instancetype)initWithTransaction:(Transaction *)transaction account:(Account *)account token:(VsysToken *)token {
    if (self = [super init]) {
        self.transaction = transaction;
        self.account = account;
        self.token = token;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellClickCopy) name:@"clickCopy" object:nil];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.transaction.detail");
    [self.cancelBtn setTitle:VLocalize(@"transaction.detail.cancel.out.leasing") forState:UIControlStateNormal];
    self.cancelBtn.layer.borderColor = VColor.themeColor.CGColor;
    [self.cancelBtn setTitleColor:VColor.themeColor forState:UIControlStateNormal];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    VsysTransaction *oriTx = self.transaction.originTransaction;
    
    NSString *amountStr = [[NSString stringWithDecimal:[NSString getAccurateDouble:self.transaction.originTransaction.amount unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES] stringByAppendingString:@" VSYS"];
    NSString *feeStr = [[NSString stringWithDecimal: [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%.8f", self.transaction.originTransaction.fee * 1.0 / VsysVSYS]] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES] stringByAppendingString:@" VSYS"];
    NSString *timeStr = [[[NSDate dateWithTimeIntervalSince1970:self.transaction.originTransaction.timestamp / VTimestampMultiple] stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"] stringByAppendingFormat:@" (%@)", VLocalize(@"transaction.detail.standard.time")];
    
    NSMutableArray *showData = [NSMutableArray new];
    if (![NSString isNilOrEmpty:self.transaction.originTransaction.txId]) {
        [showData addObject:@{@"title": VLocalize(@"transaction.detail.tx.id"), @"value": self.transaction.originTransaction.txId, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
    }
    if (oriTx.txType == VsysTxTypePayment) {
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.mine"), @"value" : self.transaction.ownerAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.sender"), @"value" : self.transaction.senderAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.receive"), @"value" : oriTx.recipient?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        }
        if (self.transaction.originTransaction.txType != VsysTxTypeCancelLease || self.isDetailPage) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : amountStr, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        }
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : [self.transaction TypeDesc], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    }else if (oriTx.txType == VsysTxTypeLease) {
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.mine"), @"value" : self.transaction.ownerAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.in.sender"), @"value" : self.transaction.senderAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.out.receive"), @"value" : oriTx.recipient?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        }
        if (self.transaction.originTransaction.txType != VsysTxTypeCancelLease || self.isDetailPage) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : amountStr, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        }
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : [self.transaction TypeDesc], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    }else if (oriTx.txType == VsysTxTypeCancelLease) {
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.mine"), @"value" : self.transaction.ownerAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.in.sender"), @"value" : self.transaction.senderAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.lease.out.receive"), @"value" : oriTx.recipient?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        }
        if (self.transaction.originTransaction.txType != VsysTxTypeCancelLease || self.isDetailPage) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : amountStr, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        }
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : [self.transaction TypeDesc], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    }else if (oriTx.txType == VsysTxTypeMining) {
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.mine"), @"value" : self.transaction.ownerAddress?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        if ([oriTx.recipient isEqualToString: self.transaction.ownerAddress]) {
            if (![NSString isNilOrEmpty:self.transaction.senderAddress]) {
                [showData addObject:@{@"title" : VLocalize(@"transaction.detail.sender"), @"value" : self.transaction.senderAddress ? : @"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            }
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.receive"), @"value" : oriTx.recipient?:@"", @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        }
        if (self.transaction.originTransaction.txType != VsysTxTypeCancelLease || self.isDetailPage) {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : amountStr, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        }
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : [self.transaction TypeDesc], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    }else if (oriTx.txType == VsysTxTypeContractExecute) {
        VsysToken *token = self.token;
        NSString *funcName = self.transaction.contractFuncName;
        if(!token) {
            token = [TokenMgr.shareInstance getTokenByAddress:self.account.originAccount.address tokenId:VsysContractId2TokenId(oriTx.contractId, oriTx.tokenIdx)];
            funcName = VsysGetFuncNameFromDescriptor(token.textualDescriptor, oriTx.funcIdx);
        }
       
        VsysContract *c = [VsysContract new];
        if (![NSString isNilOrEmpty:self.transaction.status]) {
            [showData addObject:@{@"title": VLocalize(@"transaction.detail.status"), @"value": self.transaction.status, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        }
        if ([funcName isEqualToString:@"send"]) {
            if([token isNFTToken]) {
                [c decodeNFTSend:oriTx.data];
            }else {
                [c decodeSend:oriTx.data];
            }
            [showData addObject:@{@"title" : VLocalize(@"token.info.id.token"), @"value" : VsysContractId2TokenId(oriTx.contractId, oriTx.tokenIdx), @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.from"), @"value" : self.transaction.senderAddress, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.to"), @"value" : c.recipient, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : VLocalize(@"token.send.token"), @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : [[NSString stringWithDecimal:[NSString getAccurateDouble:c.amount unity:token.unity] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES] stringByAppendingString: [NSString stringWithFormat:@" %@", [NSString isNilOrEmpty:token.name] ? @"" : token.name]], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        }else if ([funcName isEqualToString:@"issue"]) {
            [c decodeIssue:oriTx.data];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : VLocalize(@"token.issue.token"), @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"token.operate.note.issue"), @"value" : [NSString stringWithDecimal: [NSString getAccurateDouble:c.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"token.info.id.token"), @"value" : VsysContractId2TokenId(oriTx.contractId, oriTx.tokenIdx), @"hiddenCopy":[NSNumber numberWithBool:NO]}];

        }else if ([funcName isEqualToString:@"destroy"]) {
            [c decodeDestroy:oriTx.data];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : VLocalize(@"token.burn.token"), @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title":VLocalize(@"token.operate.note.burn"), @"value" : [NSString stringWithDecimal:[NSString getAccurateDouble:c.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"token.info.id.token"), @"value" : VsysContractId2TokenId(oriTx.contractId, oriTx.tokenIdx), @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        } else if ([funcName isEqualToString:@"deposit"]) {
            [c decodeDeposit:oriTx.data];
            [showData addObject:@{@"title" : VLocalize(@"token.info.id.token"), @"value" : VsysContractId2TokenId(oriTx.contractId, oriTx.tokenIdx), @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.from"), @"value" : c.senderAddr, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.to"), @"value" : c.contractId, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : VLocalize(@"deposit"), @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : [NSString stringWithDecimal:[NSString getAccurateDouble:c.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        } else if ([funcName isEqualToString:@"withdraw"]) {
            [c decodeWithdraw:oriTx.data];
            [showData addObject:@{@"title" : VLocalize(@"token.info.id.token"), @"value" : VsysContractId2TokenId(oriTx.contractId, oriTx.tokenIdx), @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.from"), @"value" : c.contractId, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.to"), @"value" : c.recipient, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : VLocalize(@"withdraw"), @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.amount"), @"value" : [NSString stringWithDecimal:[NSString getAccurateDouble:c.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        } else {
            [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : self.transaction.TypeDesc, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            [showData addObject:@{@"title" : VLocalize(@"token.info.id.token"), @"value" : VsysContractId2TokenId(oriTx.contractId,oriTx.tokenIdx), @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        }
    }else if (oriTx.txType == VsysTxTypeContractRegister) {
        VsysContract *c = [VsysContract new];
        [c decodeRegister:oriTx.data];
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.type"), @"value" : VLocalize(@"token.create.token"), @"hiddenCopy":[NSNumber numberWithBool:YES]}];
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.from"), @"value" : self.account.originAccount.address, @"hiddenCopy":[NSNumber numberWithBool:NO]}];
        [showData addObject:@{@"title": VLocalize(@"transaction.detail.desc"), @"value": oriTx.description, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    }
    
    [showData addObject: @{@"title" : VLocalize(@"transaction.detail.fee"), @"value" : feeStr, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    [showData addObject: @{@"title" : VLocalize(@"transaction.detail.time"), @"value" : timeStr, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
    
    if (self.transaction.originTransaction.attachment) {
        NSString *str;
        // will send transaction is not base58 encode
        if ([self.transaction.originTransaction.txId isEqualToString:@""]) {
            str = [[NSString alloc] initWithData:self.transaction.originTransaction.attachment encoding:NSUTF8StringEncoding];
        } else {
        // sented transaction is base58 encode
            str = [[NSString alloc] initWithData:VsysBase58Decode(self.transaction.originTransaction.attachment) encoding:NSUTF8StringEncoding];
        }
        [showData addObject:@{@"title" : VLocalize(@"transaction.detail.desc"), @"value" :str, @"hiddenCopy":[NSNumber numberWithBool:YES]}];
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
}

- (IBAction)cancelBtnClick {
    VsysTransaction *tx = VsysNewCancelLeaseTransaction(self.transaction.originTransaction.txId);
    tx.recipient = self.transaction.originTransaction.recipient;
    tx.amount = self.transaction.originTransaction.amount;
    tx.tokenIdx = VsysTokenId2TokenIdx(self.token.tokenId);
    Transaction *transaction = [[Transaction alloc] init];
    transaction.originTransaction = tx;
    transaction.senderAddress = self.transaction.senderAddress;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    if (![self.account.originAccount.privateKey isEqualToString:@""]) {
        transaction.signature = [self.account.originAccount signData:tx.buildTxData];
        [self beginTransactionConfirmWithTransaction:transaction account:self.account token:self.token];
    } else {
        [self coldWalletSendTransactionWithTransation:transaction account:self.account];
    }
}

-(void) cellClickCopy {
    [self remindWithMessage:VLocalize(@"tip.copy.success")];
}

@end
