//
// TransactionDetailTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionDetailTableViewCell.h"

@interface TransactionDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation TransactionDetailTableViewCell

- (void)setShowInfo:(NSDictionary *)showInfo {
    _showInfo = showInfo;
    _titleLabel.text = showInfo[@"title"];
    _valueLabel.text = showInfo[@"value"];
}

@end
