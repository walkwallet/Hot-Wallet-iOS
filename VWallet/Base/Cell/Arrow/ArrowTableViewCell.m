//
//  ArrowTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "ArrowTableViewCell.h"

@interface ArrowTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
@implementation ArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void)setupCellItem:(CellItem *)item {
    if (item.dict[@"no_arrow"]) {
        self.arrowImageView.hidden = [item.dict[@"no_arrow"] boolValue];
    }
    if (item.dict[@"descColor"]) {
        self.rightLabel.textColor = item.dict[@"descColor"];
    }
    if (item.dict[@"secondTitle"]) {
        self.leftSecondLabel.text = item.dict[@"secondTitle"];
    } else {
        self.leftSecondLabel.hidden = YES;
    }
    UIImage *img = [UIImage imageNamed:item.icon];
    if (!img) {
        self.iconImageView.hidden = YES;
    } else {
        self.iconImageView.image = [UIImage imageNamed:item.icon];
    }
    
    self.leftLabel.text = item.title;
    self.leftLabel.adjustsFontSizeToFitWidth = YES;
    self.rightLabel.text = item.desc;
}

@end
