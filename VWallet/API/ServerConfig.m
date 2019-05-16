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
//static NSString *const MainnetHost = @"http://35.200.126.184:9922";
static NSString *const MainnetHost = @"http://3.19.103.180:29928";

static NSString *const TestnetHost = @"http://test.v.systems:9922";
//static NSString *const TestnetHost = @"http://35.200.126.184:9922";


@implementation ServerConfig

+ (NSString *)ApiHost {
    if ([WalletMgr.shareInstance.network isEqualToString:VsysNetworkMainnet]) {
        return MainnetHost;
    } else {
        return TestnetHost;
    }
}

@end
