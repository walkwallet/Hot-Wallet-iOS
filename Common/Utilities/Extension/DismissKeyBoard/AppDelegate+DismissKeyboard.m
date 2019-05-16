//
//  AppDelegate+DismissKeyboard.m
//  Wallet
//
//  All rights reserved.
//

#import "AppDelegate+DismissKeyboard.h"
#import <objc/runtime.h>

@implementation AppDelegate (DismissKeyboard)

- (void)enableAutoDismissKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGesture) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeGesture) name:UIKeyboardDidHideNotification object:nil];
}

- (UITapGestureRecognizer *)dismissKeyboardTapGesture {
    return objc_getAssociatedObject(self, @selector(dismissKeyboardTapGesture));
}

- (void)setDismissKeyboardTapGesture:(UITapGestureRecognizer *)dismissKeyboardTapGesture {
    objc_setAssociatedObject(self, @selector(dismissKeyboardTapGesture), dismissKeyboardTapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addGesture {
    if (![self dismissKeyboardTapGesture]) {
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.keyWindow addGestureRecognizer:tapGr];
        [self setDismissKeyboardTapGesture:tapGr];
    }
}

- (void)removeGesture {
    UITapGestureRecognizer *tapGr = [self dismissKeyboardTapGesture];
    if (tapGr) {
        [self.keyWindow removeGestureRecognizer:tapGr];
        [self setDismissKeyboardTapGesture:nil];
    }
}

- (void)dismissKeyboard {
    [self.keyWindow endEditing:YES];
    [self removeGesture];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
