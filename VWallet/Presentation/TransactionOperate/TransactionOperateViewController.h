//
// TransactionOperateViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TransactionOperateType) {
    TransactionOperateTypeSend = 0,
    TransactionOperateTypeLease
};

@interface TransactionOperateViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account operateType:(TransactionOperateType)operateType;

@end

NS_ASSUME_NONNULL_END
