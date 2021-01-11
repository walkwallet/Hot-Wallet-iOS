//
//  CreateTokenViewController.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
@class VsysToken;

typedef NS_ENUM(NSInteger, TokenOperatePageType) {
    TokenOperatePageTypeCreate = 0,
    TokenOperatePageTypeIssue,
    TokenOperatePageTypeBurn
};

@interface TokenOperateViewController : UIViewController

- (instancetype)initWithAccount:(Account *)account;

- (instancetype)initWithAccount:(Account *)account type:(NSInteger)type;

- (instancetype)initWithAccount:(Account *)account type:(NSInteger)type token:(VsysToken *)token;

@end
