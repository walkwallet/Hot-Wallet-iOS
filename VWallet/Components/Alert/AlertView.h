#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertShowType) {
    AlertShowTypeFade,
    AlertShowTypeSladeUp,
};

@interface AlertView : UIView

@property(nonatomic) AlertShowType showType;

@property(nonatomic) BOOL clickOutsideHidden;

@property(nonatomic, strong) UIView *contentWrap;

- (void)show;

- (void)dismiss;

- (BOOL)showing;

@end
