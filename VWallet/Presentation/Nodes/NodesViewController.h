//
//  NodesViewController.h
//  VWallet
//
//  Created by carl on 2021/1/15.
//  Copyright © 2021 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodesViewController : UIViewController

@property (nonatomic,strong) void (^block)(void);

@end

NS_ASSUME_NONNULL_END
