//
// PasswordSettingsViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "PasswordSettingsViewController.h"

#import "Language.h"
#import "VLevelBar.h"
#import "VColor.h"

#import "ResultViewController.h"

@interface PasswordSettingsViewController ()

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, strong) void(^successBlock)(NSString *);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet VLevelBar *secureLevelView;
@property (weak, nonatomic) IBOutlet UILabel *secureLevelLabel;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdLengthTipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdLengthTipLabelHeightLC;

@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdConsistencyTipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdConsistencyTipLabelHeightLC;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation PasswordSettingsViewController

- (instancetype)initWithTitle:(NSString *)title success:(void (^)(NSString * _Nonnull))success {
    if (self = [super init]) {
        self.pageTitle = title;
        self.successBlock = success;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = self.pageTitle;
    self.titleLabel.text = VLocalize(@"password.create.detail");
    self.titleLabel1.text = VLocalize(@"password.create.item1.title");
    self.titleLabel2.text = VLocalize(@"password.create.item2.title");
    self.pwdTextField.placeholder = VLocalize(@"password.create.item1.detail");
    self.pwdLengthTipLabel.text = VLocalize(@"password.create.length.title");
    self.pwdLengthTipLabelHeightLC.constant = 8;
    self.confirmPwdTextField.placeholder = VLocalize(@"password.create.item2.detail");
    self.pwdConsistencyTipLabel.text = VLocalize(@"password.create.consistency.error.title");
    self.pwdConsistencyTipLabelHeightLC.constant = 8;
    [self.submitBtn setTitle:VLocalize(@"done") forState:UIControlStateNormal];
    
    [self.pwdTextField becomeFirstResponder];
    [self checkFormData];
}

- (IBAction)pwdtextFieldEditingChanged:(UITextField *)sender {
    if (sender == self.pwdTextField) {
        [self.secureLevelView updateLevelWithPassword:sender.text];
        self.secureLevelLabel.textColor = self.secureLevelView.levelColor;
        self.secureLevelLabel.text = @[@"",
                                       VLocalize(@"secure.level.1"),
                                       VLocalize(@"secure.level.2"),
                                       VLocalize(@"secure.level.3"),
                                       VLocalize(@"secure.level.4"),
                                       VLocalize(@"secure.level.5")][self.secureLevelView.level];
        self.pwdLengthTipLabel.hidden = sender.text.length >= 8;
        self.pwdLengthTipLabelHeightLC.constant = self.pwdLengthTipLabel.hidden ? 8 : 31;
    }
    if (sender == self.confirmPwdTextField || self.confirmPwdTextField.text.length) {
        self.pwdConsistencyTipLabel.hidden = [self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text];
        self.pwdConsistencyTipLabelHeightLC.constant = self.pwdConsistencyTipLabel.hidden ? 8 : 31;
    }
    [self checkFormData];
}

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
    if (sender == self.pwdTextField) {
        [self.confirmPwdTextField becomeFirstResponder];
    } else if (sender == self.confirmPwdTextField) {
        if (self.submitBtn.enabled) {
            [self submitBtnClick];
        } else {
            [self.view endEditing:YES];
        }
    }
}

- (void)checkFormData {
    self.submitBtn.enabled = (self.pwdTextField.text.length >= 8 && [self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text]);
}

- (IBAction)submitBtnClick {
    if (self.secureLevelView.level < 3) {
        NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:VLocalize(@"password.weak.title") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32]}];
        NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"password.weak.detail") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightLight]}];
        ResultParameter *parameter = [ResultParameter paramterWithImgResourceName:@"ico_warning_tip" attrTitle:attrTitle attrMessage:attrMessage titleMessageSpecing:8];
        [parameter setOperateBtnTitle:VLocalize(@"password.weak.btn1.title")];
        [parameter setSecondOperateBtnTitle:VLocalize(@"password.weak.btn2.title")];
        __weak typeof(self) weakSelf = self;
        [parameter setSecondOperateBlock:^{
            [weakSelf normalSubmit];
        }];
        ResultViewController *resultVC = [[ResultViewController alloc] initWithResultParameter:parameter];
//        [self.navigationController pushViewController:resultVC animated:YES];
        [self presentViewController:resultVC animated:YES completion:nil];
    } else {
        [self normalSubmit];
    }
}

- (void)normalSubmit {
    if (self.successBlock) {
        self.successBlock(self.pwdTextField.text);
    }
}

@end
