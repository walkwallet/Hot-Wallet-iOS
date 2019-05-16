//
//  QRScanner.h
//  Wallet
//
//  All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScanner : NSObject

- (instancetype)initWithResult:(void(^)(NSString *__nullable qrCode))result;

@property (nonatomic, assign) CGRect rectOfInterest;

- (void)initSettings;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;

- (void)startRunning;
- (void)stopRunning;

#pragma mark - torch
@property (nonatomic, assign, readonly) BOOL hasTorch;
@property (nonatomic, assign) BOOL torchSwitch;

@end

NS_ASSUME_NONNULL_END
