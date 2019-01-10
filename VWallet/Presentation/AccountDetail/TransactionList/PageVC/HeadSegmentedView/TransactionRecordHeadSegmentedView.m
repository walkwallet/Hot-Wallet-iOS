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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *itemBtnArray;

@property (nonatomic, weak) IBOutlet UIView *btnBottomLine;

@end

@implementation TransactionRecordHeadSegmentedView

- (void)awakeFromNib {
    [super awakeFromNib];
    int index = 0;
    for (UIButton *btn in self.itemBtnArray) {
        [btn setTitleColor:VColor.textSecondColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        NSString *key = [NSString stringWithFormat:@"transaction.list.type.%d", index++];
        [btn setTitle:VLocalize(key) forState:UIControlStateNormal];
        [btn setTitleColor:VColor.themeColor forState:UIControlStateSelected];
    }
    ((UIButton *)(self.itemBtnArray.firstObject)).selected = YES;
    self.btnBottomLine.backgroundColor = VColor.themeColor;
}

- (IBAction)itemBtnClick:(UIButton *)sender {
    if (sender.tag == self.currentIndex) {
        return;
    }
    if (self.selectedBlock) {
        self.selectedBlock(self.currentIndex, sender.tag);
    }
    self.currentIndex = sender.tag;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex || currentIndex < 0 || currentIndex >= self.itemBtnArray.count) {
        return;
    }
    UIButton *beforeSelectedBtn = self.itemBtnArray[_currentIndex];
    beforeSelectedBtn.selected = NO;
    beforeSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _currentIndex = currentIndex;
    UIButton *currentSelectedBtn = self.itemBtnArray[_currentIndex];
    currentSelectedBtn.selected = YES;
    currentSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    UIButton *firstBtn = self.itemBtnArray.firstObject;
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBottomLine.transform = CGAffineTransformMakeTranslation(currentSelectedBtn.center.x - firstBtn.center.x, 0);
    }];
}

@end
