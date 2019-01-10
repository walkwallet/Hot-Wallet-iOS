//
//  CellItem.m
//  Wallet
//
//  All rights reserved.
//

#import "CellItem.h"

@implementation CellItem


- (instancetype)initWithIdentifier: (NSString *)identifier type:(NSString *)type title: (NSString *)title icon:(NSString *)icon desc: (NSString *)desc other: (NSDictionary *)dict {
    self = [super init];
    self.identifier = identifier;
    self.type = type;
    self.title = title;
    self.icon = icon;
    self.desc = desc;
    self.dict = dict;
    return self;
}

@end
