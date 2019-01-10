//
//  Language.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define VLocalize(str) [[Language shareInstance] getString:str]

typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeCN = 0,
    LanguageTypeEN
};

@interface Language : NSObject

@property (nonatomic, copy) NSString *lan;

@property (nonatomic, assign) LanguageType languageType;

+ (instancetype)shareInstance;

- (NSString *)getString:(NSString *)key;

- (NSString *)getDescByType:(LanguageType)type;

+ (NSArray *)supportLanguages;

- (LanguageType)getLanguaegTypeByDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
