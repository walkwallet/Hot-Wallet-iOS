//
//  SuccessViewController.h
//  VWallet
//
//  Copyright © 2019 veetech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuccessObject : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *topNote;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *bottomNote;
@end

@interface SuccessViewController : UIViewController

- (instancetype)initWithObject:(SuccessObject *)object;

- (instancetype)initWithTitle:(NSString *)title topNote:(NSString *)topNote content:(NSString *)content bottomNote:(NSString *)bottomNote;

@end

NS_ASSUME_NONNULL_END
