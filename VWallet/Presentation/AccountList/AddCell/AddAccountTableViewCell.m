//
// AddAccountTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "AddAccountTableViewCell.h"
#import "Language.h"
#import "VColor.h"

@interface AddAccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation AddAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = UIView.new;
}

- (void)setAccountType:(AccountType)accountType {
    _accountType = accountType;
    switch (_accountType) {
        case AccountTypeWallet:
            self.iconImgView.tintColor = VColor.orangeColor;
            self.titleLabel.text = VLocalize(@"account.list.add.title");
            self.descLabel.text = VLocalize(@"account.list.add.desc");
            break;
        case AccountTypeMonitor:
            self.iconImgView.tintColor = VColor.blueColor;
            self.titleLabel.text = VLocalize(@"account.list.monitor.add.title");
            self.descLabel.text = VLocalize(@"account.list.monitor.add.desc");
            break;
    }
}

@end
