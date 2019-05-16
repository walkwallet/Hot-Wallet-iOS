//
// DateRangePickerViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateRangeType.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateRangePickerViewController : UIViewController

- (instancetype)initWithRangeType:(DateRangeType)rangeType
                   startTimestamp:(NSTimeInterval)startTimestamp
                     endTimestamp:(NSTimeInterval)endTimestamp
                           result:(void(^)(DateRangeType rangType, NSTimeInterval startTimestamp, NSTimeInterval endTimestamp))result;

@end

NS_ASSUME_NONNULL_END
