//
//  DepositWithdrawViewController.m
//  VWallet
//
//  Copyright © 2021 veetech. All rights reserved.
//

#import "DepositWithdrawViewController.h"
#import "TransactionOperateViewController.h"
#import "Account.h"
#import "UITextView+Placeholder.h"
#import <Masonry.h>
#import "VSeparatorLine.h"
#import "Language.h"
#import "VColor.h"
#import "VThemeTextView.h"
#import "VThemeTextField.h"
#import "UIView+Efficiency.h"
#import "VThemeButton.h"
#import "MediaManager.h"
#import "QRScannerViewController.h"
#import "LoadingView.h"
#import "UIView+Loading.h"
#import "ApiServer.h"
#import "UIViewController+Alert.h"
#import "VsysToken.h"
#import "NSString+Decimal.h"
#import "UIViewController+Transaction.h"
#import "VThemeLabel.h"
#import "Regex.h"

@interface DepositWithdrawViewController () <UITextViewDelegate>

@property (nonatomic, strong) Account *account;
@property (nonatomic, assign) TransactionOperateType operateType;
@property (nonatomic, strong) VsysToken * token;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *contractLbl;
@property (nonatomic, strong) UILabel *amountLbl;
@property (nonatomic, strong) VThemeLabel *balanceLbl;
@property (nonatomic, strong) VSeparatorLine *contractSepLine;
@property (nonatomic, strong) VSeparatorLine *amountSepLine;
@property (nonatomic, strong) UITextView *contractTv;
@property (nonatomic, strong) VThemeTextField *amountTv;
@property (nonatomic, strong) VThemeButton *scanQRBtn;
@property (nonatomic, strong) VThemeButton *pasteBtn;
@property (nonatomic, strong) VThemeButton *maxBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *continueBtn;


@end

@implementation DepositWithdrawViewController

- (instancetype)initWithAccount:(Account *)account operateType:(TransactionOperateType)operateType {
    if (self = [super init]) {
        self.account = account;
        self.operateType = operateType;
        self.token = [VsysToken new];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = VLocalize(@"nav.title.contract.token.deposit");
    if(self.operateType == TransactionOperateTypeWithdraw) {
        self.navigationItem.title = VLocalize(@"nav.title.contract.token.withdraw");
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.scrollView.contentInset = UIEdgeInsetsMake(20, 20, 40, 20);
    [self.view addSubview:self.scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 40, self.view.height)];
    [self.scrollView addSubview:contentView];
    
    self.scanQRBtn = [[VThemeButton alloc] initWithFrame:CGRectMake(contentView.width-86, self.contractLbl.top , 86, 22)];
    [self.scanQRBtn setImage:[UIImage imageNamed:@"ico_scan_small"] forState:UIControlStateNormal];
    self.scanQRBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.scanQRBtn setTitle:VLocalize(@"account.transaction.scan.qr") forState:UIControlStateNormal];
    [self.scanQRBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 1, 14)];
    [self.scanQRBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -12)];
    self.scanQRBtn.hollow = YES;
    self.scanQRBtn.secondTheme = YES;
    self.scanQRBtn.layer.cornerRadius = 11;
    [self.scanQRBtn addTarget:self action:@selector(scanQRBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.scanQRBtn];
    
    self.pasteBtn = [[VThemeButton alloc] initWithFrame:CGRectMake(self.scanQRBtn.left - 71 - 12, self.scanQRBtn.top, 71, 22)];
    self.pasteBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.pasteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pasteBtn setImage:[UIImage imageNamed:@"ico_paste_small"] forState:UIControlStateNormal];
    [self.pasteBtn setTitle:VLocalize(@"account.transaction.paste") forState:UIControlStateNormal];
    [self.pasteBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 14)];
    [self.pasteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -12)];
    self.pasteBtn.hollow = YES;
    self.pasteBtn.secondTheme = YES;
    self.pasteBtn.layer.cornerRadius = 11;
    [self.pasteBtn addTarget:self action:@selector(pasteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.pasteBtn];
    
    self.contractLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pasteBtn.left - 10, 22)];
    self.contractLbl.font = [UIFont systemFontOfSize:16.0];
    self.contractLbl.text = VLocalize(@"contract.id.text");
    [contentView addSubview:self.contractLbl];
    
    self.contractTv = [[UITextView alloc] initWithFrame:CGRectMake(-5, self.contractLbl.bottom + 4, contentView.width, 38)];
    self.contractTv.font = [UIFont systemFontOfSize:18.0];
    self.contractTv.backgroundColor = [UIColor clearColor];
    self.contractTv.returnKeyType = UIReturnKeyDone;
    self.contractTv.delegate = self;
    [contentView addSubview:self.contractTv];
    
    self.contractTv.placeholderLabel.frame = CGRectMake(0, self.contractTv.top +  self.contractTv.font.pointSize/2 + 50, self.contractTv.width, self.contractTv.height);
   
    
    self.contractSepLine = [[VSeparatorLine alloc] initWithFrame:CGRectMake(0, self.contractTv.bottom + 8, contentView.width, 1)];
    [contentView addSubview:self.contractSepLine];
    
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contractSepLine.bottom + 16, contentView.width, 48)];
    self.nextBtn.layer.cornerRadius = 6;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.backgroundColor = [[VColor themeColor] CGColor];
    [self.nextBtn setTitle:VLocalize(@"contract.btn.next") forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.nextBtn];
    
    self.balanceLbl = [[VThemeLabel alloc] initWithFrame:CGRectMake(0, self.contractSepLine.bottom, contentView.width, 39)];
    self.balanceLbl.font = [UIFont systemFontOfSize:13.0];
    self.balanceLbl.text = VLocalize(@"account.transaction.available.balance");
    self.balanceLbl.colorLevel = 1;
    self.balanceLbl.hidden = YES;
    [contentView addSubview:self.balanceLbl];
    
    
    self.amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.balanceLbl.bottom + 12, contentView.width - 63, 22)];
    self.amountLbl.font = [UIFont systemFontOfSize:15.0];
    self.amountLbl.text = VLocalize(@"transaction.detail.amount");
    self.amountLbl.hidden = YES;
    [contentView addSubview:self.amountLbl];
    
    self.maxBtn = [[VThemeButton alloc] initWithFrame:CGRectMake(contentView.width - 53, self.amountLbl.top, 53, 22)];
    self.maxBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.maxBtn setTitleColor:[VColor themeColor] forState:UIControlStateNormal];
    [self.maxBtn setTitle:VLocalize(@"account.transaction.max") forState:UIControlStateNormal];
    self.maxBtn.hollow = YES;
    self.maxBtn.secondTheme = YES;
    self.maxBtn.submit = YES;
    self.maxBtn.layer.cornerRadius = 11;
    [self.maxBtn addTarget:self action:@selector(maxBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.maxBtn.hidden = YES;
    [contentView addSubview:self.maxBtn];
    
    self.amountTv = [[VThemeTextField alloc] initWithFrame:CGRectMake(0, self.amountLbl.bottom + 10, contentView.width, 48)];
    self.amountTv.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountTv.placeholder = @"0.00";
    self.amountTv.font = [UIFont systemFontOfSize:40.0];
    self.amountTv.hidden = YES;
    [contentView addSubview:self.amountTv];
    
    self.amountSepLine = [[VSeparatorLine alloc] initWithFrame:CGRectMake(0, self.amountTv.bottom + 8, contentView.width, 1)];
    self.amountSepLine.hidden = YES;
    [contentView addSubview:self.amountSepLine];
    
    self.continueBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.amountSepLine.bottom + 16, contentView.width, 48)];
    self.continueBtn.layer.cornerRadius = 6;
    self.continueBtn.layer.masksToBounds = YES;
    self.continueBtn.layer.backgroundColor = [[VColor themeColor] CGColor];
    [self.continueBtn setTitle:VLocalize(@"contract.btn.deposit") forState:UIControlStateNormal];
    if(self.operateType == TransactionOperateTypeWithdraw) {
        [self.continueBtn setTitle:VLocalize(@"contract.btn.withdraw")forState:UIControlStateNormal];
    }
    [self.continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.continueBtn.hidden = YES;
    [contentView addSubview:self.continueBtn];
    
    self.scrollView.contentSize = CGSizeMake(0, self.continueBtn.bottom + 64);
}

-(void) viewDidLayoutSubviews {
    self.contractTv.placeholder = VLocalize(@"contract.id.input.placeholder");
}

-(void) relayout {
    self.contractSepLine.top = self.contractTv.bottom + 8;
    self.nextBtn.top = self.contractSepLine.bottom + 16;
    self.balanceLbl.top = self.contractSepLine.bottom + 0;
    self.amountLbl.top = self.balanceLbl.bottom + 12;
    self.maxBtn.top = self.amountLbl.top;
    self.amountTv.top = self.amountLbl.bottom + 10;
    self.amountSepLine.top = self.amountTv.bottom + 8;
    self.continueBtn.top = self.amountSepLine.bottom + 16;
    self.scrollView.contentSize = CGSizeMake(0, self.continueBtn.bottom + 64);
}

- (void) nextBtnClick:(UIButton *) sender {
    [self.amountTv resignFirstResponder];
    [self.contractTv resignFirstResponder];
    if(![Regex matchRegexStr:@"^[a-zA-Z0-9]+$" string:self.contractTv.text]) {
        [self remindWithMessage:VLocalize(@"contract.error.invalid")];
        return;
    }
    
    self.nextBtn.userInteractionEnabled = NO;
    __weak typeof (self) weakSelf = self;
    [self checkContractId:^(BOOL isSuc) {
        weakSelf.nextBtn.userInteractionEnabled = YES;
        if(isSuc) {
            [weakSelf showNext];
        }
    }];
}

- (void) showNext {
    self.nextBtn.hidden = YES;
    self.balanceLbl.hidden = NO;
    self.amountLbl.hidden = NO;
    self.maxBtn.hidden = NO;
    self.amountTv.hidden = NO;
    self.amountSepLine.hidden = NO;
    self.continueBtn.hidden = NO;
}

- (void) checkContractId:(void (^)(BOOL isSuc))callback {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loadingView];
    [loadingView startLoadingWithColor:VColor.themeColor];
    
    __weak typeof (self) weakSelf = self;
    [ApiServer getContractInfo:self.contractTv.text callback:^(BOOL isSuc, Contract * _Nonnull contract) {
        if (isSuc) {
            if([contract.type isEqualToString: @"LockContract"] || [contract.type isEqualToString:@"PaymentChannelContract"]) {
                for(ContractInfoItem *info in contract.info) {
                    if([info.type isEqualToString:@"TokenId"]) {
                        weakSelf.token.tokenId = info.data;
                        break;
                    }
                }
                if(![NSString isNilOrEmpty: weakSelf.token.tokenId]) {
                    [weakSelf getAvailableBalance:^(BOOL isSuc, NSString *balance) {
                        [loadingView stopLoading];
                        [loadingView removeFromSuperview];
                        if(isSuc) {
                            self.balanceLbl.text = [VLocalize(@"account.transaction.available.balance") stringByAppendingString: [NSString stringWithFormat:@" %@", balance]];
                        } else {
                            [weakSelf remindWithMessage:VLocalize(@"contract.error.query.failed")];
                        }
                        callback(isSuc);
                    }];
                    
                } else {
                    [loadingView stopLoading];
                    [loadingView removeFromSuperview];
                    [weakSelf remindWithMessage:VLocalize(@"contract.error.query.failed")];
                    callback(NO);
                }
            } else {
                [loadingView stopLoading];
                [loadingView removeFromSuperview];
                [weakSelf remindWithMessage:VLocalize(@"contract.error.type.invalid")];
                callback(NO);
            }
        }else {
            [loadingView stopLoading];
            [loadingView removeFromSuperview];
            [weakSelf remindWithMessage:VLocalize(@"contract.error.query.failed")];
            callback(NO);
        }
    }];
}

- (void) loadContractContent:(NSString *)contractId token: (VsysToken *)token callback:(void (^)(BOOL isSuc))callback {
    [ApiServer getContractContent:contractId callback:^(BOOL isSuc, ContractContent * _Nonnull contractContent) {
        if (contractContent.textual && contractContent.textual.descriptors) {
            token.textualDescriptor = contractContent.textual.descriptors;
            NSString *funcJson = VsysDecodeContractTexture(token.textualDescriptor);
            if ([funcJson containsString:@"split"]) {
                token.splitable = true;
            }
        }
        callback(isSuc);
    }];
}

- (void) getAvailableBalance:(void (^)(BOOL isSuc, NSString *balance))callback {
    __weak typeof (self) weakSelf = self;
    NSString *paymentOrLockContractId = weakSelf.contractTv.text;
    NSString *tokenContractId = VsysTokenId2ContractId(weakSelf.token.tokenId);
    switch (weakSelf.operateType) {
        case TransactionOperateTypeDeposit:
        {
            [ApiServer getAddressTokenBalance:weakSelf.account.originAccount.address tokenId:weakSelf.token.tokenId callback:^(BOOL isSuc, VsysToken * _Nonnull token) {
                weakSelf.token = token;
                if(isSuc) {
                    [weakSelf loadContractContent:tokenContractId token:weakSelf.token callback:^(BOOL isSuc) {
                        NSString * available = [NSString stringWithDecimal:[NSString getAccurateDouble:token.balance unity: token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
                        callback(isSuc, available);
                    }];
                   
                } else {
                    callback(NO, @"0.00");
                }
            }];
        }
            break;
        case TransactionOperateTypeWithdraw:
        {
            [ApiServer getContractData:paymentOrLockContractId dbKey:VsysGetContractBalanceDbKey(weakSelf.account.originAccount.address) callback:^(BOOL isSuc, ContractData * _Nonnull contractData) {
                if(isSuc) {
                    [ApiServer getTokenInfo:weakSelf.token.tokenId callback:^(BOOL isSuc, VsysToken * _Nonnull token) {
                        if(isSuc) {
                            weakSelf.token = token;
                            weakSelf.token.balance = contractData.value;
                            
                            [weakSelf loadContractContent:tokenContractId token:weakSelf.token callback:^(BOOL isSuc) {
                                NSString *available = [NSString stringWithDecimal:[NSString getAccurateDouble:contractData.value unity: token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
                                callback(isSuc, available);
                            }];
                            
                        } else {
                            callback(NO, @"0.00");
                        }
                    }];
                } else {
                    callback(NO, @"0.00");
                }
            }];
        }
            
            break;
        default:
            callback(NO, @"0.00");
            break;
    }
}

- (void) continueBtnClick:(UIButton *) sender {
    [self.amountTv resignFirstResponder];
    [self.contractTv resignFirstResponder];
    
    if(![Regex matchRegexStr:@"^[a-zA-Z0-9]+$" string:self.contractTv.text]) {
        [self remindWithMessage:VLocalize(@"contract.error.invalid")];
        return;
    }
    
    if (self.amountTv.text.doubleValue * self.token.unity > self.token.balance) {
        [self alertWithTitle:VLocalize(@"tip.transaction.insufficient.token.balance") confirmText:nil];
        return;
    }
    
    if (self.amountTv.text.doubleValue <= 0) {
        [self alertWithTitle:VLocalize(@"tip.transaction.amount.invalid") confirmText:nil];
        return;
    }
    
    if(self.account.availableBalance < VsysDefaultContractExecuteFee) {
        [self alertWithTitle:VLocalize(@"tip.transaction.insufficient.balance") confirmText:nil];
        return;
    }
    
    self.continueBtn.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self checkContractId:^(BOOL isSuc) {
        weakSelf.continueBtn.userInteractionEnabled = YES;
        if(isSuc) {
            [weakSelf createTransaction];
        }
    }];
    
}


- (void)createTransaction {
    VsysTransaction *tx;
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.amountTv.text];
    switch (self.operateType) {
        case TransactionOperateTypeDeposit: {
            NSDecimalNumber *unity = [[NSDecimalNumber alloc] initWithLongLong:self.token.unity];
            VsysContract *c = [VsysContract new];
            c.senderAddr = self.account.originAccount.address;
            c.contractId = self.contractTv.text;
            c.amount = [[amount decimalNumberByMultiplyingBy:unity] longLongValue];
            tx = VsysNewExecuteTransaction(VsysTokenId2ContractId(self.token.tokenId), VsysBase58EncodeToString([c buildDepositData]), VsysGetFuncIndexFromDescriptor(self.token.textualDescriptor, @"deposit"), @"");
            
        } break;
        case TransactionOperateTypeWithdraw: {
            NSDecimalNumber *unity = [[NSDecimalNumber alloc] initWithLongLong:self.token.unity];
            VsysContract *c = [VsysContract new];
            c.recipient = self.account.originAccount.address;
            c.contractId = self.contractTv.text;
            c.amount = [[amount decimalNumberByMultiplyingBy:unity] longLongValue];
            tx = VsysNewExecuteTransaction(VsysTokenId2ContractId(self.token.tokenId), VsysBase58EncodeToString([c buildWithdrawData]),  VsysGetFuncIndexFromDescriptor(self.token.textualDescriptor, @"withdraw"), @"");
        } break;
        default:
            break;
    }
    if (!tx) {
        return;
    }
    tx.tokenIdx = VsysTokenId2TokenIdx(self.token.tokenId);
    
    Transaction *transaction = [[Transaction alloc] init];
    transaction.originTransaction = tx;
    if(self.operateType == TransactionOperateTypeDeposit) {
        transaction.contractFuncName = VsysActionDeposit;
    } else if (self.operateType == TransactionOperateTypeWithdraw) {
        transaction.contractFuncName = VsysActionWithdraw;
    } else {
        transaction.contractFuncName = VsysActionSend;
    }
    
    transaction.senderAddress = self.account.originAccount.address;
    transaction.ownerAddress = self.account.originAccount.address;
    transaction.ownerPublicKey = self.account.originAccount.publicKey;
    transaction.signature = [self.account.originAccount signData:tx.buildTxData];
    [self beginTransactionConfirmWithTransaction:transaction account:self.account token:self.token];
}


- (void) maxBtnClick {
    NSDecimalNumber *tokenAmount = [[NSDecimalNumber alloc] initWithLongLong:self.token.balance];
    NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLongLong:self.token.unity];
    self.amountTv.text = [NSString stringWithDecimal:[tokenAmount decimalNumberByDividingBy:unityDecimal] maxFractionDigits:[NSString getDecimal:self.token.unity] minFractionDigits:2 trimTrailing:YES];
}

- (void) pasteBtnClick {
    self.contractTv.text = UIPasteboard.generalPasteboard.string;
    [self textViewDidChange:self.contractTv];
}

- (void) scanQRBtnClick {
    __weak typeof(self) weakSelf = self;
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:nil result:^(NSString * _Nullable qrCode) {
            [weakSelf scanQRcodeResult:qrCode];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}


- (void)scanQRcodeResult:(NSString *)qrCode {
    self.contractTv.text = qrCode;
    [self textViewDidChange:self.contractTv];
}

-(void) textViewDidChange:(UITextView *)textView {
    [textView updatePlaceholderState];
    if(textView.height != textView.contentSize.height) {
        textView.height = textView.contentSize.height;
        [self relayout];
    }
}

@end
