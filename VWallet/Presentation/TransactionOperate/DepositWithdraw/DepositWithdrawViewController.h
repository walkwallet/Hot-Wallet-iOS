//
//  DepositWithdrawViewController.h
//  VWallet
//
//  Copyright © 2021 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionOperateViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepositWithdrawViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account operateType:(TransactionOperateType)operateType;

@end

NS_ASSUME_NONNULL_END
