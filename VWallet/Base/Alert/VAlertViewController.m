//
//  VAlertViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "VAlertViewController.h"

@interface VAlertViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (copy, nonatomic, nullable) void(^cancelCallback)(void);
@property (copy, nonatomic, nullable) void(^confirmCallback)(void);
@property (nonatomic, copy) void(^configureBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewCenterYConstraint;

@end

@implementation VAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.configureBlock();

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear) name:UIKeyboardWillShowNotification object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear {
    [UIView animateWithDuration:0.5f animations:^{
        self.contentViewCenterYConstraint.constant = -50.f;
    }];
}

- (instancetype)initWithIconName:(NSString *)iconName
                           title:(NSString *)title
                     secondTitle:(NSString *)secondTitle
                     contentView:(void(^)(UIStackView *))configureView
                     cancelTitle:(NSString *)cancelTitle
                    confirmTitle:(NSString *)confirmTitle
                          cancel:(void(^)(void))cancel
                         confirm:(void(^)(void))confirm {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        __weak typeof(self) weakself = self;
        self.configureBlock = ^{
            if (iconName && ![iconName isEqualToString:@""]) {
                weakself.iconImageView.image = [UIImage imageNamed:iconName];
            } else {
                weakself.iconImageView.hidden = YES;
            }
            weakself.titleLabel.text = title;
            if (!secondTitle || [secondTitle isEqualToString:@""]) {
                weakself.secondTitleLabel.hidden = YES;
                weakself.titleLabel.font = [UIFont systemFontOfSize:18.f];
            } else {
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                style.lineSpacing = 5.f;
                
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:secondTitle attributes:@{
                                                                                                              NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                                              NSParagraphStyleAttributeName: style
                                                                                                              }];
                weakself.secondTitleLabel.attributedText = str;
//                weakself.secondTitleLabel.text = secondTitle;
//                [weakself.secondTitleLabel sizeToFit];
            }
            if (configureView) {
                configureView(weakself.contentView);
            } else if (weakself.iconImageView.hidden) {
                weakself.contentView.hidden = YES;
            }
            if (cancelTitle.length) {
                [weakself.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            } else {
                weakself.cancelBtn.hidden = YES;
            }
            if (confirmTitle.length) {
                [weakself.confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
            } else {
                weakself.confirmBtn.hidden = YES;
            }
            weakself.cancelCallback = cancel;
            weakself.confirmCallback = confirm;
        };
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title secondTitle:(NSString *)secondTitle contentView:(void(^)(UIStackView *))configureView cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancel:(void(^)(void))cancel confirm:(void(^)(void))confirm {
    return [self initWithIconName:@"ico_note_tip" title:title secondTitle:secondTitle contentView:configureView cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:cancel confirm:confirm];
}

- (IBAction)cancelBtnClick:(id)sender {
    if (!self.notDismiss) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.cancelCallback) {
        self.cancelCallback();
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    if (!self.notDismiss) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.confirmCallback) {
        self.confirmCallback();
    }
}

@end
