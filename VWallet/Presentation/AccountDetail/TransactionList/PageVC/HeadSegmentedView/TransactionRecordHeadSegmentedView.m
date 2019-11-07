//
// TransactionRecordHeadSegmentedView.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionRecordHeadSegmentedView.h"
#import "VColor.h"
#import "Language.h"

@interface TransactionRecordHeadSegmentedView ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIView *btnBottomLine;

@end

@implementation TransactionRecordHeadSegmentedView

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat padding = 16;
    
    CGFloat right = 0;
    for (NSInteger index = 0; index < 6; index++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        NSString *key = [NSString stringWithFormat:@"transaction.list.type.%ld", (long)index];
        [label setText:VLocalize(key)];
        CGFloat buttonWidth = label.intrinsicContentSize.width + 2 * padding;
        CGFloat buttonHeight = 44;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(right, 0, buttonWidth , buttonHeight)];
        [button setTitleColor:VColor.textSecondColor forState:UIControlStateNormal];
        [button setTitleColor:VColor.themeColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:VLocalize(key) forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
        if (index == 0) {
            [button setSelected:YES];
            self.btnBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 2, buttonWidth, 2)];
            self.btnBottomLine.backgroundColor = VColor.themeColor;
            [self.scrollView addSubview:self.btnBottomLine];
        }

        button.tag = index;
        [button addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        right += buttonWidth;
        [self.scrollView addSubview:button];
    }

    self.scrollView.contentSize = CGSizeMake(right, 44);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.scrollView bringSubviewToFront:self.btnBottomLine];
    self.btnBottomLine.backgroundColor = VColor.themeColor;
}

- (void)itemBtnClick:(UIButton *)sender {
    if (sender.tag == self.currentIndex) {
        return;
    }
    if (self.selectedBlock) {
        self.selectedBlock(self.currentIndex, sender.tag);
    }
    self.currentIndex = sender.tag;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex || currentIndex < 0 || currentIndex >= 6) {
        return;
    }
    
    UIButton *beforeSelectedBtn = self.scrollView.subviews[_currentIndex];
    beforeSelectedBtn.selected = NO;
    beforeSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _currentIndex = currentIndex;
    UIButton *currentSelectedBtn = self.scrollView.subviews[_currentIndex];
    currentSelectedBtn.selected = YES;
    currentSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.btnBottomLine.frame;
        frame.origin.x = currentSelectedBtn.frame.origin.x;
        frame.size.width = currentSelectedBtn.frame.size.width;
        self.btnBottomLine.frame = frame;
    }];
}

@end
