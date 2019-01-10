//
//  NSString+Asterisk.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Asterisk)

- (NSString *)implicitCount:(NSInteger)count;

- (NSString *)explicitCount:(NSInteger)count;

- (NSString *)explicitCount:(NSInteger)count maxAsteriskCount:(NSInteger)maxAsteriskCount;

@end

NS_ASSUME_NONNULL_END
