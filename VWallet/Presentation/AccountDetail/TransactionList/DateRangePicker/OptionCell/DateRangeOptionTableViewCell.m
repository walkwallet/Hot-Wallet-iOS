//
// DateRangeOptionTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "DateRangeOptionTableViewCell.h"
#import "VColor.h"

@interface DateRangeOptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@end

@implementation DateRangeOptionTableViewCell

- (void)setShowInfo:(NSDictionary *)showInfo {
    self.titleLabel.text = showInfo[@"title"];
    self.selectImgView.hidden = ![showInfo[@"selected"] boolValue];
    self.selectImgView.tintColor = VColor.themeColor;
    self.titleLabel.textColor = self.selectImgView.hidden ? VColor.textColor : VColor.themeColor;
    self.titleLabel.font = self.selectImgView.hidden ? [UIFont systemFontOfSize:16] : [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
}

@end
