//
//  ReceiveViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ReceiveViewController.h"
#import "Account.h"
#import "Language.h"
#import "MediaManager.h"
#import "VColor.h"
#import "UIImage+QRCode.h"
#import "NSString+Decimal.h"
#import "UIViewController+Alert.h"
//#import "ReceiveSetAmountAlertController.h"
#import "ReceiveSetAmountViewController.h"
#import "ReceiveQRSaveView.h"

@interface ReceiveViewController ()

@property (nonatomic, weak) Account *account;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountLabelHeightLC;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *setAmountBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveImgBtn;

@end

@implementation ReceiveViewController

- (instancetype)initWithAccount:(Account *)account {
    if (self = [super init]) {
        self.account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.transaction.receive");
    self.view.backgroundColor = VColor.themeColor;
    self.descLabel.text = VLocalize(@"account.receive.qr.copy.tip");
    self.descLabel1.text = VLocalize(@"account.receive.address");
    [self setAmount:0];
    self.addressLabel.text = self.account.originAccount.address;
    [self.setAmountBtn setTitle:VLocalize(@"account.receive.specific.amount") forState:UIControlStateNormal];
    [self.saveImgBtn setTitle:VLocalize(@"account.receive.save.image") forState:UIControlStateNormal];
    
    self.amountLabel.text = @"";
    self.amountLabelHeightLC.constant = 0;
}

- (void)setAmount:(int64_t)amount {
    if (amount < 0) {
        amount = 0;
    }
    self.amountLabel.text = [NSString stringWithDecimal:(amount * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:0 trimTrailing:YES];
    self.amountLabelHeightLC.constant = 46;
    NSDictionary *dict = @{@"protocol": VsysProtocol,
                           @"api": @(VsysApi),
                           @"opc": VsysOpcTypeAccount,
                           @"address": self.account.originAccount.address,
                           @"amount": @((long)([self.amountLabel.text doubleValue] * VsysVSYS)),
                           };
    NSString *qrcodeStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    self.qrCodeImgView.image = [UIImage imageWithQrCodeStr:qrcodeStr];
}

- (IBAction)qrcodeCopyEvent:(id)sender {
    UIPasteboard.generalPasteboard.string = self.account.originAccount.address;
    [self remindWithMessage:VLocalize(@"tip.account.address.copy.success")];
}

- (IBAction)setAmount {
    __weak typeof(self) weakSelf = self;
    ReceiveSetAmountViewController *setAmountVC = [[ReceiveSetAmountViewController alloc] initWithResult:^(int64_t amount) {
        [weakSelf setAmount:amount];
    }];
    [self.navigationController pushViewController:setAmountVC animated:YES];
}

- (IBAction)saveImg {
    __weak typeof(self) weakSelf = self;
    [MediaManager checkPhotoLibraryPermissionsWithCallVC:self result:^{
        NSDictionary *data = @{@"address":weakSelf.account.originAccount.address, @"qr_img":weakSelf.qrCodeImgView.image};
        ReceiveQRSaveView *qrSaveView = [[ReceiveQRSaveView alloc] initWithData:data];
        UIImage *img = qrSaveView.toImage;
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        /*
        UIGraphicsBeginImageContextWithOptions(weakSelf.contentView.bounds.size, NO, 0);
        [weakSelf.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
         */
        [self remindWithMessage:VLocalize(@"tip.save.image.success")];
    }];
}

@end
