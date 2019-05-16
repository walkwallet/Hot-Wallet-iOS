//
// TransactionTableHeadView.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionTableHeadView.h"
#import <Masonry.h>
#import "VColor.h"

@implementation TransactionTableHeadView

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        label.textColor = VColor.textColor;
        label.text = title;
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.trailing.mas_equalTo(-20);
            make.centerY.mas_equalTo(0);
        }];
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = VColor.separatorColor;
        [self addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

@end
