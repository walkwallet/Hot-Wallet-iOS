//
//  TokenTableViewCell.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenTableViewCell.h"
#import "Token.h"

@interface TokenTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *wrapView;
@property (weak, nonatomic) IBOutlet UIImageView *TokenLogo;
@property (weak, nonatomic) IBOutlet UILabel *TokenName;
@property (weak, nonatomic) IBOutlet UILabel *TokenBalance;
@end

@implementation TokenTableViewCell

- (void)setToken:(Token *)token {
    _token = token;
    self.wrapView.layer.masksToBounds = YES;
    self.wrapView.layer.cornerRadius = 4;
    self.TokenLogo.layer.cornerRadius = 16;
    [self.TokenName setText:token.name];
    [self.TokenBalance setText:[NSString stringWithFormat:@"%.2f", token.balance]];
}

@end
