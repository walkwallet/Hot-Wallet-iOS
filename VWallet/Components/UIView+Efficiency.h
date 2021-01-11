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

+(CGFloat)topBarHeight;

+(CGFloat)bottomBarHeight;

+(BOOL)isIphoneX;

@end
