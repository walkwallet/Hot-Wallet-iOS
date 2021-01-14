//
// ServerConfig.m
//  Wallet
//
//  All rights reserved.
//

#import "ServerConfig.h"
#import "WalletMgr.h"

@import Vsys;

static NSString *const MainnetHost = @"https://wallet.v.systems/api";

static NSString *const TestnetHost = @"http://test-node.v.systems:9924";

static NSString *const MainnetExplorerHost = @"https://explorer.v.systems";

static NSString *const TestnetExplorerHost = @"https://testexplorer.v.systems";


@implementation ServerConfig

+ (NSString *)ApiHost {
    if ([WalletMgr.shareInstance.network isEqualToString:VsysNetworkMainnet]) {
        return MainnetHost;
    } else {
        return TestnetHost;
    }
}

+ (NSString *)ExplorerHost {
    if ([WalletMgr.shareInstance.network isEqualToString:VsysNetworkMainnet]) {
        return MainnetExplorerHost;
    }else {
        return TestnetExplorerHost;
    }
}

@end
