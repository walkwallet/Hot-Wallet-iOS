//
//  Contract.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ContractInfo : NSObject
@property (nonatomic) NSString *data;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *name;
@end

@interface ContractInfoList : NSObject
@property (nonatomic) NSArray<ContractInfo *> *list;
@end

@interface Contract : NSObject

@property (nonatomic) NSString *contractId;
@property (nonatomic) NSString *transactionId;
@property (nonatomic) NSInteger *height;
@property (nonatomic) NSString *issuer;
@property (nonatomic) double balance;
@property (nonatomic) ContractInfoList *infoList;

@end

NS_ASSUME_NONNULL_END
