//
//  QRScanner.m
//  Wallet
//
//  All rights reserved.
//

#import "QRScanner.h"

@interface QRScanner () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) void(^resultBlock)(NSString *__nullable);

@property (nonatomic, weak) AVCaptureSession *session;

@property (nonatomic, weak) AVCaptureDevice *device;

@end

@implementation QRScanner

- (instancetype)initWithResult:(void (^)(NSString * _Nullable))result {
    if (self = [super init]) {
        self.resultBlock = result;
    }
    return self;
}

- (void)initSettings {
    // Session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    _session = session;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _device = device;
    NSError *error;
    [device lockForConfiguration:&error];
    if (!error) {
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [device unlockForConfiguration];
    }
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        return;
    }
    [session addInput:input];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if (!CGRectEqualToRect(_rectOfInterest, CGRectZero)) {
        CGRect r = CGRectMake(_rectOfInterest.origin.y, _rectOfInterest.origin.x, _rectOfInterest.size.height, _rectOfInterest.size.width);;
        output.rectOfInterest = r;
    }
    [session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    _layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

#pragma mark - start/stop
- (void)startRunning {
    [_session startRunning];
}

- (void)stopRunning {
    [_session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count) {
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        
        [self stopRunning];
        if (self.resultBlock) {
            self.resultBlock(object.stringValue);
        }
    }
}

#pragma mark - torch
- (BOOL)hasTorch {
    return _device.hasTorch;
}

- (void)setTorchSwitch:(BOOL)torchSwitch {
    _torchSwitch = torchSwitch;
    NSError *error;
    [_device lockForConfiguration:&error];
    if (error) return;
    [_device setTorchMode:(torchSwitch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff)];
    [_device unlockForConfiguration];
}

@end
