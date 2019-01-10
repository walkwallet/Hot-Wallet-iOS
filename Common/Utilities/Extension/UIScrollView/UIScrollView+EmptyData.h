//
//  UIScrollView+EmptyData.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (EmptyData) <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)ed_setupEmptyDataDisplay;

@property (nonatomic, assign) BOOL ed_emptyDataViewShow;

@property (nonatomic, assign) BOOL ed_loading;
@property (nonatomic, assign) CGFloat ed_loading_offset;

@property (nonatomic, assign) CGFloat ed_empty_offset;

@end

NS_ASSUME_NONNULL_END
