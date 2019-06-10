//
// ServerConfig.m
//  Wallet
//
//  All rights reserved.
//

#import "ServerConfig.h"
#import "WalletMgr.h"

@import Vsys;

//static NSString *const MainnetHost = @"https://wallet.v.systems/api";
static NSString *const MainnetHost = @"http://35.200.126.184:9922";

//static NSString *const TestnetHost = @"http://test.v.systems:9922";
static NSString *const TestnetHost = @"http://3.17.31.9:9932";

static NSString *const MainnetExplorerHost = @"https://explorer.tonode.com";

static NSString *const TestnetExplorerHost = @"http://testexplorer.tonode.com";


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
