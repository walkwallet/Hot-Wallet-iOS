//
//  UITextView+Placeholder.m
//  Wallet
//
//  All rights reserved.
//

#import "UITextView+Placeholder.h"
#import <objc/runtime.h>
#import <Masonry.h>
#import "VColor.h"

@implementation UITextView (Placeholder)

- (UILabel *)placeholderLabel {
    return objc_getAssociatedObject(self, @selector(placeholderLabel));
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, @selector(placeholderLabel), placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (!self.superview) return;
    if (!self.delegate) self.delegate = self;
    UILabel *placeholderLabel = self.placeholderLabel;
    if (!placeholderLabel) {
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = VColor.placeholderColor;
        placeholderLabel.font = self.font?:[UIFont systemFontOfSize:UIFont.systemFontSize];
        placeholderLabel.numberOfLines = 0;
        CGFloat offsetV = self.font.pointSize / 2;
        [self.superview insertSubview:placeholderLabel belowSubview:self];
        __weak typeof(self) weakSelf = self;
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top).mas_offset(offsetV);
            make.leading.mas_equalTo(weakSelf.mas_leading).mas_offset(5);
            make.bottom.mas_lessThanOrEqualTo(weakSelf.mas_bottom).mas_offset(-offsetV);
            make.trailing.mas_equalTo(weakSelf.mas_trailing).mas_offset(-5);
        }];
        self.placeholderLabel = placeholderLabel;
    }
    placeholderLabel.text = placeholder;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)updatePlaceholderState {
    UILabel *placeholderLabel = self.placeholderLabel;
    if (placeholderLabel) {
        placeholderLabel.hidden = self.text.length > 0;
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updatePlaceholderState];
}

@end
