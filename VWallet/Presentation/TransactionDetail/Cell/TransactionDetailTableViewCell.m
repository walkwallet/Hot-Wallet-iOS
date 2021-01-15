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

@interface TransactionDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagCopyImageView;

@end

@implementation TransactionDetailTableViewCell

- (void)setShowInfo:(NSDictionary *)showInfo {
    _showInfo = showInfo;
    _titleLabel.text = showInfo[@"title"];
    if ([VLocalize(@"transaction.detail.tx.id") isEqual:showInfo[@"title"]]) {
        _titleLabel.textColor = [UIColor colorWithHex:0x5E5CB7];
    }else{
        _titleLabel.textColor = [UIColor colorWithHex:0x939399];
    }
    _valueLabel.text = showInfo[@"value"];
    _tagCopyImageView.hidden = [showInfo[@"hiddenCopy"] boolValue];
}

- (void)layoutSubviews{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickId)];
    [self.titleLabel addGestureRecognizer:tap];
    self.titleLabel.userInteractionEnabled = true;
}

- (void)clickId{
    NSString *urlStr = [@"https://explorer.v.systems/transactions/" stringByAppendingString:self.showInfo[@"value"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
    }];
   
    
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http:www.baidu.com"]];
}

@end
