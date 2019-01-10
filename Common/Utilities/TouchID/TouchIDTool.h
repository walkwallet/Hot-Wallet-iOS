//
//  TouchIDTool.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouchIDTool : NSObject

+ (void)authSecureID:(void(^)(BOOL support, BOOL result))callback;

+ (NSString *)authType;
@end

NS_ASSUME_NONNULL_END
