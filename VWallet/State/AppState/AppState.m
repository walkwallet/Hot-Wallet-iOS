//
//  AppState.m
//  Wallet
//
//  All rights reserved.
//

#import "AppState.h"

static NSString *VLockEnableKey = @"VLockEnableKey";
static NSString *VAutoBackupEnableKey = @"VAutoBackupEnableKey";
static NSString *VConnectionCheckEnableKey = @"VConnectionCheckEnableKey";
static NSString *VHasWalletKey = @"VHasWalletKey";
static NSString *VAutoLockTimeKey = @"VAutoLockTimeKey";
static NSString *VLockMethodKey = @"VLockMethodKey";
static NSString *VMonitorAccountFirstAlertKey = @"VMonitorAccountFirstAlertKey";

#define VDefaults [NSUserDefaults standardUserDefaults]

static AppState *VAppState;

@implementation AppState

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VAppState = [[AppState alloc] init];
    });
    return VAppState;
}

- (BOOL)hasWallet {
    BOOL hasWallet = [VDefaults boolForKey:VHasWalletKey];
    if (!hasWallet) {
        self.autoBackupEnable = YES;
        self.connectionCheckEnable = YES;
        self.lockMethod = 2;
        self.autoLockTime = 5;
    }
    return hasWallet;
}

- (void)setHasWallet:(BOOL)hasWallet {
    [VDefaults setBool:hasWallet forKey:VHasWalletKey];
    [VDefaults synchronize];
}

- (BOOL)lockEnable {
    return [VDefaults boolForKey:VLockEnableKey];
}

- (void)setLockEnable:(BOOL)lockEnable {
    [VDefaults setBool:lockEnable forKey:VLockEnableKey];
    [VDefaults synchronize];
}

- (BOOL)autoBackupEnable {
    return [VDefaults boolForKey:VAutoBackupEnableKey];
}

- (void)setAutoBackupEnable:(BOOL)autoBackupEnable {
    [VDefaults setBool:autoBackupEnable forKey:VAutoBackupEnableKey];
    [VDefaults synchronize];
}

- (BOOL)connectionCheckEnable {
    return [VDefaults boolForKey:VConnectionCheckEnableKey];
}

- (void)setConnectionCheckEnable:(BOOL)connectionCheckEnable {
    [VDefaults setBool:connectionCheckEnable forKey:VConnectionCheckEnableKey];
    [VDefaults synchronize];
}

- (NSInteger)autoLockTime {
    return [VDefaults integerForKey:VAutoLockTimeKey];
}

- (void)setAutoLockTime:(NSInteger)autoLockTime {
    [VDefaults setInteger:autoLockTime forKey:VAutoLockTimeKey];
    [VDefaults synchronize];
}

- (void)setLockMethod:(NSInteger)lockMethod {
    [VDefaults setInteger:lockMethod forKey:VLockMethodKey];
    [VDefaults synchronize];
}

- (void)setMonitorAccontFirstAlert:(BOOL)monitorAccontFirstAlert {
    [VDefaults setBool:monitorAccontFirstAlert forKey:VMonitorAccountFirstAlertKey];
    [VDefaults synchronize];
}

- (BOOL)monitorAccontFirstAlert {
    return [VDefaults boolForKey:VMonitorAccountFirstAlertKey];
}

- (NSInteger)lockMethod {
    return [VDefaults integerForKey:VLockMethodKey];
}


- (NSString *)lockMethodDescription {
    switch (self.lockMethod) {
        case 1:
            return @"SecureID";
            break;
        case 2:
            return @"Password";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)lockTimeDescription {
    if (self.autoLockTime == 5) {
        return @"5 min";
    } else if (self.autoLockTime == 10) {
        return @"10 min";
    }
    return @"";
}
@end
