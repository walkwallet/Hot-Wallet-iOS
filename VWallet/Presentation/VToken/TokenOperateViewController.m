//
//  CreateTokenViewController.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenOperateViewController.h"
#import "Account.h"
#import "VThemeTextField.h"
#import "VThemeTextView.h"
#import "VThemeButton.h"
#import "Account.h"
#import "UIColor+Hex.h"
#import "SuccessViewController.h"
#import "Language.h"
#import "VThemeLabel.h"
#import "UIViewController+Transaction.h"
#import "UIViewController+Alert.h"

#import "NSString+Asterisk.h"


@interface TokenOperateViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic) NSInteger type;
@property (weak, nonatomic) IBOutlet VThemeTextField *inputTotal;
@property (weak, nonatomic) IBOutlet VThemeTextView *inputDesc;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheck;
@property (weak, nonatomic) IBOutlet UILabel *labelFee;
@property (weak, nonatomic) IBOutlet UILabel *labelAvailabelBalance;
@property (weak, nonatomic) IBOutlet VThemeButton *buttonContinue;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) UIView *progressTopView;
@property (strong, nonatomic) UILabel *progressTitle;
@property (nonatomic) BOOL checked;
@property (strong, nonatomic) Account *account;
@property (nonatomic, assign) int unitCurrent;
@property (nonatomic, assign) int unitTotal;
@property (weak, nonatomic) IBOutlet UIView *tokenViewWrap;
@property (weak, nonatomic) IBOutlet UIView *descWrapView;
@property (weak, nonatomic) IBOutlet UIView *unityWrapView;
@property (weak, nonatomic) IBOutlet UIView *checkBoxWrapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feeWrapViewTop;
@property (weak, nonatomic) IBOutlet UIView *feeWrapView;
@property (weak, nonatomic) IBOutlet VThemeLabel *amountNoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *amountNoteButton;
@property (weak, nonatomic) IBOutlet UIImageView *amountNoteIcon;
@end

@implementation TokenOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (instancetype)initWithAccount:(Account *)account {
    return [self initWithAccount:account type:TokenOperatePageTypeCreate];
}

- (instancetype)initWithAccount:(Account *)account type:(NSInteger)type {
    if (self = [super init]) {
        self.account = account;
        self.type = type;
    }
    return self;
}

- (void)initView {
    if (self.type == TokenOperatePageTypeCreate) {
        self.amountNoteLabel.text = VLocalize(@"token.operate.note.total");
        [self.navigationItem setTitle:VLocalize(@"token.create_token")];
        [self setProgress:8 total:16];
    }else if (self.type == TokenOperatePageTypeIssue) {
        self.amountNoteLabel.text = VLocalize(@"token.operate.note.issue");
        [self.navigationItem setTitle:VLocalize(@"token.issue_token")];
        self.descWrapView.hidden = YES;
        self.unityWrapView.hidden = YES;
        self.checkBoxWrapView.hidden = YES;
        self.feeWrapViewTop.constant = -(self.feeWrapView.frame.origin.y - self.descWrapView.frame.origin.y);
        [self.view layoutIfNeeded];
        NSLog(@"%f", self.feeWrapView.frame.origin.y);
    }else if (self.type == TokenOperatePageTypeBurn) {
        self.amountNoteLabel.text = VLocalize(@"token.operate.note.burn");
        [self.navigationItem setTitle:VLocalize(@"token.burn_token")];
        self.descWrapView.hidden = YES;
        self.unityWrapView.hidden = YES;
        self.checkBoxWrapView.hidden = YES;
        self.feeWrapViewTop.constant = 0;
        self.feeWrapViewTop.constant = CGRectGetHeight(self.tokenViewWrap.bounds);
    }else {
        
    }
}

- (void)setProgress:(CGFloat)current total:(CGFloat)total {
    if (current > total) {
       current = total;
    }
    if (current < 0) {
        current = 0;
    }
    self.unitTotal = total;
    self.unitCurrent = current;
    CGFloat width = (self.unitCurrent * self.progressView.frame.size.width) / self.unitTotal;
    NSLog(@"%f %f", width, self.progressView.frame.size.width);
    if (self.progressTopView == nil) {
        self.progressTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.progressTopView.backgroundColor = [UIColor colorWithHexStr:@"FFC969"];
        [self.progressView addSubview:self.progressTopView];
        self.progressTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.progressTitle.textColor = [UIColor whiteColor];
        self.progressTitle.textAlignment = NSTextAlignmentCenter;
        self.progressTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
        [self.progressView addSubview:self.progressTitle];
    }
    CGRect frame = CGRectMake(0, 0, width, self.progressView.frame.size.height);
    frame.size.width = width;
    [UIView animateWithDuration:0.2 animations:^{
        self.progressTitle.text = [NSString stringWithFormat:@"%.0f", current];
        self.progressTopView.frame = frame;
        self.progressTitle.frame = frame;
    }];
}

- (IBAction)ClickTotalTokenNote:(id)sender {
    
}

- (IBAction)ClickMinus:(id)sender {
    [self setProgress:(self.unitCurrent-1) total:self.unitTotal];
}

- (IBAction)ClickPlus:(id)sender {
    [self setProgress:(self.unitCurrent+1) total:self.unitTotal];
}

- (IBAction)ClickCheck:(id)sender {
    if(self.checked) {
        self.checked = NO;
    }else {
        self.checked = YES;
    }
    [self.buttonCheck setHighlighted: self.checked];
}

- (IBAction)ClickContinue:(id)sender {
    VsysTransaction *tx;
    switch (self.type) {
        case TokenOperatePageTypeCreate:
            break;
        case TokenOperatePageTypeIssue:
            break;
        case TokenOperatePageTypeBurn:
            break;
    }
    if (!tx) {
        return;
    }
    [self beginTransactionConfirmWithTransaction:tx account:self.account];
}

@end
