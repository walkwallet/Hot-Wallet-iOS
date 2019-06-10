//
//  AddTokenViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "AddTokenViewController.h"
#import "QRScannerViewController.h"
#import "VThemeTextView.h"
#import "Language.h"
#import "Account.h"
#import "ApiServer.h"
#import "Token.h"
#import "Contract.h"
#import "UIView+Loading.h"
#import "UIViewController+Alert.h"

#import "UITextView+Placeholder.h"
#import "TokenMgr.h"

@interface AddTokenViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tokenIdNoteLabel;
@property (weak, nonatomic) IBOutlet VThemeTextView *tokenIdTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorLabelHeight;
@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) Token *token;
@end

@implementation AddTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (instancetype)initWithAccount:(Account *)account {
    if (self = [super init]) {
        self.account = account;
    }
    return self;
}

- (void)initView {
    self.title = VLocalize(@"token.add_token");
    self.doneButton.alpha = 0.5;
    [self.doneButton setTitle:VLocalize(@"done") forState:UIControlStateNormal];
    self.tokenIdNoteLabel.text = VLocalize(@"token.token_id_note");
    self.tokenIdTextFiled.placeholder = VLocalize(@"token.input_token_id");
    self.tokenIdTextFiled.delegate = self;
    self.errorLabelHeight.constant = 0;
}

- (IBAction)ClickPaste:(id)sender {
    self.tokenIdTextFiled.text = UIPasteboard.generalPasteboard.string;
    [self.tokenIdTextFiled updatePlaceholderState];
    [self checkTokenId];
}

- (IBAction)ClickQRCode:(id)sender {
    __weak typeof(self) weakSelf = self;
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:nil result:^(NSString * _Nullable qrCode) {
            [weakSelf scanQRcodeResult:qrCode];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (IBAction)ClickDone:(id)sender {
    NSString *tokenId = self.tokenIdTextFiled.text;
    __weak typeof (self) weakSelf = self;
    [ApiServer getAddressTokenBalance:self.account.originAccount.address tokenId:tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
        if (isSuc) {
            if ([weakSelf.token.tokenId isEqualToString:token.tokenId]) {
                NSArray<Token*> *oldList = [TokenMgr.shareInstance loadAddressWatchToken:weakSelf.account.originAccount.address];
                for (Token *one in oldList) {
                    if ([one.tokenId isEqualToString:weakSelf.token.tokenId]) {
                        [weakSelf alertWithTitle:VLocalize(@"error.token.exist")  confirmText:VLocalize(@"close")];
                        return;
                    }
                }
                [ApiServer getContractContent:weakSelf.token.contractId callback:^(BOOL isSuc, ContractContent * _Nonnull contractContent) {
                    if (contractContent.textual && contractContent.textual.descriptors) {
                        weakSelf.token.textualDescriptor = contractContent.textual.descriptors;
                        NSMutableArray *newList = [[NSMutableArray alloc] init];
                        [newList addObjectsFromArray:oldList];
                        weakSelf.token.balance = token.balance;
                        [newList addObject:weakSelf.token];
                        NSError *error = [TokenMgr.shareInstance saveToStorage:self.account.originAccount.address list:newList];
                        if (error != nil) {
                            [weakSelf alertWithTitle:[error localizedDescription] confirmText:VLocalize(@"close")];
                        }else {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                    }else {
                        [weakSelf alertWithTitle:@"" confirmText:VLocalize(@"")];
                    }
                }];
            }else {
                [weakSelf alertWithTitle:VLocalize(@"") confirmText:VLocalize(@"close")];
            }
        }else {
            [weakSelf alertWithTitle:VLocalize(@"fail.add.token") confirmText:VLocalize(@"close")];
        }
    }];
}

- (void)loadContractTextualDescriptor:(NSString *)contractId {
    __weak typeof (self) weakSelf = self;
    [ApiServer getContractContent:contractId callback:^(BOOL isSuc, ContractContent * _Nonnull contractContent) {
        if (contractContent.textual && contractContent.textual.descriptors) {
            weakSelf.token.textualDescriptor = contractContent.textual.descriptors;
        }
    }];
}

- (void)scanQRcodeResult:(NSString *)qrCode {
    self.tokenIdTextFiled.text = qrCode;
    [self.tokenIdTextFiled updatePlaceholderState];
    [self checkTokenId];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView updatePlaceholderState];
    if (textView == self.tokenIdTextFiled) {
        [self checkTokenId];
    }
}

- (void)checkTokenId {
    BOOL tokenValid = NO;
    NSString *tokenId = self.tokenIdTextFiled.text;
    if(tokenId.length == 41) {
        tokenValid = YES;
        __weak typeof (self) weakSelf = self;
        [ApiServer getTokenInfo:tokenId callback:^(BOOL isSuc, Token * _Nonnull token) {
            if (isSuc) {
                weakSelf.token = token;
                [weakSelf showError:@""];
            }else {
                [weakSelf showError:VLocalize(@"token.operate.error.id.not.exist")];
            }
        }];
    }else {
        [self showError:VLocalize(@"token.operate.error.id.format")];
    }
}

- (void)showError:(NSString*)error {
    if ([error isEqualToString:@""]) {
        self.errorLabel.text = @"";
        [UIView animateWithDuration:0.2 animations:^{
            self.errorLabelHeight.constant = 0;
            [self.doneButton setEnabled:YES];
            self.doneButton.alpha = 1;
        }];
    }else {
        self.errorLabel.text = error;
        [UIView animateWithDuration:0.2 animations:^{
            self.errorLabelHeight.constant = 15;
            [self.doneButton setEnabled:NO];
            self.doneButton.alpha = 0.5;
        }];
    }
}

@end
