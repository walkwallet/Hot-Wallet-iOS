//
//  AppState.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppState : NSObject

+ (instancetype) shareInstance;

@property (nonatomic, assign) BOOL hasWallet;

@property (nonatomic, assign) BOOL lockEnable;

@property (nonatomic, assign) BOOL autoBackupEnable;

@property (nonatomic, assign) BOOL connectionCheckEnable;

@property (nonatomic, assign) NSInteger autoLockTime;

@property (nonatomic, assign) NSInteger lockMethod;

@property (nonatomic, assign) BOOL monitorAccontFirstAlert;

- (NSString *)lockMethodDescription;

- (NSString *)lockTimeDescription;

@end

NS_ASSUME_NONNULL_END
