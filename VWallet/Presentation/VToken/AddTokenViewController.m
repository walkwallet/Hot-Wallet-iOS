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

#import "UITextView+Placeholder.h"

@interface AddTokenViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tokenIdNoteLabel;
@property (weak, nonatomic) IBOutlet VThemeTextView *tokenIdTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorLabelHeight;
@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scanQRcodeResult:(NSString *)qrCode {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[qrCode dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    NSString *tokenId = dict[@"id"] ? : @"";
    self.tokenIdTextFiled.text = tokenId;
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

- (BOOL)checkTokenId {
    BOOL tokenValid = NO;
    NSString *tokenId = self.tokenIdTextFiled.text;
    if(tokenId.length == 41) {
        tokenValid = YES;
        __weak typeof(self) weakSelf = self;
        [ApiServer getTokenById:tokenId callback:^(BOOL isSuc, Token *token) {
            if (isSuc) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.errorLabelHeight.constant = 0;
                }];
                NSLog(@"--->%@", token);
            }else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.errorLabelHeight.constant = 15;
                }];
                weakSelf.errorLabel.text = VLocalize(@"token.operate.error.id_not_exist");
            }
        }];
    }else {
        self.errorLabel.text = VLocalize(@"token.operate.error.id_format");
        [UIView animateWithDuration:0.2 animations:^{
            self.errorLabelHeight.constant = 15;
        }];
    }
    return tokenValid;
}

@end
