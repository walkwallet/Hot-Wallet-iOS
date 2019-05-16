//
//  SectionItem.m
//  Wallet
//
//  All rights reserved.
//

#import "SectionItem.h"

@implementation SectionItem

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<CellItem *> *)items {
    if (self = [super init]) {
        self.title = title;
        self.cellItems = items;
    }
    return self;
}
@end
