//
//  Token.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VsysToken : NSObject

@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, copy) NSString *contractId;
@property (nonatomic) int64_t balance;
@property (nonatomic) int64_t max;
@property (nonatomic) int64_t total;
@property (nonatomic) int64_t unity;
// desc for token
@property (nonatomic) NSString *desc;
// descToken for contract
@property (nonatomic) NSString *descContract;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *issuer;
@property (nonatomic) NSString *maker;
@property (nonatomic) NSString *textualDescriptor;

@property (nonatomic) BOOL splitable;
@property (nonatomic) BOOL watched;

- (BOOL) isNFTToken;

@end
