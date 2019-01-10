//
//  MediaManager.m
//  Wallet
//
//  All rights reserved.
//

#import "MediaManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "Language.h"

@implementation MediaManager

+ (void)checkCameraPermissionsWithCallVC:(UIViewController *)callVC result:(void (^)(void))result {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (callVC) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:VLocalize(@"tip.no.available.camera") message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:VLocalize(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
            [callVC presentViewController:alertC animated:YES completion:nil];
        }
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted && result) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // wait seconds for 'waitUntilAllTasksAreFinished' error
                        result();
                    });
                }
            }];
        } break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            if (callVC) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:VLocalize(@"tip.unable.open.camera") preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:VLocalize(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
                [alertC addAction:[UIAlertAction actionWithTitle:VLocalize(@"system.settings.go.to") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }]];
                [callVC presentViewController:alertC animated:YES completion:nil];
            }
        } break;
        case AVAuthorizationStatusAuthorized: {
            if (result) {
                result();
            }
        } break;
    }
}

+ (void)checkPhotoLibraryPermissionsWithCallVC:(UIViewController *)callVC result:(void(^)(void))result {
    switch (PHPhotoLibrary.authorizationStatus) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized && result) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // wait seconds for 'waitUntilAllTasksAreFinished' error
                        result();
                    });
                }
            }];
        } break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: {
            if (callVC) {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:VLocalize(@"tip.unable.open.album") preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:VLocalize(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
                [alertC addAction:[UIAlertAction actionWithTitle:VLocalize(@"system.settings.go.to") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }]];
                [callVC presentViewController:alertC animated:YES completion:nil];
            }
        } break;
        case PHAuthorizationStatusAuthorized: {
            if (result) {
                result();
            }
        } break;
    }
}

@end
