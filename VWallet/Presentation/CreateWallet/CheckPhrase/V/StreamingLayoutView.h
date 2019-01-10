//
// StreamingLayoutView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class StreamingLayoutView;

NS_ASSUME_NONNULL_BEGIN

@protocol StreamingLayoutViewDelegate <NSObject>

- (void)streamingLayoutView:(StreamingLayoutView *)streamingLayoutView didSelectItemBtn:(UIButton *)itemBtn;

@end

@interface StreamingLayoutView : UIView

@property (nonatomic, assign) IBInspectable BOOL selectable;

@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, strong, nullable) NSArray<NSString *> *itemArray;

- (CGFloat)heightWithItemArray:(nullable NSArray<NSString *> *)itemArray width:(CGFloat)width;

@property (nonatomic, weak) id<StreamingLayoutViewDelegate> delegate;

- (void)changeItemStateWithItem:(NSString *)item;

@end

NS_ASSUME_NONNULL_END
