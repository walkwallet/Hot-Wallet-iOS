//
//  AlertViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AlertViewController.h"
#import "VColor.h"

@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (copy, nonatomic) void(^cancelBlock)(UIViewController *vc);
@property (copy, nonatomic) void(^confirmBlock)(UIViewController *);
@property (nonatomic, copy) void(^configureBlock)(void);
@property (assign, nonatomic) BOOL backEnable;
@property (weak, nonatomic) IBOutlet UIView *confirmBtnContainerView;
@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.configureBlock();
    [self setupRoundedRect];
}

- (void)setupRoundedRect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 1000) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.mainView.layer.mask = maskLayer;
}

- (instancetype)initWithTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle configureContent:(void(^)(UIViewController *vc, UIStackView *parentView))configureBlock cancel:(void(^)(UIViewController *vc))cancel confirm:(void(^)(UIViewController *vc))confirm back:(BOOL)backEnable {
    if (self = [super init]) {
        self.cancelBlock = cancel;
        self.confirmBlock = confirm;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.backEnable = backEnable;
        __weak typeof(self) weakself = self;
        self.configureBlock = ^{
            if (backEnable) {
                [weakself.leftBtn setImage:[UIImage imageNamed:@"ico_navi_back"] forState:UIControlStateNormal];
            }
            weakself.titleLabel.text = title;
            if (!configureBlock) {

            } else {
                configureBlock(weakself, weakself.contentView);
            }
            [weakself.confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
            if ([confirmTitle isEqualToString:@""]) {
                weakself.confirmBtnContainerView.hidden = YES;
            }
        };

    }
    return self;
}

- (IBAction)cancelBtnClick:(id)sender {
    if (self.autoDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
    
}


- (IBAction)confirmBtnClick:(id)sender {
    if (self.autoDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.confirmBlock) {
        self.confirmBlock(self);
    }
}

@end
