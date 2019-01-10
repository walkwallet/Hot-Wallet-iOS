//
// NavigationController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VNavigationController : UINavigationController

/** 0.white 1.gray 2.theme orange/blue */
@property (nonatomic, assign) IBInspectable int colorStyle;

@end

NS_ASSUME_NONNULL_END
