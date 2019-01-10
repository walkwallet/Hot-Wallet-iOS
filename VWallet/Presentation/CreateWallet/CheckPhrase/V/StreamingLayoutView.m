//
// StreamingLayoutView.m
//  Wallet
//
//  All rights reserved.
//

#import "StreamingLayoutView.h"
#import "VColor.h"

@interface StreamingLayoutView ()

@property (nonatomic, assign) CGFloat width;

@end

@implementation StreamingLayoutView

- (CGFloat)heightWithItemArray:(NSArray<NSString *> *)itemArray width:(CGFloat)width {
    _itemArray = itemArray;
    _width = width;
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    if (_itemArray.count) {
        CGFloat offsetX = _contentInsets.left;
        CGFloat offsetY = _contentInsets.top;
        NSMutableArray *lineItemBtns = [NSMutableArray array];
        for (int i = 0; i < _itemArray.count; i++) {
            NSString *text = _itemArray[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
            [btn setTitle:text forState:UIControlStateNormal];
            [btn setTitleColor:VColor.textSecondColor forState:UIControlStateSelected];
            [btn setTitleColor:(_selectable ? UIColor.whiteColor : VColor.textColor) forState:UIControlStateNormal];
            btn.layer.borderColor = VColor.borderColor.CGColor;
            [self setBtnStyle:btn];
            btn.layer.cornerRadius = 4.f;
            CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
            CGSize itemSize = CGSizeMake(textSize.width + 24.f, 36.f);
            btn.frame = CGRectMake(0, offsetY, itemSize.width, itemSize.height);
            if (_delegate) {
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            BOOL last = i == _itemArray.count - 1;
            BOOL lineFeed = offsetX + itemSize.width + _contentInsets.right > width;
            if (last && lineFeed) {
                offsetX = (width - offsetX - _contentInsets.right) / 2 + _contentInsets.left;
                [self addItemBtnArray:lineItemBtns offsetX:offsetX];
                offsetY += itemSize.height + 12.f;
                
                CGRect frame = btn.frame;
                frame.origin.x = (width - _contentInsets.left - _contentInsets.right - CGRectGetWidth(frame)) / 2 + _contentInsets.left;
                frame.origin.y = offsetY;
                btn.frame = frame;
                [self addSubview:btn];
                offsetY += itemSize.height + 12.f;
            } else if (last) {
                [lineItemBtns addObject:btn];
                offsetX += itemSize.width;
                offsetX = (width - offsetX - _contentInsets.right) / 2 + _contentInsets.left;
                [self addItemBtnArray:lineItemBtns offsetX:offsetX];
                offsetY += itemSize.height + 12.f;
            } else if (lineFeed) {
                offsetX = (width - offsetX - _contentInsets.right) / 2 + _contentInsets.left;
                [self addItemBtnArray:lineItemBtns offsetX:offsetX];
                offsetX = _contentInsets.left + itemSize.width + 8.f;
                offsetY += itemSize.height + 12.f;
                CGRect frame = btn.frame;
                frame.origin.y = offsetY;
                btn.frame = frame;
            } else {
                offsetX += itemSize.width + 8.f;
            }
            [lineItemBtns addObject:btn];
        }
        return offsetY - 12.f + _contentInsets.bottom;
    }
    return 0;
}

- (void)addItemBtnArray:(NSMutableArray<UIButton *> *)itemBtnArray offsetX:(CGFloat)offsetX {
    for (UIButton *btn in itemBtnArray) {
        CGRect frame = btn.frame;
        frame.origin.x = offsetX;
        btn.frame = frame;
        [self addSubview:btn];
        offsetX += CGRectGetWidth(frame) + 8.f;
    }
    [itemBtnArray removeAllObjects];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    if (_selectable) {
        btn.selected = !btn.selected;
        [self setBtnStyle:btn];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(streamingLayoutView:didSelectItemBtn:)]) {
        [_delegate streamingLayoutView:self didSelectItemBtn:btn];
    }
}

- (void)setBtnStyle:(UIButton *)btn {
    UIColor *bgColor = _selectable ? (btn.selected ? UIColor.clearColor : VColor.orangeColor) : VColor.disaleBgColor;
    CGFloat borderWidth = (_selectable && btn.selected) ? 1.f : 0.f;
    btn.backgroundColor = bgColor;
    btn.layer.borderWidth = borderWidth;
}

- (void)changeItemStateWithItem:(NSString *)item {
    if (!_selectable || !item) return;
    NSInteger index = [self.itemArray indexOfObject:item];
    if (index < 0 && index >= self.subviews.count) return;
    UIButton *btn = self.subviews[index];
    btn.selected = NO;
    [self setBtnStyle:btn];
}

@end
