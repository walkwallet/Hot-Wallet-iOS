//
//  UITextView+Placeholder.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Placeholder) <UITextViewDelegate>

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, weak) UILabel *placeholderLabel;

/** update Placeholder show status
 *  if textview no set up delegate, this will auto used
 *  else you need to call it in textViewDidChange:
 */
- (void)updatePlaceholderState;

@end

NS_ASSUME_NONNULL_END
