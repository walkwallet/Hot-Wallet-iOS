//
// TransactionRecordHeadSegmentedView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionRecordHeadSegmentedView : UIView

@property (nonatomic, strong) void(^selectedBlock)(NSInteger oldIndex, NSInteger newIndex);

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
