//
// MnemonicWordImportViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "MnemonicWordImportViewController.h"
#import "Language.h"
#import "MediaManager.h"
#import "QRScannerViewController.h"
#import "UIViewController+Alert.h"
#import "VColor.h"
#import "WalletMgr.h"
#import "PasswordSettingsViewController.h"
#import "VAlertViewController.h"
#import <Masonry/Masonry.h>
#import "WindowManager.h"
#import "VStoryboard.h"
#import "UITextView+Placeholder.h"
#import "AppDelegate.h"
@import Vsys;
#import "Regex.h"

@interface MnemonicWordImportViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation MnemonicWordImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.mnemonic.import");
    self.tipLabel.text = VLocalize(@"mnemonic.import.detail");
    self.textView.superview.layer.borderColor = VColor.borderColor.CGColor;
    self.textView.placeholder = VLocalize(@"mnemonic.import.placeholder");
    self.view.backgroundColor = VColor.rootViewBgColor;
    [self.nextBtn setTitle:VLocalize(@"next") forState:UIControlStateNormal];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self nextBtnClick];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.textView updatePlaceholderState];
    BOOL enabled = [Regex matchRegexStr:@"^([A-Za-z]+\\s){14}[A-Za-z]+$" string:textView.text];
    self.nextBtn.alpha = enabled ? 1.f : 0.5f;
    self.nextBtn.tag = enabled;
}

- (IBAction)scanBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.textView resignFirstResponder];
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:@"/#cold/export?seed=[^\\s]*" noMatchTipText:VLocalize(@"tip.qrcode.unsupported.types") result:^(NSString * _Nullable qrCode) {
//            NSLog(@" - im - qrCode = %@", qrCode);
            NSArray *arr = [qrCode componentsSeparatedByString:@"/#cold/export?seed="];
            if (arr.count != 2) {
                [weakSelf alertWithTitle:VLocalize(@"tip.qrcode.unsupported.types") confirmText:nil];
                return ;
            }
            weakSelf.textView.text = arr[1];
            [weakSelf textViewDidChange:weakSelf.textView];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (IBAction)nextBtnClick {
    if (self.textView.text.length == 0) {
        [self alertWithTitle:VLocalize(@"tip.mnemonic.validate.error.title") confirmText:VLocalize(@"ok")];
        return;
    }
    if (self.nextBtn.tag) {
        if (!VsysValidatePhrase(self.textView.text)) {
            [self showUnofficialAlert];
//            [self alertWithTitle:VLocalize(@"import_phrase_validate_err") confirmText:VLocalize(@"ok")];
        } else {
            [self generateWalletWithSeed:self.textView.text];
        }
    } else {
        [self showUnofficialAlert];
    }
}

- (void)showUnofficialAlert {
    UIGraphicsBeginImageContextWithOptions(self.textView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.textView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeTopLeft;
    imgView.layer.borderColor = VColor.borderColor.CGColor;
    imgView.layer.cornerRadius = 6.f;
    imgView.layer.borderWidth = 1.f;
    VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.mnemonic.unofficial.title") secondTitle:VLocalize(@"tip.mnemonic.unofficial.detail") contentView:^(UIStackView * _Nonnull parentView) {
        [parentView addArrangedSubview:imgView];
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView);
            make.height.equalTo(@(120));
        }];
    } cancelTitle: VLocalize(@"cancel") confirmTitle:VLocalize(@"confirm") cancel:^{
        
    } confirm:^{
        [self generateWalletWithSeed:self.textView.text];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)generateWalletWithSeed:(NSString *)seed {
    WalletMgr.shareInstance.seed = seed;
    VsysWallet *wallet = VsysNewWallet(seed, WalletMgr.shareInstance.network);
    WalletMgr.shareInstance.wallet = wallet;
    WalletMgr.shareInstance.accountSeeds = @[];
    PasswordSettingsViewController *setPwdVC = [[PasswordSettingsViewController alloc] initWithTitle:VLocalize(@"password.create.item1.title") success:^(NSString * _Nonnull password) {
        WalletMgr.shareInstance.password = password;
        NSError *error = [WalletMgr.shareInstance generateSalt:password];
        if (error) {
            NSLog(@"generateSalt error: %@", error);
            return;
        }
        error = [WalletMgr.shareInstance saveToStorage];
        if (error) {
            NSLog(@"save storage error: %@", error);
            return;
        }
        [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
    }];
    [self.navigationController pushViewController:setPwdVC animated:YES];
}

@end
