//
// ChooseNetworkViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ChooseNetworkViewController.h"
#import "Language.h"
#import "WalletMgr.h"
#import "VAlertViewController.h"
#import "VColor.h"
#import "UIViewController+Alert.h"

@interface ChooseNetworkViewController ()

@property (nonatomic, copy) void(^next)(void);
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeNetworkBtn;
@property (nonatomic, assign) BOOL isTestnet;
@property (weak, nonatomic) IBOutlet UIView *networkView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ChooseNetworkViewController

- (void)setNextBlock:(void(^)(void))next {
    _next = next;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.title = VLocalize(@"nav.title.network.choose");
    self.descLabel.text = VLocalize(@"network.choose.detail");
    self.view.backgroundColor = VColor.rootViewBgColor;
    [self.nextBtn setTitle:VLocalize(@"next") forState:UIControlStateNormal];
    [self updateChangeNetwork];
}

- (IBAction)changeNetworkBtnClick:(id)sender {
    if (!self.isTestnet) {
        VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.network.change.title") secondTitle:@"" contentView:^(UIStackView * _Nonnull view) {
            
        } cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"confirm") cancel:^{
            
        } confirm:^{
            self.isTestnet = !self.isTestnet;
            [self updateChangeNetwork];
        }];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        self.isTestnet = !self.isTestnet;
        [self updateChangeNetwork];
    }
}

- (void)updateChangeNetwork {
    CATransition *ts = [CATransition animation];
    ts.type = @"oglFlip";
    ts.subtype = self.isTestnet ? kCATransitionFromTop : kCATransitionFromBottom;
    ts.duration = 0.3f;
    [self.networkView.layer addAnimation:ts forKey:@"transtion"];
    NSString *title = @"";
    if (self.isTestnet) {
        title = VLocalize(@"tip.network.choose.btn1.title");
        self.titleLabel.text = VLocalize(@"network.choose.cell2.title");
        self.secondTitleLabel.text = VLocalize(@"network.choose.cell2.detail");
        [self.iconImageView setTintColor:VColor.textColor];
//        self.iconImageView.image = [UIImage imageNamed:@""];
    } else {
        title = VLocalize(@"tip.network.choose.btn2.title");
        self.titleLabel.text = VLocalize(@"network.choose.cell1.title");
        self.secondTitleLabel.text = VLocalize(@"network.choose.cell1.detail");
        [self.iconImageView setTintColor:VColor.themeColor];
//        self.iconImageView.image = [UIImage imageNamed:@""];
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                            NSForegroundColorAttributeName: VColor.textSecondColor
                                                                                            
                                                                                            }];
    [self.changeNetworkBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (IBAction)nextBtnClick:(id)sender {
    WalletMgr.shareInstance.network = !self.isTestnet ? VsysNetworkMainnet : VsysNetworkTestnet;
    if (self.next) {
        self.next();
    }
}
@end
