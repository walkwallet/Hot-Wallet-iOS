//
//  UIScrollView+EmptyData.m
//  Wallet
//
//  All rights reserved.
//

#import "UIScrollView+EmptyData.h"
#import <objc/runtime.h>
#import "VColor.h"

@implementation UIScrollView (EmptyData)

- (void)ed_setupEmptyDataDisplay {
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
}

- (BOOL)invokingValid {
    return [self isKindOfClass:UITableView.class] || [self isKindOfClass:UICollectionView.class];
}

- (void)ed_reloadData {
    if ([self isKindOfClass:UITableView.class]) {
        [((UITableView *)self) reloadData];
    } else if ([self isKindOfClass:UICollectionView.class]) {
        [((UICollectionView *)self) reloadData];
    }
}

#pragma mark - Setter / Getter
- (BOOL)ed_emptyDataViewShow {
    return [objc_getAssociatedObject(self, @selector(ed_emptyDataViewShow)) boolValue];
}

- (void)setEd_emptyDataViewShow:(BOOL)ed_emptyDataViewShow {
    objc_setAssociatedObject(self, @selector(ed_emptyDataViewShow), @(ed_emptyDataViewShow), OBJC_ASSOCIATION_COPY);
    [self ed_reloadData];
}

- (BOOL)ed_loading {
    return [objc_getAssociatedObject(self, @selector(ed_loading)) boolValue];
}

- (void)setEd_loading:(BOOL)ed_loading {
    objc_setAssociatedObject(self, @selector(ed_loading), @(ed_loading), OBJC_ASSOCIATION_COPY);
    [self ed_reloadData];
}

- (CGFloat)ed_loading_offset {
    return [objc_getAssociatedObject(self, @selector(ed_loading_offset)) floatValue];
}

- (void)setEd_loading_offset:(CGFloat)ed_loading_offset {
    objc_setAssociatedObject(self, @selector(ed_loading_offset), @(ed_loading_offset), OBJC_ASSOCIATION_COPY);
}

- (CGFloat)ed_empty_offset {
    return [objc_getAssociatedObject(self, @selector(ed_empty_offset)) floatValue];
}

- (void)setEd_empty_offset:(CGFloat)ed_empty_offset {
    objc_setAssociatedObject(self, @selector(ed_empty_offset), @(ed_empty_offset), OBJC_ASSOCIATION_COPY);
}

#pragma mark - DZNEmptyDataSet Source
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:(self.ed_loading ? @"ico_loading_white" : @"ico_empty_data")];
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.ed_loading ? VColor.themeColor : VColor.placeholderColor;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.ed_loading) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rotationAnimation.duration = 0.7f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INFINITY;
        return rotationAnimation;
    }
    return CAAnimation.new;
}

#pragma mark - DZNEmptyDataSet Delegate
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.ed_loading ? self.ed_loading_offset : self.ed_empty_offset;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.ed_loading;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
