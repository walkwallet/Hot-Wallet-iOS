//
// ReceiveSetAmountViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ReceiveSetAmountViewController.h"
#import "Language.h"
#import "Regex.h"
@import Vsys;

@interface ReceiveSetAmountViewController () <UITextFieldDelegate>

@property (nonatomic, strong) void(^resultBlock)(int64_t);

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *textField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ReceiveSetAmountViewController

- (instancetype)initWithResult:(void (^)(int64_t))result {
    if (self = [super init]) {
        self.resultBlock = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.set.amount");
    self.descLabel.text = VLocalize(@"account.receive.amount");
    [self.nextBtn setTitle:VLocalize(@"next") forState:UIControlStateNormal];
    [self.textField becomeFirstResponder];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [Regex matchRegexStr:@"[\\d\\.]*" string:string];
}

- (IBAction)nextBtnClick {
    if (self.resultBlock) {
        self.resultBlock(self.textField.text.doubleValue * VsysVSYS);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
