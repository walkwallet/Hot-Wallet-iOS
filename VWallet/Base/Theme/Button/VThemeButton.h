//
//  VThemeButton.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VThemeButton : UIButton

@property (nonatomic, assign) IBInspectable BOOL secondTheme;

@property (nonatomic, assign) IBInspectable BOOL submit;

/** only border without background color */
@property (nonatomic, assign) IBInspectable BOOL hollow;

@end

NS_ASSUME_NONNULL_END
