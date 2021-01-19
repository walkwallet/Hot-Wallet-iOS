//
//  MessageSignViewController.m
//  VWallet
//
//  Copyright © 2021 veetech. All rights reserved.
//

#import "MessageSignViewController.h"
#import "Account.h"
#import "Language.h"
#import <Masonry.h>
#import "VSeparatorLine.h"
#import "VColor.h"
#import "VThemeLabel.h"
#import "VThemeTextView.h"
#import "UITextView+Placeholder.h"
#import "UIViewController+Alert.h"
#import "Regex.h"

@interface MessageSignViewController() <UITextViewDelegate>

@property (nonatomic, weak) Account *account;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) VThemeTextView *inputTv;

@property (nonatomic, strong) VThemeLabel *resultLbl;

@property (nonatomic, strong) UIImageView *imageV;

@end


@implementation MessageSignViewController

- (instancetype)initWithAccount:(Account *)account {
    self.account = account;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = VLocalize(@"nav.title.message.sign");
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.scrollView.contentInset = UIEdgeInsetsMake(16, 0, 50, 0);
    
    UIView *contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollView);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.equalTo(@400);
    }];
    
    UILabel *inputTitleLbl = [[UILabel alloc] init];
    [contentView addSubview:inputTitleLbl];
    [inputTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
    }];
    inputTitleLbl.text = VLocalize(@"message.sign.input.title");
    
    self.inputTv = [[VThemeTextView alloc] init];
    [contentView addSubview:self.inputTv];
    [self.inputTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputTitleLbl.mas_bottom).offset(5);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@30);
    }];
    self.inputTv.textContainerInset = UIEdgeInsetsMake(10,0, 0, 0);
    self.inputTv.placeholder = VLocalize(@"message.sign.input.placeholder");
    self.inputTv.font = [UIFont systemFontOfSize:18];
    self.inputTv.delegate = self;
    
    VSeparatorLine *sepLine = [[VSeparatorLine alloc] init];
    [contentView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.equalTo(self.inputTv);
        make.top.equalTo(self.inputTv.mas_bottom).offset(5);
    }];
    
    UIButton *signBtn = [[UIButton alloc] init];
    [contentView addSubview:signBtn];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sepLine.mas_bottom).offset(16);
        make.left.equalTo(contentView).offset(16);
        make.right.equalTo(contentView).offset(-16);
        make.height.equalTo(@40);
    }];
    [signBtn setTitle:VLocalize(@"message.sign.btn.text") forState:UIControlStateNormal];
    [signBtn setUserInteractionEnabled: YES];
    [signBtn setTitleColor:[VColor themeColor] forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(clickSignBtn:) forControlEvents: UIControlEventTouchUpInside];
    signBtn.layer.masksToBounds = YES;
    signBtn.layer.cornerRadius = 10.0;
    signBtn.layer.borderWidth = 1.0;
    signBtn.layer.borderColor = VColor.themeColor.CGColor;
    
    self.resultLbl = [[VThemeLabel alloc] init];
    [contentView addSubview:self.resultLbl];
    [self.resultLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView).offset(-64);
        make.top.equalTo(signBtn.mas_bottom).offset(16);
    }];
    self.resultLbl.font = [UIFont systemFontOfSize:14];
    self.resultLbl.numberOfLines = 0;
    self.resultLbl.hidden = YES;
    
    
    UIView *imgWrap = [[UIView alloc] init];
    [contentView addSubview:imgWrap];
    [imgWrap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@48);
        make.centerY.equalTo(self.resultLbl);
        make.right.equalTo(contentView);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCopy)];
    [imgWrap addGestureRecognizer:tapGesture];
    imgWrap.userInteractionEnabled = YES;
    
    
    self.imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_copy_grey"]];
    [imgWrap addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@24);
        make.centerY.equalTo(self.resultLbl);
        make.right.equalTo(imgWrap);
    }];
    self.imageV.hidden = YES;
}
 
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.inputTv becomeFirstResponder];
}

- (void) clickSignBtn:(UIButton *)sender{
    if([self.inputTv.text isEqualToString:@""]) {
        [self remindWithMessage:VLocalize(@"message.sign.error.msg.empty")];
        return;
    }
    
    if(![Regex matchRegexStr:@"^[a-zA-Z0-9-/@#$%^&_+=() ]*$" string:self.inputTv.text]) {
        [self remindWithMessage:VLocalize(@"message.sign.error.msg.invalid")];
        return;
    }
    self.resultLbl.text = [self.account.originAccount signData: [self.inputTv.text dataUsingEncoding:NSUTF8StringEncoding]];
   
    self.resultLbl.hidden = self.resultLbl.text.length <= 0;
    self.imageV.hidden = self.resultLbl.isHidden;
    
    [self updateContentViewHeight ];
}

- (void) clickCopy {
    if(!self.imageV.isHidden) {
        UIPasteboard.generalPasteboard.string = self.resultLbl.text;
        [self remindWithMessage:VLocalize(@"tip.copy.success")];
    }
}

- (void) updateContentViewHeight {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *contentView = [[self.scrollView subviews] firstObject];
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.resultLbl.frame.origin.y + self.resultLbl.frame.size.height);
        }];
    });
    
}

- (void) textViewDidChange:(UITextView *)textView {
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textView.contentSize.height);
        [self updateContentViewHeight];
    }];
}

@end
