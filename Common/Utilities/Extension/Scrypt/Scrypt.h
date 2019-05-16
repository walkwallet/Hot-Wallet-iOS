//
//  Scrypt.h
//  VWallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Scrypt : NSObject

+ (NSData *)scrypt:(NSData *)password salt:(NSData *)salt n:(uint64_t)n r:(uint32_t)r p:(uint32_t)p length:(size_t)length error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
