//
//  VTableViewCellProtocol.h
//  Wallet
//
//  All rights reserved.
//

#ifndef VTableViewCellProtocol_h
#define VTableViewCellProtocol_h

typedef NS_ENUM(NSInteger, CellActionType) {
    SwitchStateChange
};

@protocol VTableViewCellDelegate <NSObject>

- (void)cellActionWithType: (NSInteger)type item:(CellItem *)item;

@end

#endif /* VTableViewCellProtocol_h */
