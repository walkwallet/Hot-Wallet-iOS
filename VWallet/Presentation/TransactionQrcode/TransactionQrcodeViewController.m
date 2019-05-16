//
// TransactionQrcodeViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionQrcodeViewController.h"
#import "UIImage+QRCode.h"
#import "Language.h"
#import "VColor.h"

@interface TransactionQrcodeViewController ()

@property (nonatomic, strong) VsysTransaction *transaction;
@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TransactionQrcodeViewController

- (instancetype)initWithTransaction:(VsysTransaction *)transaction account:(Account *)account {
    if (self = [super init]) {
        self.transaction = transaction;
        self.account = account;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self renderQrcode];
    self.detailLabel.text = VLocalize(@"transaction.qrcode.title");
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:VLocalize(@"transaction.qrcode.title") attributes:@{}];
    NSRange range = [str.string rangeOfString:@"Cold Wallet"];
    if (range.length == 0) {
        range = [str.string rangeOfString:@"冷钱包"];
    }
    [str addAttribute:NSForegroundColorAttributeName value:VColor.themeColor range:range];
    self.detailLabel.attributedText = str.copy;
}

- (void)renderQrcode {
    NSMutableDictionary *dict = @{@"protocol": VsysProtocol, @"api":@(VsysApi), @"opc": VsysOpcTypeTransction}.mutableCopy;
    if (self.transaction.txType != 0) {
        dict[@"transactionType"] = @(self.transaction.txType);
    }
    
    if (self.transaction.txId) {
        dict[@"txId"] = self.transaction.txId;
    }
    
    if (self.transaction.amount != 0) {
        dict[@"amount"] = @(self.transaction.amount);
    }
    
    if (self.transaction.fee != 0) {
        dict[@"fee"] = @(self.transaction.fee);
    }
    
    if (self.transaction.feeScale != 0) {
        dict[@"feeScale"] = @(self.transaction.feeScale);
    }
    
    if (self.transaction.timestamp != 0) {
        if (self.transaction.timestamp > 100000000000000) {
            dict[@"timestamp"] = @(self.transaction.timestamp / 1000000);
        } else {
            dict[@"timestamp"] = @(self.transaction.timestamp);
        }
    }
    
    if (self.account.originAccount.publicKey) {
        dict[@"senderPublicKey"] = self.account.originAccount.publicKey;
    }
    
    if (self.transaction.recipient) {
        dict[@"recipient"] = self.transaction.recipient;
    }
    
    // need send
    dict[@"attachment"] = [[NSString alloc] initWithData:VsysBase58Encode(self.transaction.attachment) encoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    UIImage *img = [UIImage imageWithQrCodeStr:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] size:self.imageView.bounds.size.width];
    self.imageView.image = img;
}




@end
