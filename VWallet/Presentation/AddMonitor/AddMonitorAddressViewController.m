//
// AddMonitorAddressViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AddMonitorAddressViewController.h"
#import "Language.h"
#import "MediaManager.h"
#import "UIViewController+NavigationBar.h"
#import "QRScannerViewController.h"
#import "UIViewController+Alert.h"
#import "VColor.h"
#import "WalletMgr.h"
#import "VAlertViewController.h"
#import <Masonry/Masonry.h>
#import "VStoryboard.h"
#import "UITextView+Placeholder.h"

@import Vsys;

@interface AddMonitorAddressViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AddMonitorAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    if (self.configureBlock) {
        self.configureBlock(self);
    }
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.monitor.add.title");
    self.tipLabel.text = VLocalize(@"monitor.address.add.title");
    self.tipLabel1.text = VLocalize(@"monitor.address.add.title1");
    self.tipLabel2.text = VLocalize(@"monitor.address.add.title2");
    self.textView.placeholder = VLocalize(@"monitor.address.add.textview1.placeholder");
    self.textView2.placeholder = VLocalize(@"monitor.address.add.textview2.placeholder");
    self.textView.superview.layer.borderColor = VColor.borderColor.CGColor;
    self.textView2.superview.layer.borderColor = VColor.borderColor.CGColor;
    self.view.backgroundColor = VColor.rootViewBgColor;
    [self.nextBtn setTitle:VLocalize(@"done") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeToThemeNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 100);
    }];
}

- (void)keyboardWillHide {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointZero;
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    BOOL enabled = VsysValidateAddress(self.textView.text);
    self.nextBtn.alpha = enabled ? 1.f : 0.5f;
    self.nextBtn.tag = enabled;
    [textView updatePlaceholderState];
}

- (IBAction)scanBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.textView resignFirstResponder];
    [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:VLocalize(@"tip.qrcode.unsupported.types") result:^(NSString * _Nullable qrCode) {
            [weakSelf processWithQrCode:qrCode];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (void)processWithQrCode: (NSString *)qrcode {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[qrcode dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if ([dict[@"api"] integerValue] > VsysApi) {
        [self alertWithTitle:VLocalize(@"tip.qrcode.unsupported.version") confirmText:nil];
        return;
    }
    if (error || ![dict[@"opc"] isEqualToString:VsysOpcTypeAccount]) {
        [self alertWithTitle:VLocalize(@"tip.qrcode.unsupported.types") confirmText:nil];
        return;
    }

    NSString *address = dict[@"address"] ? : @"";
    if (![WalletMgr.shareInstance.network isEqualToString:VsysGetNetworkFromAddress(address)]) {
        [self alertWithTitle:VLocalize(@"tip.monitor.address.add.network.err") confirmText:nil];
        return ;
    }
    
    self.textView2.text = dict[@"publicKey"];
    self.textView.text = address;
    [self textViewDidChange:self.textView];
    [self.textView updatePlaceholderState];
    [self.textView2 updatePlaceholderState];
}

- (IBAction)nextBtnClick {
    if (self.textView.text.length == 0) {
        [self alertWithTitle:VLocalize(@"tip.monitor.address.add.err1") confirmText:VLocalize(@"ok")];
        return;
    }
    VsysAccount *acc = VsysNewAccount(WalletMgr.shareInstance.network, self.textView2.text);
    if (![acc.address isEqualToString:self.textView.text]) {
        [self alertWithTitle:VLocalize(@"tip.monitor.address.add.err1") confirmText:VLocalize(@"ok")];
        return;
    }
    if (self.nextBtn.tag) {
        [self addMonitorAcocunt: acc];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self alertWithTitle:VLocalize(@"tip.monitor.address.add.err1") confirmText:VLocalize(@"ok")];
    }
}

- (void)addMonitorAcocunt:(VsysAccount *)acc {
    Account *account = [Account new];
    account.originAccount = acc;
    if (![WalletMgr.shareInstance addMonitorAccount:account]) {
        [self alertWithTitle:VLocalize(@"tip.monitor.address.add.exist.err2") confirmText:VLocalize(@"ok")];
    }
}

@end
