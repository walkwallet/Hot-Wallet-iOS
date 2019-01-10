//
// ReceiveSetAmountAlertController.m
//  Wallet
//
//  All rights reserved.
//

#import "ReceiveSetAmountAlertController.h"
@import Vsys;
#import "Language.h"
#import "Regex.h"

@interface ReceiveSetAmountAlertController () <UITextFieldDelegate>

@property (nonatomic, strong) void(^resultBlock)(int64_t);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomLC;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ReceiveSetAmountAlertController

- (instancetype)initWithResult:(void (^)(int64_t))result {
    if (self = [super init]) {
        self.resultBlock = result;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.titleLabel.text = VLocalize(@"account.receive.amount");
    [self.cancelBtn setTitle:VLocalize(@"cancel") forState:UIControlStateNormal];
    [self.confirmBtn setTitle:VLocalize(@"confirm") forState:UIControlStateNormal];
}

- (IBAction)comfirmBtnClick {
    if (self.resultBlock) {
        self.resultBlock(self.textField.text.doubleValue * VsysVSYS);
    }
    [self close];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [Regex matchRegexStr:@"[\\d\\.]*" string:string];
}

#pragma mark - keyboard
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.textField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewKeyframeAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:duration delay:0 options:option animations:^{
        weakSelf.contentViewBottomLC.constant = keyboardHeight + 20;
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.isBeingDismissed) {
        [self close];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
