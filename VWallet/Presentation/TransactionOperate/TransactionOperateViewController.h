//
// TransactionOperateViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class VsysToken;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TransactionOperateType) {
    TransactionOperateTypeSend = 0,
    TransactionOperateTypeLease,
    TransactionOperateTypeSendToken,
};

@interface TransactionOperateViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account operateType:(TransactionOperateType)operateType;

- (instancetype)initWithAccount:(Account *)account token:(VsysToken *)token operateType:(TransactionOperateType)operateType;

@end

NS_ASSUME_NONNULL_END
