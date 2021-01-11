#import "AlertDialog.h"

@interface AlertDialog()

@end

@implementation AlertDialog

- (instancetype)initWithDialogView:(UIView *)view {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.contentWrap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.contentWrap.layer.cornerRadius = 8;
        self.contentWrap.backgroundColor = [UIColor whiteColor];
        [self addSubview: self.contentWrap];
        
        [self.contentWrap addSubview:view];
        
        CGRect frame = CGRectMake((SCREEN_WIDTH - view.width) / 2, 0, view.width, view.height);
        self.contentWrap.frame = frame;
        self.contentWrap.top = (SCREEN_HEIGHT - self.contentWrap.height) / 2;
    }
    return self;
}

@end
