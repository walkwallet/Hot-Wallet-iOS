//
// DateRangeView.m
//  Wallet
//
//  All rights reserved.
//

#import "DateRangeView.h"
#import "VColor.h"
#import "Language.h"
#import "NSDate+FormatString.h"

@interface DateRangeView ()

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation DateRangeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = VColor.themeColor;
}

- (void)setDateRangeType:(DateRangeType)rangType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp {
    if (rangType < DateRangeTypeNone || rangType > DateRangeTypeCustom) {
        rangType = DateRangeTypeNone;
    }
    self.rangeType = rangType;
    if (self.rangeType == DateRangeTypeCustom) {
        self.startTimestamp = startTimestamp;
        self.endTimestamp = endTimestamp<=0 ? NSDate.date.timeIntervalSince1970 : endTimestamp;
    } else {
        self.startTimestamp = 0;
        self.endTimestamp = 0;
    }
    [self updateShowInfo];
}

- (void)updateShowInfo {
    if (self.rangeType > DateRangeTypeNone && self.rangeType < DateRangeTypeCustom) {
        NSString *rangTypeStrKey = [NSString stringWithFormat:@"date.range.type.%d", (int)self.rangeType];
        self.titleLabel.text = VLocalize(rangTypeStrKey);
    } else if (self.rangeType == DateRangeTypeCustom) {
        NSString *endDateStr = [NSDate dateWithTimeIntervalSince1970:self.endTimestamp].dateString;
        if (self.startTimestamp <= 0) {
            self.titleLabel.text = [NSString stringWithFormat:VLocalize(@"data.range.before.xx"), endDateStr];
        } else {
            NSString *startDateStr = [NSDate dateWithTimeIntervalSince1970:self.startTimestamp].dateString;
            self.titleLabel.text = [NSString stringWithFormat:@"%@ - %@", startDateStr, endDateStr];
        }
    } else {
        self.titleLabel.text = @"";
    }
}

@end
