//
//  UIViewController+Alert.m
//  Wallet
//
//  All rights reserved.
//

#import "UIViewController+Alert.h"
#import "Language.h"
#import "VColor.h"
#import "UIColor+Hex.h"
#import "AlertViewController.h"
#import "AlertNavController.h"
#import "ToastPasswordViewController.h"
#import <Masonry/Masonry.h>

@implementation UIViewController (Alert)

- (NSAttributedString *)getAttredString:(NSString *)str {
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str?:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x363647]}];
    return alertControllerMessageStr;
}

- (void)confirmAlertWithTitle:(NSString *_Nullable)msg
                      handler:(void (^ __nullable)(void))handler {
    return [self confirmAlertWithTitle:msg confirmText:@"" handler:handler];
}

- (void)confirmAlertWithTitle:(NSString *_Nullable)msg
                  confirmText:(NSString *)confirmText
                      handler:(void (^ __nullable)(void))handler {
    return [self confirmAlertWithTitle:nil message:msg confirmText:confirmText handler:handler];
}

- (void)confirmAlertWithTitle:(NSString *_Nullable)title
                      message:(NSString *_Nullable)message
                  confirmText:(NSString *_Nullable)confirmText
                      handler:(void (^ __nullable)(void))handler {
    [self confirmAlertWithTitle:title message:message confirmText:confirmText cancelText:nil confirmHandler:handler cancelHandler:nil];
}

- (void)confirmAlertWithTitle:(NSString *)title
                      message:(NSString *)msg
                  confirmText:(NSString *)confirmText
                   cancelText:(NSString *)cancelText
               confirmHandler:(void (^)(void))confirmHandler
                cancelHandler:(void (^)(void))cancelHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if ([title length] > 0) {
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                              NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                              NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                                              }];
        [alert setValue:attr forKey:@"attributedTitle"];
    }
    if ([msg length] > 0) {
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:msg attributes:@{
                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x363647],
                                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                                                 }];
        [alert setValue:attr forKey:@"attributedMessage"];
    }
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:(cancelText?:VLocalize(@"cancel")) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler();
        }
    }];
    [alert addAction:action1];
    [action1 setValue:VColor.textSecondColor forKey:@"_titleTextColor"];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:(confirmText?:VLocalize(@"confirm")) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandler) {
            confirmHandler();
        }
    }];
    [action setValue:VColor.themeColor forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmAlertWithTitle:(NSString *)title
               confirmHandler:(void (^)(void))confirmHandler
                cancelHandler:(void (^)(void))cancelHandler {
    [self confirmAlertWithTitle:title message:nil confirmText:nil cancelText:nil confirmHandler:confirmHandler cancelHandler:cancelHandler];
}

- (void)alertWithTitle:(NSString *)title confirmText:(NSString *)confirmText {
    [self alertWithTitle:title message:nil confirmText:confirmText handler:nil];
}

- (void)alertWithTitle:(NSString *)title confirmText:(NSString *)confirmText handler:(void (^ _Nullable)(void))handler {
    [self alertWithTitle:title message:nil confirmText:confirmText handler:handler];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmText:(NSString *)confirmText handler:(void (^ _Nullable)(void))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:confirmText?:VLocalize(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [action setValue:VColor.themeColor forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)actionAheetWithActionDatas:(NSArray<NSString *> *_Nonnull)data handler:(void (^ __nullable)(NSInteger index))handler {
    return [self actionAheetWithTitle:nil message:nil selectedIndex:-1 withActionDatas:data handler:handler];
}

- (void)actionAheetWithSelectedIndex:(NSInteger)index withActionDatas:(NSArray<NSString *> *_Nonnull)data handler:(void (^ __nullable)(NSInteger index))handler {
    return [self actionAheetWithTitle:nil message:nil selectedIndex:index withActionDatas:data handler:handler];
}

- (void)actionAheetWithTitle:(nullable NSString *)title message:(nullable NSString *)msg withActionDatas:(NSArray<NSString *> *_Nonnull)data handler:(void (^ __nullable)(NSInteger index))handler {
    return [self actionAheetWithTitle:title message:msg selectedIndex:-1 withActionDatas:data handler:handler];
}

- (void)actionAheetWithTitle:(nullable NSString *)title message:(nullable NSString *)msg selectedIndex:(NSInteger)index withActionDatas:(NSArray<NSString *> *_Nonnull)data handler:(void (^ __nullable)(NSInteger index))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:[self isPad] ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < data.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:data[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler(i);
        }];
        
        if (index < 0 || index == i) {
            [action setValue:VColor.themeColor forKey:@"_titleTextColor"];
        } else {
            [action setValue:VColor.textSecondColor forKey:@"_titleTextColor"];
        }
        [alert addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:VLocalize(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [action setValue:VColor.textSecondColor forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (BOOL)isPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (void)passwordAlertWithCallback:(void(^)(BOOL result))callback {
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle: VLocalize(@"tip.password.auth.title") confirmTitle:@"" configureContent:^(UIViewController * _Nonnull vc1, UIStackView * _Nonnull parentView) {
        ToastPasswordViewController *toast = [[ToastPasswordViewController alloc] initWithConfirmTitle:VLocalize(@"done") result:^(BOOL result) {
            if (result) {
                callback(result);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        
        [vc1 addChildViewController:toast];
        [parentView addArrangedSubview:toast.view];
        [toast.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@400);
        }];
    } cancel:^(UIViewController * _Nonnull vc) {
    } confirm:^(UIViewController * _Nonnull vc) {        
    } back:NO];
    vc.autoDismiss = YES;
    AlertNavController *nav = [[AlertNavController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)remindWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    NSInteger duration = message.length / 20;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
