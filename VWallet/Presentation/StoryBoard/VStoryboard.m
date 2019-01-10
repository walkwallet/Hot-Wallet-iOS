//
//  VStoryboard.m
//  Wallet
//
//  All rights reserved.
//

#import "VStoryboard.h"

@implementation VStoryboard

+ (UIStoryboard *)Main {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)Phrase {
    return [UIStoryboard storyboardWithName:@"Phrase" bundle:nil];
}

+ (UIStoryboard *)Wallet {
    return [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
}

+ (UIStoryboard *)Generate {
    return [UIStoryboard storyboardWithName:@"Generate" bundle:nil];
}

+ (UIStoryboard *)Network {
    return [UIStoryboard storyboardWithName:@"Network" bundle:nil];
}

+ (UIStoryboard *)Settings {
    return [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
}

+ (UIStoryboard *)About {
    return [UIStoryboard storyboardWithName:@"About" bundle:nil];
}

+ (UIStoryboard *)Address {
    return [UIStoryboard storyboardWithName:@"Address" bundle:nil];
}

+ (UIStoryboard *)Password {
    return [UIStoryboard storyboardWithName:@"Password" bundle:nil];
}
@end
