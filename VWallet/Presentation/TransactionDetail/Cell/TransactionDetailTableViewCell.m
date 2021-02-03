//
// TransactionDetailTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionDetailTableViewCell.h"
#import "Language.h"
#import "UIColor+Hex.h"
#import "VColor.h"
#import "ServerConfig.h"

@interface TransactionDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagCopyImageView;

@end

@implementation TransactionDetailTableViewCell

- (void)setShowInfo:(NSDictionary *)showInfo {
    _showInfo = showInfo;
    _titleLabel.text = showInfo[@"title"];
    _valueLabel.text = showInfo[@"value"];
    if ([VLocalize(@"transaction.detail.tx.id") isEqual:showInfo[@"title"]]) {
        _valueLabel.textColor = [UIColor colorWithHex:0x5E5CB7];
    }else{
        _valueLabel.textColor = [UIColor colorWithHex:0x939399];
    }
    
    _tagCopyImageView.hidden = [showInfo[@"hiddenCopy"] boolValue];
}

- (void)layoutSubviews{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickId)];
    if ([VLocalize(@"transaction.detail.tx.id") isEqual:self.showInfo[@"title"]]) {
        [self.valueLabel addGestureRecognizer:tap];
        self.valueLabel.userInteractionEnabled = true;
    }else{
        self.valueLabel.userInteractionEnabled = false;
    }
    
    if (![self.showInfo[@"hiddenCopy"] boolValue]) {
        UITapGestureRecognizer *copyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCopy)];
        [self.tagCopyImageView addGestureRecognizer:copyTap];
        self.tagCopyImageView.userInteractionEnabled = true;
    }else{
        self.tagCopyImageView.userInteractionEnabled = false;
    }
    
}

- (void)clickId{
    
    NSString *urlStr = [ServerConfig.ExplorerHost stringByAppendingFormat:@"/transactions/%@", self.showInfo[@"value"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
    }];
}

- (void)clickCopy {
    UIPasteboard.generalPasteboard.string = self.showInfo[@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickCopy" object:nil userInfo:nil];
}

@end
