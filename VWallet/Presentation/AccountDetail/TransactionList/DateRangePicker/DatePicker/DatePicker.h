//
// DatePicker.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatePicker : UIViewController

- (instancetype)initWithMinTimestamp:(NSTimeInterval)minTimestamp
                        maxTimestamp:(NSTimeInterval)maxTimestamp
                    currentTimestamp:(NSTimeInterval)currentTimestamp
                              result:(void(^)(NSTimeInterval timestamp))result;

@end

NS_ASSUME_NONNULL_END
