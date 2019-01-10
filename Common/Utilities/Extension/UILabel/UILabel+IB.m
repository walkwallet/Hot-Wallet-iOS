//
//  UILabel+IB.m
//  Wallet
//
//  All rights reserved.
//

#import "UILabel+IB.h"

@implementation UILabel (IB)
@dynamic autoAdjFont;

- (void)setAutoAdjFont:(BOOL)autoAdjFont {
    self.adjustsFontSizeToFitWidth = YES;
}

@end
