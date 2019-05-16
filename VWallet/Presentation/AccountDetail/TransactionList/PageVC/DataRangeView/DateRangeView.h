//
// DateRangeView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateRangeType.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateRangeView : UIView

@property (nonatomic, assign) DateRangeType rangeType;

@property (nonatomic, assign) NSTimeInterval startTimestamp;
@property (nonatomic, assign) NSTimeInterval endTimestamp;

- (void)setDateRangeType:(DateRangeType)rangType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp;

@end

NS_ASSUME_NONNULL_END
