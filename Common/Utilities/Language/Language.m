//
//  Language.m
//  Wallet
//
//  All rights reserved.
//

#import "Language.h"

#define UserLanguage @"UserLanguage"
#define AppleLanguage @"AppleLanguages"

static Language *VLanguage = nil;

@interface Language()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation Language

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VLanguage = [[Language alloc] init];
        [VLanguage readPreLanguageSettings];
    });
    return VLanguage;
}

+ (NSArray *)supportLanguages {
    return @[@"English", @"简体中文"];
}

- (void)setLanguageType:(LanguageType)languageType {
    _languageType = languageType;
    NSString *name = [self getLanguageKeyByType: languageType];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    
    [NSUserDefaults.standardUserDefaults setObject:name forKey:UserLanguage];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)getString:(NSString *)key {
    if ([Language shareInstance].bundle) {
        return [[Language shareInstance].bundle localizedStringForKey:key value:nil table:nil];
    }
    return key;
}

- (void)readPreLanguageSettings {
    NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:UserLanguage];
    if (!lan) {
        lan = [[[NSUserDefaults standardUserDefaults] arrayForKey:AppleLanguage] firstObject];
    }
    lan = [lan stringByReplacingOccurrencesOfString:@"-CN" withString:@""];
    lan = [lan stringByReplacingOccurrencesOfString:@"-US" withString:@""];
    self.languageType = [self getLanguaegTypeByKey:lan];
    NSString *path = [[NSBundle mainBundle] pathForResource:lan ofType:@"lproj"];
    if (!path) {
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    _bundle = [NSBundle bundleWithPath:path];
}

- (LanguageType)getLanguaegTypeByKey:(NSString *)key {
    if ([key isEqualToString:@"zh-Hans"]) {
        return LanguageTypeCN;
    }
    return LanguageTypeEN;
}

- (NSString *)getLanguageKeyByType:(LanguageType)type {
    switch (type) {
        case LanguageTypeCN:
            return @"zh-Hans";
        default:
            return @"en";
    }
}

- (LanguageType)getLanguaegTypeByDesc:(NSString *)desc {
    if ([desc isEqualToString:@"简体中文"]) {
        return LanguageTypeCN;
    }
    return LanguageTypeEN;
}

- (NSString *)getDescByType:(LanguageType)type {
    switch (type) {
        case LanguageTypeCN:
            return @"简体中文";
        default:
            return @"English";
    }
}

@end
