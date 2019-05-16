//
//  Account.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountType.h"
@import Vsys;

NS_ASSUME_NONNULL_BEGIN

@interface Account : NSObject

@property (nonatomic, strong) VsysAccount *originAccount;

@property (nonatomic, assign) int64_t availableBalance;
@property (nonatomic, assign) int64_t totalBalance;
@property (nonatomic, assign) int64_t leasedIn;
@property (nonatomic, assign) int64_t leasedOut;

@property (nonatomic, assign) AccountType accountType;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) BOOL getedInfo;

@end

NS_ASSUME_NONNULL_END
