//
//  SuperNode.h
//  VWallet
//
//  Copyright © 2021 veetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubNode : NSObject

@property (nonatomic) int id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logo;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *weight;

@end


@interface TokenInfo : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *logo;
@property (nonatomic) int64_t mintAmount;
@property (nonatomic) int64_t mintDay;
@property (nonatomic) NSString *returnRate;
@property (nonatomic) NSString *cycle;
@property (nonatomic) NSString *fee;

@end


@interface SuperNode : NSObject

@property (nonatomic) NSString *address;
@property (nonatomic) int64_t leaseInBalance;
@property (nonatomic) int64_t dailyEfficiency;
@property (nonatomic) int64_t monthlyEfficiency;
@property (nonatomic) NSString *logo;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *voteAddress;
@property (nonatomic) NSString *location;
@property (nonatomic) double fee;
@property (nonatomic) NSString *capacity;
@property (nonatomic) NSString *cycle;
@property (nonatomic) NSString *url;
@property (nonatomic) BOOL isSuperNode;
@property (nonatomic, copy) NSArray<TokenInfo *> *tokenInfoList;
@property (nonatomic, copy) NSArray<SubNode *> *subNodeList;

@end



