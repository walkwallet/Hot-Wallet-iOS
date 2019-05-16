//
// DateRangeTableViewCell.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateRangeTableViewCell : UITableViewCell

- (void)setStartTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp;

@property (nonatomic, strong) void(^startDateBlock)(UIButton *btn);
@property (nonatomic, strong) void(^endDateBlock)(UIButton *btn);

@end

NS_ASSUME_NONNULL_END
