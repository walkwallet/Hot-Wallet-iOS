//
//  TouchIDTool.m
//  Wallet
//
//  All rights reserved.
//

#import "TouchIDTool.h"
#import "Language.h"

@import LocalAuthentication;

@implementation TouchIDTool

+ (void)authSecureID:(void(^)(BOOL support, BOOL result))callback {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        callback(NO, NO);
        return;
    }
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LAContext *ctx = [[LAContext alloc] init];
    ctx.localizedFallbackTitle = @"";
    NSError *error = nil;
    BOOL isSupport = [ctx canEvaluatePolicy:deviceType error:&error];
    if (error || !isSupport) {
        NSLog(@"%@", error);
        callback(NO, NO);
        return;
    }
    
    NSString *message = VLocalize(@"tip.secure.auth.detail");
    [ctx evaluatePolicy:deviceType localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"%d, %@", success, error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                callback(YES, YES);
            } else {
                callback(YES, NO);
            }
        });
    }];
}

+ (NSString *)authType {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        return @"";
    }
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LAContext *ctx = [[LAContext alloc] init];
    ctx.localizedFallbackTitle = @"";
    NSError *error = nil;
    BOOL isSupport = [ctx canEvaluatePolicy:deviceType error:&error];
    if (error || !isSupport) {
        return @"";
    }
    
    if (@available(iOS 11, *)) {
        if (ctx.biometryType == LABiometryTypeTouchID) {
            return @"TouchID";
        }
        if (ctx.biometryType == LABiometryTypeFaceID) {
            return @"FaceID";
        }
    }
    return @"TouchID / FaceID";
}

@end
