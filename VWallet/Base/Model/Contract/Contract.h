//
//  Contract.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractInfoItem : NSObject
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@end

@interface Contract : NSObject
@property (nonatomic, copy) NSString *contractId;
@property (nonatomic, copy) NSString *transactionId;
@property (nonatomic) int64_t height;
@property (nonatomic, copy) NSArray<ContractInfoItem *> *info;
@property (nonatomic, copy) NSString *type;
@end

@interface ContractContentTextual : NSObject
@property (nonatomic, copy) NSString *triggers;
@property (nonatomic, copy) NSString *descriptors;
@property (nonatomic, copy) NSString *stateVariables;
@end

@interface ContractContent : NSObject
@property (nonatomic, copy) NSString *transactionId;
@property (nonatomic, copy) NSString *languageCode;
@property (nonatomic) int8_t languageVersion;
@property (nonatomic, strong) ContractContentTextual *textual;
@property (nonatomic) int64_t height;
@end

@interface ContractData : NSObject
@property (nonatomic, copy) NSString *contractId;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *dbName;
@property (nonatomic) int64_t height;
@property (nonatomic) int64_t value;
@end


