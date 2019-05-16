//
// DateRangeTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "DateRangeTableViewCell.h"
#import "VColor.h"
#import "NSDate+FormatString.h"
#import "Language.h"

@interface DateRangeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;

@end

@implementation DateRangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.startDateBtn setTitleColor:VColor.textColor forState:UIControlStateNormal];
    [self.endDateBtn setTitleColor:VColor.textColor forState:UIControlStateNormal];
    self.startDateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.endDateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setStartTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp {
    NSString *dateDesc = Language.shareInstance.languageType == LanguageTypeEN ? @"MMM DD, YYYY" : @"YYYY-MM-DD";
    if (startTimestamp <= 0) {
        [self.startDateBtn setTitle:dateDesc forState:UIControlStateNormal];
    } else {
        [self.startDateBtn setTitle:[NSDate dateWithTimeIntervalSince1970:startTimestamp].dateString forState:UIControlStateNormal];
    }
    if (endTimestamp <= 0) {
        [self.endDateBtn setTitle:dateDesc forState:UIControlStateNormal];
    } else {
        [self.endDateBtn setTitle:[NSDate dateWithTimeIntervalSince1970:endTimestamp].dateString forState:UIControlStateNormal];
    }
}

- (IBAction)dateBtnClick:(UIButton *)sender {
    if (sender.tag == 0 && self.startDateBlock) {
        self.startDateBlock(sender);
    } else if (sender.tag == 1 && self.endDateBlock) {
        self.endDateBlock(sender);
    }
}

@end
