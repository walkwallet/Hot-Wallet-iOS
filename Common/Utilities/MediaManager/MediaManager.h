//
//  MediaManager.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaManager : NSObject

+ (void)checkCameraPermissionsWithCallVC:(UIViewController *_Nullable)callVC result:(void(^_Nullable)(void))result;

+ (void)checkPhotoLibraryPermissionsWithCallVC:(UIViewController *_Nullable)callVC result:(void(^_Nullable)(void))result;

@end

NS_ASSUME_NONNULL_END
