#import "CertifiedTokenTableViewCell.h"
#import "TokenMgr.h"
#import "Language.h"
#import "UIColor+Hex.h"
#import "VColor.h"
#import "NSString+Decimal.h"
#import <SDWebImage/SDWebImage.h>
#import "ServerConfig.h"
#import "VsysToken.h"

@implementation CertifiedTokenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addButton.layer.cornerRadius = 4;
    self.addButton.layer.borderWidth = 1;
    self.addButton.layer.borderColor = [UIColor colorWithHex:0xEFEFF2].CGColor;
    [self.addButton setTitle:VLocalize(@"token.add.added") forState:UIControlStateDisabled];
    [self.addButton setTitle:VLocalize(@"add") forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"ico_added_small"] forState:UIControlStateDisabled];
    [self.addButton setImage:[UIImage imageNamed:@"ico_add_token"] forState:UIControlStateNormal];
    [self.addButton setTintColor:[VColor orangeColor]];
    self.addButton.titleEdgeInsets = UIEdgeInsetsMake(6, 4, 6, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setToken:(VsysToken *)token {
    _token = token;
    if ([NSString isNilOrEmpty:token.icon]) {
        self.logoView.image = [UIImage imageNamed:@"ico_token_logo"];
        
    }else {
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ServerConfig.ExplorerHost, token.icon]] placeholderImage:[UIImage imageNamed:@"ico_token_logo"]];
    }
    // TODO logo hard-code
    self.logoView.layer.masksToBounds = YES;
    self.nameLabel.text = token.name;
    
    if (token.watched) {
        self.addButton.enabled = NO;
        [self.addButton setTintColor:[UIColor lightGrayColor]];
    }else {
        self.addButton.enabled = YES;
        [self.addButton setTintColor:[VColor orangeColor]];
    }
}

@end
