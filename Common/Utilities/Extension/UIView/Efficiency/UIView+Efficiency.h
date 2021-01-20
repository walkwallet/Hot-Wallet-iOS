//
//  UIView+Frame.h
//  DaLong-iOS
//
//  Created by joy on 2019/6/19.
//  Copyright © 2019 togreat tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface UIView(Efficiency)

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat right;

- (void)setBackgroundImage: (NSString *) imageName;
    
+ (BOOL)isIphoneX;

+ (CGFloat)topBarHeight;

+ (CGFloat)bottomBarHeight;

// iOS 13.0 之后，present vc 顶部距离
+ (CGFloat)topMargin;

// iOS 13.0 之后 present 内部 view 距离顶部的距离
+ (CGFloat)topPadding;

// 屏幕适配系数
+ (CGFloat)sFactor;

+ (BOOL)darkMode;

@end
