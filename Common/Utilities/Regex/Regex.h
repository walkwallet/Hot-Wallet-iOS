//
//  Regex.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Regex : NSObject

+ (BOOL)matchRegexStr:(NSString *)regexStr string:(NSString *)string;

+ (NSArray *)seekRegexStr:(NSString *)regexStr string:(NSString *)string;

+ (NSString *)replaceRegexStr:(NSString *)regexStr replaceStr:(NSString *)replaceStr string:(NSString *)string ;

@end

NS_ASSUME_NONNULL_END
