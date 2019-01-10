//
//  ToastPasswordViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ToastPasswordViewController.h"
#import "WalletMgr.h"
#import "Language.h"
#import "UIViewController+Alert.h"

@interface ToastPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnWidthLC;
@property (nonatomic, strong) void(^resultBlock)(BOOL);
@property (nonatomic, copy) NSString *confirmTitle;

@end

@implementation ToastPasswordViewController

- (instancetype)initWithConfirmTitle:(NSString *)confirmTitle result:(void (^)(BOOL))result {
    if (self = [super init]) {
        self.resultBlock = result;
        self.confirmTitle = confirmTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.confirmBtn setTitle:self.confirmTitle forState:UIControlStateNormal];
    self.confirmBtnWidthLC.constant = [self.confirmTitle sizeWithAttributes:@{NSFontAttributeName : self.confirmBtn.titleLabel.font}].width + 32;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

- (IBAction)textFieldEditingChanged {
    self.confirmBtn.enabled = self.textField.text.length > 0;
}

- (IBAction)confirmBtnClick {
    [self.view endEditing:YES];
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
@end
