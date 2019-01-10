//
//  SectionItem.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellItem.h"

#define VSectionItem(title, cellItems) [[SectionItem alloc] initWithTitle:title items:cellItems]

NS_ASSUME_NONNULL_BEGIN

@interface SectionItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray<CellItem *> *cellItems;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<CellItem *> *)items;

@end

NS_ASSUME_NONNULL_END
