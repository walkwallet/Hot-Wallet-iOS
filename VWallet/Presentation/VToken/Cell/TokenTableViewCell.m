//
//  TokenTableViewCell.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "TokenTableViewCell.h"
#import "Token.h"
#import "NSString+Decimal.h"
#import "NSString+Asterisk.h"
#import <SDWebImage/SDWebImage.h>
#import "ServerConfig.h"
@import Vsys;

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
    if ([NSString isNilOrEmpty:token.name]) {
        if (token.tokenId.length > 12) {
            [self.TokenName setText:[token.tokenId explicitCount:12 maxAsteriskCount:6]];
        }
    }else {
        [self.TokenName setText:token.name];
    }
    NSDecimalNumber *tokenAmount = [[NSDecimalNumber alloc] initWithLongLong:token.balance];
    NSDecimalNumber *unityDecimal = [[NSDecimalNumber alloc] initWithLongLong:token.unity];
    NSString *balanceStr = [NSString stringWithDecimal:[tokenAmount decimalNumberByDividingBy:unityDecimal] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES];
    [self.TokenBalance setText:balanceStr];
    if ([NSString isNilOrEmpty:token.icon]) {
        self.TokenLogo.image = [UIImage imageNamed:@"ico_token_logo"];
    }else {
        [self.TokenLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ServerConfig.ExplorerHost, token.icon]] placeholderImage:[UIImage imageNamed:@"ico_token_logo"]];
    }
}

@end
