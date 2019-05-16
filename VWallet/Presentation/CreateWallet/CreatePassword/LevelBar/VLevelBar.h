//
// LevelBar.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface VLevelBar : UIView

@property (nonatomic, assign) IBInspectable NSInteger maxLevel;

@property (nonatomic, assign) IBInspectable NSInteger level;

@property (nonatomic, copy) IBInspectable UIColor *levelColor;

@property (nonatomic, assign)IBInspectable CGFloat segmentSpecing;

- (void)updateLevelWithPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
