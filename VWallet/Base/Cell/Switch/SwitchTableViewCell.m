//
//  SwitchTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) CellItem *item;
@end

@implementation SwitchTableViewCell

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
    self.iconImageView.image = [UIImage imageNamed:item.icon];
    self.titleLabel.text = item.title;
    self.descLabel.text = item.desc;
    self.switcher.on = [item.dict[@"switcher"] boolValue];
    UIImage *img = [UIImage imageNamed:item.icon];
    if (!img) {
        self.iconImageView.hidden = YES;
    }
    if ([item.desc isEqualToString: @""]) {
        self.descLabel.hidden = YES;
    } else {
        self.descLabel.hidden = NO;
    }
    self.item = item;
}

- (IBAction)switchClick:(UISwitch *)sender {
    NSMutableDictionary *dict = [self.item.dict mutableCopy];
    dict[@"switcher"] = @(sender.isOn);
    self.item.dict = [dict copy];
    [self.delegate cellActionWithType:SwitchStateChange item:self.item];
}

@end
