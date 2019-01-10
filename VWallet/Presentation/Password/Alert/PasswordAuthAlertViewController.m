//
// PasswordAuthAlertViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "PasswordAuthAlertViewController.h"
#import "VAlertViewController.h"
#import "Language.h"
#import <Masonry/Masonry.h>
#import "WalletMgr.h"
#import "UIViewController+Alert.h"
#import "UITextView+Placeholder.h"
#import "VStoryboard.h"
#import "WindowManager.h"

@interface PasswordAuthAlertViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) void(^resultBlock)(BOOL);
@property (nonatomic, strong) PasswordInput *model;
@property (nonatomic, weak) UIViewController *rootVc;
@end

@implementation PasswordAuthAlertViewController

- (instancetype)initWithModel:(PasswordInput *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)showPasswordAlert:(UIViewController *)rootVc result:(void(^ __nullable)(BOOL success))result {
    self.resultBlock = result;
    self.rootVc = rootVc;
    __weak typeof(self) weakSelf = self;
    VAlertViewController *vc = [[VAlertViewController alloc] initWithIconName:@"" title:self.model.title secondTitle:self.model.titleDetail contentView:^(UIStackView * _Nonnull parentView) {
        [parentView addArrangedSubview:weakSelf.view];
        [weakSelf.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView);
            make.height.equalTo(@(40));
        }];
        weakSelf.textField.placeholder = self.model.placeholder;
    } cancelTitle: VLocalize(@"cancel") confirmTitle:VLocalize(@"confirm") cancel:^{
        [weakSelf.textField resignFirstResponder];
        [weakSelf.rootVc dismissViewControllerAnimated:YES completion:nil];
    } confirm:^{
        [weakSelf passwordAuth:self.textField];
    }];
    vc.notDismiss = YES;
    [rootVc presentViewController:vc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)passwordAuth:(id)sender {
    [self.view endEditing:YES];
    if (WalletMgr.shareInstance.password) {
        BOOL suc = [WalletMgr.shareInstance.password isEqualToString: self.textField.text];
        if (suc) {
            if (_resultBlock) {
                _resultBlock(YES);
            }
        } else {
            __weak typeof(self) weakSelf = self;
            if (_resultBlock) {
                _resultBlock(NO);
                [self alertWithTitle:VLocalize(@"tip.password.auth.err.title") confirmText:VLocalize(@"tip.password.auth.err.btn2.title") handler:^{
                    [weakSelf.textField becomeFirstResponder];
                }];
            }
        }
    }
}

@end
