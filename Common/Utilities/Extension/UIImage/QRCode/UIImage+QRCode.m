//
//  UIImage+QRCode.m
//  Wallet
//
//  All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

+ (instancetype)imageWithQrCodeStr:(NSString *)qrCodeStr {
    return [self imageWithQrCodeStr:qrCodeStr size:200.f];
}

+ (instancetype)imageWithQrCodeStr:(NSString *)qrCodeStr size:(CGFloat)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [qrCodeStr?:@"" dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    CIImage *image = [filter outputImage];
    return [self createHDQrCodeImageWithCIImage:image size:size];
}

+ (UIImage *)createHDQrCodeImageWithCIImage:(CIImage *)image size:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef cgContext = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [ciContext createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationNone);
    CGContextScaleCTM(cgContext, scale, scale);
    CGContextDrawImage(cgContext, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(cgContext);
    CGContextRelease(cgContext);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return img;
}

@end
