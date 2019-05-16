//
//  Scrypt.m
//  VWallet
//
//  All rights reserved.
//

#import "Scrypt.h"
#import "libscrypt.h"


@implementation Scrypt

+ (NSData *)scrypt:(NSData *)password salt:(NSData *)salt n:(uint64_t)n r:(uint32_t)r p:(uint32_t)p length:(size_t)length error:(NSError **)error {
    NSMutableData *outData = [NSMutableData dataWithLength:length];
    int retval = libscrypt_scrypt((uint8_t *)password.bytes, password.length, (uint8_t *)salt.bytes, salt.length, n, r, p, [outData mutableBytes], outData.length);
    if (retval != 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"Scrypt" code:-1 userInfo:nil];
            return nil;
        }
    }
    NSAssert([outData length] == length, @"Mismatched output length");
    
    return outData;
}

@end
