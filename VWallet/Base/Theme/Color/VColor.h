//
//  VColor.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
#import "SingletonMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface VColor : NSObject

SM_SINGLETON_INTERFACE(VColor)

@property (nonatomic, assign) BOOL coldTheme;

+ (UIColor *)themeColor;

#pragma mark - TabBar
+ (UIColor *)tabbarBgColor;
+ (UIColor *)tabbarTintColor;

#pragma mark - NavigationBar
+ (UIColor *)navigationGrayBgColor;
+ (UIColor *)navigationTintColor;


+ (UIColor *)rootViewBgColor;
+ (UIColor *)tableViewBgColor;

+ (UIColor *)disaleBgColor;

+ (UIColor *)textColor;

+ (UIColor *)textSecondColor;

+ (UIColor *)textSecondDeepenColor;

+ (UIColor *)placeholderColor;

+ (UIColor *)separatorColor;

+ (UIColor *)borderColor;

+ (UIColor *)shadowColor;

+ (UIColor *)orangeColor;

+ (UIColor *)mediumOrangeColor;

+ (UIColor *)lightOrangeColor;

+ (UIColor *)blueColor;

+ (UIColor *)mediumBlueColor;

+ (UIColor *)lightBlueColor;

+ (UIColor *)grayColor;

+ (UIColor *)redColor;

@end

NS_ASSUME_NONNULL_END
