//
//  WalletHeadSegmentedView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletHeadSegmentedView : UIView

- (instancetype)initWithSelectedBlock:(void(^)(NSInteger oldIndex, NSInteger newIndex))selectedBlock;

@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
