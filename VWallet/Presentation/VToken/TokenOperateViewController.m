//
//  CreateTokenViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenOperateViewController.h"
#import "Account.h"
#import "VThemeTextField.h"
#import "VThemeTextView.h"
#import "VThemeButton.h"
#import "Account.h"
#import "UIColor+Hex.h"
#import "SuccessViewController.h"
#import "Language.h"
#import "VThemeLabel.h"
#import "UIViewController+Transaction.h"
#import "UIViewController+ColdWalletTransaction.h"
#import "UIViewController+Alert.h"

#import "NSString+Asterisk.h"
#import "NSString+Decimal.h"
#import "Transaction.h"
#import "ApiServer.h"

#import "Token.h"

@interface TokenOperateViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic) NSInteger operateType;
@property (nonatomic, strong) Token *token;
@property (weak, nonatomic) IBOutlet VThemeTextField *inputTotal;
@property (weak, nonatomic) IBOutlet VThemeTextView *inputDesc;
@property (weak, nonatomic) IBOutlet UILabel *unityNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheck;
@property (weak, nonatomic) IBOutlet UILabel *labelFee;
@property (weak, nonatomic) IBOutlet UILabel *labelAvailabelBalance;
@property (weak, nonatomic) IBOutlet VThemeButton *buttonContinue;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) UIView *progressTopView;
@property (strong, nonatomic) UILabel *progressTitle;
@property (nonatomic) BOOL checked;
@property (strong, nonatomic) Account *account;
@property (nonatomic, assign) int unitCurrent;
@property (nonatomic, assign) int unitTotal;
@property (weak, nonatomic) IBOutlet UIView *tokenViewWrap;
@property (weak, nonatomic) IBOutlet UIView *descWrapView;
@property (weak, nonatomic) IBOutlet VThemeLabel *descriptionNoteLabel;
@property (weak, nonatomic) IBOutlet UIView *tokenDescWrapView;
@property (weak, nonatomic) IBOutlet VThemeLabel *tokenDescNoteLabel;
@property (weak, nonatomic) IBOutlet VThemeTextView *inputTokenDesc;
@property (weak, nonatomic) IBOutlet VThemeLabel *tokenDescBottomNoteLabel;
@property (weak, nonatomic) IBOutlet UIView *unityWrapView;
@property (weak, nonatomic) IBOutlet UIView *checkBoxWrapView;
@property (weak, nonatomic) IBOutlet UILabel *checkBoxTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkBoxBottomLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feeWrapViewTop;
@property (weak, nonatomic) IBOutlet UIView *feeWrapView;
@property (weak, nonatomic) IBOutlet VThemeLabel *amountNoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *amountNoteButton;
@property (weak, nonatomic) IBOutlet UIImageView *amountNoteIcon;
@property (weak, nonatomic) IBOutlet UILabel *transactionFeeNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceNoteLabel;
@property (weak, nonatomic) IBOutlet VThemeLabel *descriptionBottomNoteLabel;
@end

@implementation TokenOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    if (self.operateType == TokenOperatePageTypeBurn || self.operateType == TokenOperatePageTypeIssue) {
        __weak typeof (self) weakSelf = self;
        [ApiServer getContractInfo:self.token.contractId callback:^(BOOL isSuc, Contract * _Nonnull contract) {
            if (isSuc) {
                BOOL issuer = NO;
                for (ContractInfoItem *one in contract.info) {
                    if ([one.name isEqualToString:@"issuer"]) {
                        if ([one.data isEqualToString:weakSelf.account.originAccount.address]) {
                            issuer = YES;
                            break;
                        }
                    }
                }
                if (!issuer) {
                    [weakSelf alertWithTitle:VLocalize(@"error.contract.operate.permission.not.issuer") confirmText:VLocalize(@"confirm") handler:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }
        }];
    }
}

- (instancetype)initWithAccount:(Account *)account {
    return [self initWithAccount:account type:TokenOperatePageTypeCreate];
}

- (instancetype)initWithAccount:(Account *)account type:(NSInteger)type {
    return [self initWithAccount:account type:type token:nil];
}

- (instancetype)initWithAccount:(Account *)account type:(NSInteger)type token:(Token *)token {
    if (self = [super init]) {
        self.account = account;
        self.operateType = type;
        self.token = token;
    }
    return self;
}

- (void)initView {
    self.inputTotal.delegate = self;
    self.labelAvailabelBalance.text = [NSString stringWithFormat:@"%@ VSYS", [NSString stringWithDecimal:[NSString getAccurateDouble:self.account.availableBalance unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES]];
    if (self.operateType == TokenOperatePageTypeCreate) {
        self.amountNoteLabel.text = VLocalize(@"token.operate.note.total");
        [self.navigationItem setTitle:VLocalize(@"token.create.token")];
        [self setProgress:8 total:16];
        self.labelFee.text = [NSString stringWithFormat:@"%@ VSYS", [NSString stringWithDecimal:[[NSDecimalNumber alloc] initWithDouble:VsysDefaultContractRegisterFee * 1.0 / VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES]];
    }else if (self.operateType == TokenOperatePageTypeIssue) {
        self.labelFee.text = [NSString stringWithFormat:@"%@ VSYS", [NSString stringWithDecimal:[[NSDecimalNumber alloc] initWithDouble:VsysDefaultContractExecuteFee * 1.0 / VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES]];
        self.amountNoteLabel.text = VLocalize(@"token.operate.note.issue");
        [self.navigationItem setTitle:VLocalize(@"token.issue.token")];
        self.descWrapView.hidden = YES;
        self.tokenDescWrapView.hidden = YES;
        self.unityWrapView.hidden = YES;
        self.checkBoxWrapView.hidden = YES;
        self.feeWrapViewTop.constant = -(self.feeWrapView.frame.origin.y - self.descWrapView.frame.origin.y);
        [self.view layoutIfNeeded];
    }else if (self.operateType == TokenOperatePageTypeBurn) {
        self.labelFee.text = [NSString stringWithFormat:@"%@ VSYS", [NSString stringWithDecimal:[[NSDecimalNumber alloc] initWithDouble:VsysDefaultContractExecuteFee * 1.0 / VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES]];
        self.amountNoteLabel.text = VLocalize(@"token.operate.note.burn");
        [self.navigationItem setTitle:VLocalize(@"token.burn.token")];
        self.descWrapView.hidden = YES;
        self.unityWrapView.hidden = YES;
        self.checkBoxWrapView.hidden = YES;
        self.tokenDescWrapView.hidden = YES;
        self.feeWrapViewTop.constant = -(self.feeWrapView.frame.origin.y - self.descWrapView.frame.origin.y);
    }
    [self.buttonContinue setTitle:VLocalize(@"continue") forState:UIControlStateNormal];
    self.transactionFeeNoteLabel.text = [NSString stringWithFormat:@"%@：", VLocalize(@"account.transaction.fee")];
    self.availableBalanceNoteLabel.text = [NSString stringWithFormat:@"%@：", VLocalize(@"account.detail.available.balance")];
    self.descriptionNoteLabel.text = VLocalize(@"token.info.contract.desc");
    self.tokenDescNoteLabel.text = VLocalize(@"token.info.token.desc");
    self.descriptionBottomNoteLabel.text = VLocalize(@"token.info.contract.description.note");
    self.tokenDescBottomNoteLabel.text = VLocalize(@"token.info.description.note");
    self.unityNoteLabel.text = VLocalize(@"token.info.unity");
    self.checkBoxTopLabel.text = VLocalize(@"token.info.support.split.note");
    self.checkBoxBottomLabel.text = VLocalize(@"token.info.support.note");
    if (![self checkAmount]) {}
}

- (void)setProgress:(CGFloat)current total:(CGFloat)total {
    if (current > total) {
       current = total;
    }
    if (current < 0) {
        current = 0;
    }
    self.unitTotal = total;
    self.unitCurrent = current;
    CGFloat width = (self.unitCurrent * self.progressView.frame.size.width) / self.unitTotal;
    if (self.progressTopView == nil) {
        self.progressTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.progressTopView.backgroundColor = [UIColor colorWithHexStr:@"FFC969"];
        [self.progressView addSubview:self.progressTopView];
        self.progressTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.progressTitle.textColor = [UIColor whiteColor];
        self.progressTitle.textAlignment = NSTextAlignmentCenter;
        self.progressTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
        [self.progressView addSubview:self.progressTitle];
    }
    CGRect frame = CGRectMake(0, 0, width, self.progressView.frame.size.height);
    frame.size.width = width;
    [UIView animateWithDuration:0.2 animations:^{
        self.progressTitle.text = [NSString stringWithFormat:@"%.0f", current];
        self.progressTopView.frame = frame;
        self.progressTitle.frame = frame;
    }];
}

- (IBAction)ClickTotalTokenNote:(id)sender {
    
}

- (IBAction)ClickMinus:(id)sender {
    [self setProgress:(self.unitCurrent-1) total:self.unitTotal];
    self.unitLabel.text = [NSString stringWithFormat:@"10^%d", self.unitCurrent];
}

- (IBAction)ClickPlus:(id)sender {
    [self setProgress:(self.unitCurrent+1) total:self.unitTotal];
    self.unitLabel.text = [NSString stringWithFormat:@"10^%d", self.unitCurrent];
}

- (IBAction)ClickCheck:(id)sender {
    if(self.checked) {
        self.checked = NO;
    }else {
        self.checked = YES;
    }
    [self.buttonCheck setHighlighted: self.checked];
}

- (IBAction)ClickContinue:(id)sender {
    if (![self checkAmount]) {
        return;
    }
    if (self.inputTotal.text.doubleValue <= 0) {
        [self alertWithTitle:VLocalize(@"tip.transaction.amount.invalid") confirmText:nil];
        return;
    }
    if (VsysGetAttachmentLength(self.inputTokenDesc.text) > 140) {
        [self alertWithTitle:VLocalize(@"tip.transaction.token.desc.too.long") confirmText:nil];
        return;
    }
    if (VsysGetAttachmentLength(self.inputDesc.text) > 140) {
        [self alertWithTitle:VLocalize(@"tip.transaction.contract.desc.too.long") confirmText:nil];
        return;
    }
    switch (self.operateType) {
        case TokenOperatePageTypeCreate: {
            [self startRegisterToken];
        } break;
        case TokenOperatePageTypeIssue: {
            [self startIssueToken];
        } break;
        case TokenOperatePageTypeBurn: {
            [self startBurnToken];
        } break;
    }
}

- (BOOL)checkAmount {
    if (self.operateType == TokenOperatePageTypeCreate) {
        if (self.account.availableBalance < VsysDefaultContractRegisterFee) {
            [self alertWithTitle:VLocalize(@"tip.transaction.insufficient.balance") confirmText:nil];
            return NO;
        }
    }else if (self.operateType == TokenOperatePageTypeIssue){
        if (self.account.availableBalance < VsysDefaultContractExecuteFee) {
            [self alertWithTitle:VLocalize(@"tip.transaction.insufficient.balance") confirmText:nil];
            return NO;
        }else if (self.token.total + [self.inputTotal.text doubleValue] * self.token.unity > self.token.max) {
            [self alertWithTitle:VLocalize(@"error.contract.issue.over.max") confirmText:nil];
            return NO;
        }
    }else if (self.operateType == TokenOperatePageTypeBurn) {
        if (self.account.availableBalance < VsysDefaultContractExecuteFee) {
            [self alertWithTitle:VLocalize(@"tip.transaction.insufficient.balance") confirmText:nil];
            return NO;
        }else if (self.token.balance < [self.inputTotal.text doubleValue] * self.token.unity) {
            [self alertWithTitle:VLocalize(@"error.contract.burn.over.available") confirmText:VLocalize(@"close")];
            return NO;
        }
    }
    return YES;
}

- (void)startRegisterToken {
    double max = [self.inputTotal.text doubleValue];
    NSString *contractDesc = self.inputDesc.text;
    NSString *tokenDesc = self.inputTokenDesc.text;
    int64_t unity = self.unitCurrent;
    BOOL supportSplit = self.buttonCheck.highlighted;
    VsysContract *c = [VsysContract new];
    int64_t u = 1;
    for(int i = 0; i < unity; i++) {
        u = u * 10;
    }
    c.unity = u;
    c.max = max * c.unity;
    c.tokenDescription = tokenDesc;
    if (c.max > (pow(2, 63) - 1) || c.max / c.unity != max) {
        [self alertWithTitle:VLocalize(@"error.contract.create.out.of.range") confirmText:VLocalize(@"close")];
        return;
    }
    VsysTransaction *tx;
    if (supportSplit) {
        tx = VsysNewRegisterTransaction(VsysConstContractSplit, VsysBase58EncodeToString([c buildRegisterData]), contractDesc);
    }else {
        tx = VsysNewRegisterTransaction(VsysConstContractDefault, VsysBase58EncodeToString([c buildRegisterData]), contractDesc);
    }
    if (!tx) {
        return;
    }
    Transaction *transaction = [[Transaction alloc] init];
    transaction.transactionType = 8;
    transaction.originTransaction = tx;
    transaction.senderAddress = self.account.originAccount.address;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    switch (self.account.accountType) {
        case AccountTypeWallet: {
            transaction.signature = [self.account.originAccount signDataBase58:VsysBase58EncodeToString(tx.buildTxData)];
            [self beginTransactionConfirmWithTransaction:transaction account:self.account];
        } break;
        case AccountTypeMonitor: {
            [self coldWalletSendTransactionWithTransation:transaction account:self.account];
        } break;
    }
}

- (void)startIssueToken {
    double amount = [self.inputTotal.text doubleValue];
    VsysContract *c = [VsysContract new];
    c.amount = amount * self.token.unity;
    VsysTransaction *tx = VsysNewExecuteTransaction(self.token.contractId, VsysBase58EncodeToString([c buildIssueData]), VsysGetFuncIndexFromDescriptor(self.token.textualDescriptor, @"issue"), @"");
    tx.amount = amount * self.token.unity;
    if (!tx) {
        return;
    }
    Transaction *transaction = [[Transaction alloc] init];
    transaction.originTransaction = tx;
    transaction.senderAddress = self.account.originAccount.address;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    transaction.contractFuncName = VsysActionIssue;
    switch (self.account.accountType) {
        case AccountTypeWallet: {
            transaction.signature = [self.account.originAccount signData:tx.buildTxData];
            [self beginTransactionConfirmWithTransaction:transaction account:self.account];
        }break;
        case AccountTypeMonitor: {
            [self coldWalletSendTransactionWithTransation:transaction account:self.account];
        }break;
    }
}

- (void)startBurnToken {
    double amount = [self.inputTotal.text doubleValue];
    VsysContract *c = [VsysContract new];
    c.amount = amount * self.token.unity;
    VsysTransaction *tx = VsysNewExecuteTransaction(self.token.contractId, VsysBase58EncodeToString([c buildDestroyData]), VsysGetFuncIndexFromDescriptor(self.token.textualDescriptor, @"destroy"), @"");
    tx.amount = amount * self.token.unity;
    if (!tx) {
        return;
    }
    Transaction *transaction = [[Transaction alloc] init];
    transaction.originTransaction = tx;
    transaction.senderAddress = self.account.originAccount.address;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    transaction.contractFuncName = VsysActionDestroy;
    switch (self.account.accountType) {
        case AccountTypeWallet: {
            transaction.signature = [self.account.originAccount signData:tx.buildTxData];
            [self beginTransactionConfirmWithTransaction:transaction account:self.account];
        }break;
        case AccountTypeMonitor: {
            [self coldWalletSendTransactionWithTransation:transaction account:self.account];
        }break;
    }
}

- (void)checkAccess {
    if (self.operateType == TokenOperatePageTypeCreate) {
        int64_t max = [self.inputTotal.text doubleValue];
        NSString *desc = self.inputDesc.text;
        if (
            self.account.availableBalance >= 100 * VsysVSYS && max > 0 &&
            max > 0 &&
            desc != nil
            ) {
            [UIView animateWithDuration:0.2 animations:^{
                self.buttonCheck.enabled = YES;
                self.buttonCheck.alpha = 1;
            }];
        }else {
            [UIView animateWithDuration:0.2 animations:^{
                self.buttonCheck.enabled = NO;
                self.buttonCheck.alpha = 0.5;
            }];
        }
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray <NSString *>*arr = [str componentsSeparatedByString:@"."];
    if (arr.count == 2 && arr[1].length > [self getDecimal:self.token.unity]) {
        return NO;
    }
    return YES;
}

- (int)getDecimal:(int64_t)input {
    for (int i = 0; i <= 16; i++){
        if (pow(10, i) == input) {
            return i;
        }
    }
    return 0;
}

@end
