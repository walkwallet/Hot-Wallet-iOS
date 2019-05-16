//
// ResultViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ResultViewController.h"
#import "VColor.h"

@interface ResultViewController ()

@property (nonatomic, strong) ResultParameter *parameter;

@property (weak, nonatomic) IBOutlet UIView *naviBarBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarBgViewBottomLC;
@property (weak, nonatomic) IBOutlet UIImageView *resultTypeImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopLC;

@property (weak, nonatomic) IBOutlet UIButton *operateBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondOperateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondOperateBtnBottomLC;

@end

@implementation ResultViewController

- (instancetype)initWithResultParameter:(ResultParameter *)parameter {
    if (self = [super init]) {
        self.parameter = parameter;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    if (self.parameter.showNavigationBar) {
        self.naviBarBgViewBottomLC.constant = -44;
        self.naviBarBgView.backgroundColor = VColor.themeColor;
    } else {
        self.naviBarBgViewBottomLC.constant = 0;
        self.naviBarBgView.backgroundColor = UIColor.clearColor;
    }
    UIImage *img;
    if (self.parameter.imgResourceName.length) {
        img = [UIImage imageNamed:self.parameter.imgResourceName];
    }
    self.resultTypeImgView.image = img;
    if (self.parameter.attrTitle) {
        self.titleLabel.attributedText = self.parameter.attrTitle;
    } else {
        self.titleLabel.text = @"";
    }
    if (self.parameter.attrMessage) {
        self.messageLabel.attributedText = self.parameter.attrMessage;
    } else {
        self.messageLabel.text = @"";
    }
    self.messageLabelTopLC.constant = self.parameter.titleMessageSpecing;
    
    [self.operateBtn setTitle:self.parameter.operateBtnTitle forState:UIControlStateNormal];
    BOOL showSecond = self.parameter.secondOperateBtnTitle.length;
    self.secondOperateBtn.hidden = !showSecond;
    self.secondOperateBtnBottomLC.constant = showSecond ? 24.f : -48.f;
    [self.secondOperateBtn setTitle:self.parameter.secondOperateBtnTitle forState:UIControlStateNormal];
}

- (IBAction)operateBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0: {
            if (!self.parameter.explicitDismiss) {
                [self dismissViewControllerAnimated:(self.parameter.operateBlock==nil)completion:nil];
            }
            if (self.parameter.operateBlock) {
                self.parameter.operateBlock();
            }
        } break;
        case 1: {
            if (!self.parameter.explicitDismiss) {
                [self dismissViewControllerAnimated:(self.parameter.secondOperateBlock==nil) completion:nil];
            }
            if (self.parameter.secondOperateBlock) {
                self.parameter.secondOperateBlock();
            }
        } break;
    }
}

@end
