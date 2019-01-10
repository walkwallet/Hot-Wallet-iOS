//
//  VAlertViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VAlertViewController : UIViewController

@property (nonatomic, assign) BOOL notDismiss;
    
- (instancetype)initWithTitle:(NSString *)title
                  secondTitle:(NSString *_Nullable)secondTitle
                  contentView:(void(^_Nullable)(UIStackView *))configureView
                  cancelTitle:(NSString *_Nullable)cancelTitle
                 confirmTitle:(NSString *_Nullable)confirmTitle
                       cancel:(void(^_Nullable)(void))cancel
                      confirm:(void(^_Nullable)(void))confirm;

- (instancetype)initWithIconName:(NSString *_Nullable)iconName
                           title:(NSString *)title
                     secondTitle:(NSString *_Nullable)secondTitle
                     contentView:(void(^_Nullable)(UIStackView *))configureView
                     cancelTitle:(NSString *_Nullable)cancelTitle
                    confirmTitle:(NSString *_Nullable)confirmTitle
                          cancel:(void(^_Nullable)(void))cancel
                         confirm:(void(^_Nullable)(void))confirm;

@end

NS_ASSUME_NONNULL_END
