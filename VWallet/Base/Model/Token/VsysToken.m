//
//  Token.m
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import "VsysToken.h"

@implementation VsysToken

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.tokenId forKey:@"tokenId"];
    [aCoder encodeObject:self.contractId forKey:@"contractId"];
    [aCoder encodeInt64:self.balance forKey:@"balance"];
    [aCoder encodeInt64:self.max forKey:@"max"];
    [aCoder encodeInt64:self.total forKey:@"total"];
    [aCoder encodeInt64:self.unity forKey:@"unity"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.descContract forKey:@"descContract"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.issuer forKey:@"issuer"];
    [aCoder encodeObject:self.maker forKey:@"maker"];
    [aCoder encodeObject:self.textualDescriptor forKey:@"textualDescriptor"];
    [aCoder encodeBool:self.splitable forKey:@"splitable"];
    [aCoder encodeBool:self.watched forKey:@"watched"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.tokenId = [aDecoder decodeObjectForKey:@"tokenId"];
        self.contractId = [aDecoder decodeObjectForKey:@"contractId"];
        self.balance = [aDecoder decodeInt64ForKey:@"balance"];
        self.max = [aDecoder decodeInt64ForKey:@"max"];
        self.total = [aDecoder decodeInt64ForKey:@"total"];
        self.unity = [aDecoder decodeInt64ForKey:@"unity"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.descContract = [aDecoder decodeObjectForKey:@"descContract"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.issuer = [aDecoder decodeObjectForKey:@"issuer"];
        self.maker = [aDecoder decodeObjectForKey:@"maker"];
        self.textualDescriptor = [aDecoder decodeObjectForKey:@"textualDescriptor"];
        self.splitable = [aDecoder decodeBoolForKey:@"splitable"];
        self.watched = [aDecoder decodeBoolForKey:@"watched"];
    }
    return self;
}

- (BOOL) isNFTToken {
    return self.max == 1 && self.unity == 1 && !self.splitable;
}

@end
