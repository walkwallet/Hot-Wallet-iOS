//
// AccountTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountTableViewCell.h"
#import "VColor.h"
#import "Language.h"
#import "NSString+Asterisk.h"
#import "NSString+Decimal.h"
#import "Account.h"
#import "ApiServer.h"

@interface AccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, weak) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = UIView.new;
    self.containerView.backgroundColor = UIColor.clearColor;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds) - 40, 133);
    gradientLayer.locations = @[@0, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.cornerRadius = 8;
    [self.containerView.layer insertSublayer:gradientLayer atIndex:0];
    _gradientLayer = gradientLayer;
    
    self.descLabel.text = VLocalize(@"account.list.total.balance");
}

- (void)setAccountType:(AccountType)accountType {
    if (_gradientLayer.colors) return;
    switch (accountType) {
        case AccountTypeWallet:
            _gradientLayer.colors = @[(__bridge id)VColor.lightOrangeColor.CGColor, (__bridge id)VColor.orangeColor.CGColor];
            break;
        case AccountTypeMonitor:
            _gradientLayer.colors = @[(__bridge id)VColor.lightBlueColor.CGColor, (__bridge id)VColor.blueColor.CGColor];
            break;
    }
}

- (void)setAccount:(Account *)account {
    _account = account;
    [self showAccountInfo];
    if (!_account.getedInfo) {
        _account.getedInfo = YES;
        __weak typeof(self) weakSelf = self;
        [ApiServer addressBalanceDetail:_account callback:^(BOOL isSuc, Account * _Nonnull account) {
            if (isSuc) {
                [weakSelf showAccountInfo];
            }
        }];
    }
}

- (void)showAccountInfo {
    [self setAccountType:_account.accountType];
    self.sortLabel.text = [NSString stringWithFormat:@"%02d", (int)_account.sort];
    self.valueLabel.text = [_account.originAccount.address explicitCount:12 maxAsteriskCount:6];
    NSString *totalBalanceStr = [NSString stringWithDecimal:(_account.totalBalance * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.valueLabel1.text = [NSString stringWithFormat:@"%@ VSYS", totalBalanceStr];
}

@end
