//
// ResultParameter.m
//  Wallet
//
//  All rights reserved.
//

#import "ResultParameter.h"

@implementation ResultParameter

+ (instancetype)paramterWithImgResourceName:(NSString *)imgResourceName attrTitle:(NSAttributedString *)attrTitle attrMessage:(NSAttributedString *)attrMessage titleMessageSpecing:(CGFloat)titleMessageSpecing {
    ResultParameter *parameter = [[ResultParameter alloc] init];
    parameter.imgResourceName = imgResourceName;
    parameter.attrTitle = attrTitle;
    parameter.attrMessage = attrMessage;
    parameter.titleMessageSpecing = titleMessageSpecing;
    return parameter;
}

@end
