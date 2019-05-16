//
//  UIColor+Hex.m
//  Wallet
//
//  All rights reserved.
//

#import "UIColor+Hex.h"

CGFloat colorComponentWith(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex andAlpha:1];
}

+ (UIColor *)colorWithHexStr:(NSString *)hexStr {
    if (!hexStr || ![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(#|0x|0X)?([\\dA-Fa-f]{3,4}|[\\dA-Fa-f]{6}|[\\dA-Fa-f]{8})$"] evaluateWithObject:hexStr]) {
        return UIColor.clearColor;
    }
    CGFloat alpha, red, blue, green;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(#|0x|0X)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *colorString = [regex stringByReplacingMatchesInString:hexStr options:NSMatchingReportProgress range:NSMakeRange(0, hexStr.length) withTemplate:@""].uppercaseString;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = colorComponentWith(colorString, 0, 1);
            green = colorComponentWith(colorString, 1, 1);
            blue  = colorComponentWith(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = colorComponentWith(colorString, 0, 1);
            red   = colorComponentWith(colorString, 1, 1);
            green = colorComponentWith(colorString, 2, 1);
            blue  = colorComponentWith(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = colorComponentWith(colorString, 0, 2);
            green = colorComponentWith(colorString, 2, 2);
            blue  = colorComponentWith(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = colorComponentWith(colorString, 0, 2);
            red   = colorComponentWith(colorString, 2, 2);
            green = colorComponentWith(colorString, 4, 2);
            blue  = colorComponentWith(colorString, 6, 2);
            break;
        default:
            return UIColor.clearColor;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)hexString {
    UIColor *color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return @"FFFFFF";
    }
    return [NSString stringWithFormat:@"%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end
