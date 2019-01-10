//
// AccountDetailHeadView.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountDetailHeadView.h"
#import "VColor.h"
#import "Language.h"
#import "Account.h"
#import "NSString+Decimal.h"

@interface AccountDetailHeadView ()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel1;
@property (nonatomic, weak) IBOutlet UILabel *descLabel2;
@property (nonatomic, weak) IBOutlet UILabel *descLabel3;
@property (nonatomic, weak) IBOutlet UILabel *sendBtnTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *receiveBtnTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *leaseBtnTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *recordsBtnTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *availableBalanceeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *leasedOutLabel;
@property (nonatomic, weak) IBOutlet UILabel *leasedInLabel;

@end

@implementation AccountDetailHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.descLabel.text = VLocalize(@"account.detail.available.balance");
    self.descLabel1.text = VLocalize(@"account.detail.total.balance");
    self.descLabel2.text = VLocalize(@"account.detail.leased.out");
    self.descLabel3.text = VLocalize(@"account.detail.leased.in");
    self.sendBtnTitleLabel.text = VLocalize(@"account.detail.send");
    self.receiveBtnTitleLabel.text = VLocalize(@"account.detail.receive");
    self.leaseBtnTitleLabel.text = VLocalize(@"account.detail.lease");
    self.recordsBtnTitleLabel.text = VLocalize(@"account.detail.records");
}

- (void)setAccount:(Account *)account {
    _account = account;
    [self setAccountType:_account.accountType];
    NSString *availableBalanceStr = [NSString stringWithDecimal:(_account.availableBalance * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.availableBalanceeLabel.text = [NSString stringWithFormat:@"%@ VSYS", availableBalanceStr];
    NSString *totalBalanceStr = [NSString stringWithDecimal:(_account.totalBalance * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.totalBalanceLabel.text = [NSString stringWithFormat:@"%@ VSYS", totalBalanceStr];
    NSString *leasedOutStr = [NSString stringWithDecimal:(_account.leasedOut * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.leasedOutLabel.text = [NSString stringWithFormat:@"%@ VSYS", leasedOutStr];
    NSString *leasedInStr = [NSString stringWithDecimal:(_account.leasedIn * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    self.leasedInLabel.text = [NSString stringWithFormat:@"%@ VSYS", leasedInStr];
}

- (void)setAccountType:(AccountType)accountType {
    if (self.bgView.tag != 1) {
        self.bgView.tag = 1;
        CGFloat height = 200;
        for (int i = 1; i <= 3; i++) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.locations = @[@0, @1];
            gradientLayer.startPoint = i == 1 ? CGPointMake(0, 0) : CGPointMake(0, 0);
            gradientLayer.endPoint = i == 1 ? CGPointMake(1, 1) : CGPointMake(1, 0);
            CGFloat y = CGRectGetHeight(self.bgView.bounds) - i * height;
            gradientLayer.frame = CGRectMake(0, y, CGRectGetWidth(UIScreen.mainScreen.bounds), height);
            switch (accountType) {
                case AccountTypeWallet:
                    gradientLayer.colors = @[(__bridge id)VColor.lightOrangeColor.CGColor, (i ==1 ? (__bridge id)VColor.orangeColor.CGColor : (__bridge id)VColor.mediumOrangeColor.CGColor)];
                    break;
                case AccountTypeMonitor:
                    gradientLayer.colors = @[(__bridge id)VColor.lightBlueColor.CGColor, (i ==1 ? (__bridge id)VColor.blueColor.CGColor : (__bridge id)VColor.mediumBlueColor.CGColor)];
                    break;
            }
            [self.bgView.layer insertSublayer:gradientLayer atIndex:0];
        }
    }
}

@end
