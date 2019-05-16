//
//  WalletHeadSegmentedView.m
//  Wallet
//
//  All rights reserved.
//

#import "WalletHeadSegmentedView.h"
#import <Masonry.h>

#import "VColor.h"
#import "Language.h"

@interface WalletHeadSegmentedView ()

@property (nonatomic, strong) void(^selectedBlock)(NSInteger, NSInteger);

@property (weak, nonatomic) IBOutlet UIButton *walletBtn;
@property (weak, nonatomic) IBOutlet UIButton *monitorBtn;
@property (weak, nonatomic) IBOutlet UIView *btnBottomLine;

@end

@implementation WalletHeadSegmentedView

- (instancetype)initWithSelectedBlock:(void (^)(NSInteger, NSInteger))selectedBlock {
    self = [[[UINib nibWithNibName:@"WalletHeadSegmentedView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    self.selectedBlock = selectedBlock;
    [self.walletBtn setTitle:VLocalize(@"nav.title.wallet") forState:UIControlStateNormal];
    [self.monitorBtn setTitle:VLocalize(@"nav.title.monitor") forState:UIControlStateNormal];
    [self.walletBtn setTitleColor:VColor.textSecondColor forState:UIControlStateNormal];
    [self.monitorBtn setTitleColor:VColor.textSecondColor forState:UIControlStateNormal];
    [self.walletBtn setTitleColor:VColor.orangeColor forState:UIControlStateSelected];
    [self.monitorBtn setTitleColor:VColor.blueColor forState:UIControlStateSelected];
    self.walletBtn.selected = YES;
    self.btnBottomLine.backgroundColor = VColor.orangeColor;
    return self;
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
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    switch (_currentIndex) {
        case 0: {
            self.walletBtn.selected = YES;
            self.monitorBtn.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.btnBottomLine.transform = CGAffineTransformIdentity;
                self.btnBottomLine.backgroundColor = VColor.orangeColor;
            }];
        } break;
        case 1: {
            self.walletBtn.selected = NO;
            self.monitorBtn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.btnBottomLine.transform = CGAffineTransformMakeTranslation(self.monitorBtn.center.x - self.walletBtn.center.x, 0);
                self.btnBottomLine.backgroundColor = VColor.blueColor;
            }];
        } break;
    }
}

@end
