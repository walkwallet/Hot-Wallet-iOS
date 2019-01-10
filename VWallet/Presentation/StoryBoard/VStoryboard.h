//
//  VStoryboard.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface VStoryboard : NSObject

+ (UIStoryboard *)Main;

+ (UIStoryboard *)Phrase;

+ (UIStoryboard *)Wallet;

+ (UIStoryboard *)Generate;

+ (UIStoryboard *)Network;

+ (UIStoryboard *)Settings;

+ (UIStoryboard *)About;

+ (UIStoryboard *)Address;

+ (UIStoryboard *)Password;
@end

NS_ASSUME_NONNULL_END
