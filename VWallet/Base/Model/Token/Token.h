//
//  Token.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TokenFunc : NSObject
@property (nonatomic, strong) NSString *name;
@end

@interface Token : NSObject

@property (nonatomic, strong) NSString *tokenId;
@property (nonatomic, strong) NSString *contractId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) NSInteger unity;
@property (nonatomic, assign) double max;
@property (nonatomic, assign) NSArray<TokenFunc *> *funcList;
@property (nonatomic, strong) NSString *issuer;
@property (nonatomic, strong) NSString *registerTime;
@property (nonatomic, assign) double *issuedAmount;
@property (nonatomic, strong) NSString *description;

@end

NS_ASSUME_NONNULL_END
