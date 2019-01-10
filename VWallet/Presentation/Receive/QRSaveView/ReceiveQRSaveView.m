//
// ReceiveQRSaveView.m
//  Wallet
//
//  All rights reserved.
//

#import "ReceiveQRSaveView.h"
#import "Language.h"
#import "VColor.h"

@interface ReceiveQRSaveView ()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ReceiveQRSaveView

- (instancetype)initWithData:(NSDictionary *)data {
    self = [[[UINib nibWithNibName:@"ReceiveQRSaveView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    self.frame = CGRectMake(0, 0, 375, 500);
    self.backgroundColor = VColor.orangeColor;
    self.descLabel.text = VLocalize(@"account.receive.scan.qr.desc");
    self.descLabel1.text = VLocalize(@"account.receive.address");
    self.addressLabel.text = data[@"address"];
    self.qrImgView.image = data[@"qr_img"];
    return self;
}

- (UIImage *)toImage {
    [UIApplication.sharedApplication.keyWindow insertSubview:self atIndex:0];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self removeFromSuperview];
    return img;
}

@end
