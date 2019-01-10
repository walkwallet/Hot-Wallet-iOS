//
// ResultParameter.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResultBlock)(void);

@interface ResultParameter : NSObject

@property (nonatomic, copy) NSString *imgResourceName;
@property (nonatomic, copy) NSAttributedString *attrTitle;
@property (nonatomic, copy) NSAttributedString *attrMessage;
@property (nonatomic, assign) CGFloat titleMessageSpecing;
+ (instancetype)paramterWithImgResourceName:(NSString *)imgResourceName
                                  attrTitle:(NSAttributedString *)attrTitle
                                attrMessage:(NSAttributedString *)attrMessage
                        titleMessageSpecing:(CGFloat)titleMessageSpecing;

@property (nonatomic, copy) NSString *operateBtnTitle;
@property (nonatomic, strong) ResultBlock operateBlock;
@property (nonatomic, copy) NSString *secondOperateBtnTitle;
@property (nonatomic, strong) ResultBlock secondOperateBlock;

@property (nonatomic, assign) BOOL showNavigationBar;

@property (nonatomic, assign) BOOL explicitDismiss;

@end

NS_ASSUME_NONNULL_END
