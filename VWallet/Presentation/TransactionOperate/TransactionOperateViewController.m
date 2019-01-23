//
// TransactionOperateViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionOperateViewController.h"
#import "Account.h"
#import "Language.h"
#import "VColor.h"
#import "QRScannerViewController.h"
#import "UIViewController+Alert.h"
#import "Regex.h"
#import "NSString+Decimal.h"
#import "UIViewController+ColdWalletTransaction.h"
#import "UIViewController+Transaction.h"
#import "Transaction.h"
#import "UITextView+Placeholder.h"
#import "VColor.h"

@import SafariServices;

@interface TransactionOperateViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) Account *account;
@property (nonatomic, assign) TransactionOperateType operateType;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *insufficientBalanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insufficientBalanceLabelHeightLC;
@property (weak, nonatomic) IBOutlet UIButton *maxBtn;

@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UITextView *receiveAddressTextView;
@property (weak, nonatomic) IBOutlet UILabel *errorAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorAddressLabelHeightLC;
@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanQRBtn;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UIButton *nodeListBtn;

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descViewTopLC;
@property (weak, nonatomic) IBOutlet UILabel *descLabel2;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@property (weak, nonatomic) IBOutlet UILabel *transactionFeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;


@property (nonatomic, assign) CGFloat keyboardMinY;
@property (nonatomic, assign) UIViewKeyframeAnimationOptions keyboardOptions;

@end

@implementation TransactionOperateViewController

- (instancetype)initWithAccount:(Account *)account operateType:(TransactionOperateType)operateType {
    if (self = [super init]) {
        self.account = account;
        self.operateType = operateType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.maxBtn setTitle:VLocalize(@"account.transaction.max") forState:UIControlStateNormal];
    self.amountTextField.placeholder = VLocalize(@"account.transaction.amount.placeholder");
    NSString *availableBalanceStr = [NSString stringWithDecimal:self.account.availableBalance * 1.0 / VsysVSYS maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    NSMutableAttributedString *availableBalanceMas = [[NSMutableAttributedString alloc] initWithString:[VLocalize(@"account.transaction.available.balance") stringByAppendingString:@" "]];
    [availableBalanceMas appendAttributedString:[[NSAttributedString alloc] initWithString:availableBalanceStr attributes:@{NSForegroundColorAttributeName : VColor.textSecondDeepenColor}]];
    self.availableBalanceLabel.attributedText = availableBalanceMas;
    self.insufficientBalanceLabel.text = VLocalize(@"tip.transaction.insufficient.balance");
    
    self.descLabel1.text = VLocalize(@"account.transaction.to");
    self.receiveAddressTextView.placeholder = VLocalize(@"account.transaction.to.placeholder");
    self.errorAddressLabel.text = VLocalize(@"tip.transaction.error.address");
    self.errorAddressLabelHeightLC.constant = 0;
    [self.pasteBtn setTitle:VLocalize(@"account.transaction.paste") forState:UIControlStateNormal];
    [self.scanQRBtn setTitle:VLocalize(@"account.transaction.scan.qr") forState:UIControlStateNormal];
    
    switch (self.operateType) {
        case TransactionOperateTypeSend: {
            self.navigationItem.title = VLocalize(@"nav.title.transaction.send");
            self.descLabel.text = VLocalize(@"account.transaction.send.amount");
            self.descLabel1.text = VLocalize(@"account.transaction.send.to");
            self.descViewTopLC.constant = 20;
            self.descView.hidden = NO;
            self.descLabel2.text = VLocalize(@"account.transaction.desc");
            self.descTextView.placeholder = VLocalize(@"account.transaction.desc.placeholder");
            self.questionBtn.hidden = YES;
            self.nodeListBtn.hidden = YES;
        }
        break;
        case TransactionOperateTypeLease: {
            self.navigationItem.title = VLocalize(@"nav.title.transaction.lease");
            self.descLabel.text = VLocalize(@"account.transaction.lease.amount");
            self.descLabel1.text = VLocalize(@"account.transaction.lease.to");
            self.receiveAddressTextView.placeholder = VLocalize(@"account.transaction.to.node.address");
            self.descViewTopLC.constant = -CGRectGetHeight(self.descView.bounds);
            self.descView.hidden = YES;
            [self.questionBtn setTitle:VLocalize(@"account.transaction.question") forState:UIControlStateNormal];
            [self.nodeListBtn setTitle:VLocalize(@"account.transaction.nodelist") forState:UIControlStateNormal];
        }
        break;
    }
    
    NSString *feeStr = [NSString stringWithDecimal:(VsysDefaultTxFee * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
    NSMutableAttributedString *feeMas = [[NSMutableAttributedString alloc] initWithString:[VLocalize(@"account.transaction.fee") stringByAppendingString:@" "]];
    [feeMas appendAttributedString:[[NSAttributedString alloc] initWithString:[feeStr stringByAppendingString:@" VSYS"] attributes:@{NSForegroundColorAttributeName : VColor.textSecondDeepenColor}]];
    self.transactionFeeLabel.attributedText = feeMas;
    [self.continueBtn setTitle:VLocalize(@"continue") forState:UIControlStateNormal];
    
    if (![self checkAmount]) {
//        self.amountTextField.enabled = NO;
//        self.receiveAddressTextView.editable = NO;
//        self.descTextView.editable = NO;
//        self.maxBtn.enabled = NO;
//        self.pasteBtn.enabled = NO;
//        self.scanQRBtn.enabled = NO;
//        self.continueBtn.enabled = NO;
    }
}

- (BOOL)checkAmount {
    int64_t balance = self.account.availableBalance - VsysDefaultTxFee - self.amountTextField.text.doubleValue * VsysVSYS;
    BOOL insufficientBalance = balance < 0;
    if (insufficientBalance && self.insufficientBalanceLabelHeightLC.constant == 0) {
        self.insufficientBalanceLabelHeightLC.constant = 15;
    } else if (!insufficientBalance && self.insufficientBalanceLabelHeightLC.constant > 0) {
        self.insufficientBalanceLabelHeightLC.constant = 0;
    }
    return !insufficientBalance;
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    if (sender == self.amountTextField) {
        [self checkAmount];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray <NSString *>*arr = [str componentsSeparatedByString:@"."];
    if (arr.count == 2 && arr[1].length > 8) {
        return NO;
    }
    return YES;
}


#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView updatePlaceholderState];
    if (textView == self.receiveAddressTextView) {
        [self checkAddress];
    } else if (textView == self.descTextView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToFocusWithDuration:.1];
        });
    }
}

- (BOOL)checkAddress {
    BOOL addressValid = VsysValidateAddress(self.receiveAddressTextView.text);
//    BOOL addressValid = [Regex matchRegexStr:@"^[\\dA-Za-z]+$" string:self.receiveAddressTextView.text];
    if (!addressValid && self.errorAddressLabelHeightLC.constant == 0) {
        self.errorAddressLabelHeightLC.constant = 15;
    } else if (addressValid && self.errorAddressLabelHeightLC.constant > 0) {
        self.errorAddressLabelHeightLC.constant = 0;
    }
    return addressValid;
}

- (IBAction)maxBtnClick {
    int64_t max = self.account.availableBalance - VsysDefaultTxFee;
    if (max < 0) max = 0;
    self.amountTextField.text = [NSString stringWithDecimal:(max * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
}

- (IBAction)pasteBtnClick {
    self.receiveAddressTextView.text = UIPasteboard.generalPasteboard.string;
    [self.receiveAddressTextView updatePlaceholderState];
    [self checkAddress];
}

- (IBAction)questionBtnClick:(id)sender {
    [self openWebUrl:@"https://vsysrate.com/wiki/vsys-coin-leasing.html"];

}

- (IBAction)nodeListBtnClick:(id)sender {
    [self openWebUrl:@"https://vsysrate.com"];
}

- (void)openWebUrl:(NSString *)urlStr {
    SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
    vc.preferredBarTintColor = VColor.themeColor;
    vc.preferredControlTintColor = UIColor.whiteColor;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)scanQRBtnClick {
    __weak typeof(self) weakSelf = self;
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:nil result:^(NSString * _Nullable qrCode) {
            [weakSelf scanQRcodeResult:qrCode];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (void)scanQRcodeResult:(NSString *)qrCode {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[qrCode dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if ([dict[@"api"] integerValue] > VsysApi) {
        [self alertWithTitle:VLocalize(@"tip.qrcode.unsupported.version") confirmText:nil];
        return;
    }
    if (error || ![dict[@"opc"] isEqualToString:VsysOpcTypeAccount]) {
        [self alertWithTitle:VLocalize(@"tip.qrcode.unsupported.types") confirmText:nil];
        return;
    }
    NSString *address = dict[@"address"] ? : @"";
    NSInteger amount = dict[@"amount"] ? [dict[@"amount"] integerValue] : 0;
    self.receiveAddressTextView.text = address;
    [self.receiveAddressTextView updatePlaceholderState];
    [self checkAddress];
    NSDecimalNumber *num1 = [[NSDecimalNumber alloc] initWithInteger:amount];
    NSDecimalNumber *num2 = [[NSDecimalNumber alloc] initWithLong:VsysVSYS];
    self.amountTextField.text = [[num1 decimalNumberByDividingBy:num2] stringValue];
}

- (IBAction)continueBtnClick {
    if (![self checkAmount]) {
        [self alertWithTitle:VLocalize(@"tip.transaction.insufficient.balance") confirmText:nil];
        return;
    }
    if (self.amountTextField.text.doubleValue <= 0) {
        [self alertWithTitle:VLocalize(@"tip.transaction.amount.invalid") confirmText:nil];
        return;
    }
    if (![self checkAddress]) {
        [self alertWithTitle:VLocalize(@"tip.transaction.error.address") confirmText:nil];
        return;
    }
    if ([self.receiveAddressTextView.text isEqualToString:self.account.originAccount.address]) {
        [self alertWithTitle:VLocalize(@"tip.transaction.address.is.self") confirmText:nil];
        return;
    }
    VsysTransaction *tx;
    switch (self.operateType) {
        case TransactionOperateTypeSend:
            tx = VsysNewPaymentTransaction(self.receiveAddressTextView.text, self.amountTextField.text.doubleValue * VsysVSYS);
            tx.attachment = [self.descTextView.text dataUsingEncoding:NSUTF8StringEncoding];
            break;
        case TransactionOperateTypeLease:
            tx = VsysNewLeaseTransaction(self.receiveAddressTextView.text, self.amountTextField.text.doubleValue * VsysVSYS);
            break;
    }
    if (!tx) {
        return;
    }
    
    Transaction *transaction = [[Transaction alloc] init];
    transaction.originTransaction = tx;
    transaction.senderAddress = self.account.originAccount.address;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    switch (self.account.accountType) {
        case AccountTypeWallet: {
            transaction.signature = [self.account.originAccount signData:tx.buildTxData];
            [self beginTransactionConfirmWithTransaction:transaction account:self.account];
        } break;
        case AccountTypeMonitor: {
            [self coldWalletSendTransactionWithTransation:transaction account:self.account];
        } break;
    }
}

#pragma mark - keyboard
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (UIView *)focusView {
    if (self.amountTextField.isFirstResponder) {
        return self.amountTextField;
    } else if (self.receiveAddressTextView.isFirstResponder) {
        return self.receiveAddressTextView;
    } else if (self.descTextView.isFirstResponder) {
        return self.descTextView;
    }
    return nil;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardMinY = CGRectGetMinY([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardOptions = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    [self scrollToFocusWithDuration:duration];
}

- (void)scrollToFocusWithDuration:(NSTimeInterval)duration {
    if (!self.focusView) return;
    CGFloat focusViewMaxY = CGRectGetMaxY([self.focusView convertRect:self.focusView.bounds toView:UIApplication.sharedApplication.keyWindow]);
    if (focusViewMaxY > self.keyboardMinY) {
        __weak typeof(self) weakSelf = self;
        CGFloat scrollViewOffsetY = self.scrollView.contentOffset.y;
        [UIView animateKeyframesWithDuration:duration delay:0 options:self.keyboardOptions animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(0, scrollViewOffsetY + focusViewMaxY - weakSelf.keyboardMinY);
        } completion:nil];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewKeyframeAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:duration delay:0 options:option animations:^{
        weakSelf.scrollView.contentOffset = CGPointZero;
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
