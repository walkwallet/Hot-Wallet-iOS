//
// TransactionQrcodeViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TransactionQrcodeViewController.h"
#import "NSString+Decimal.h"
#import "UIImage+QRCode.h"
#import "Language.h"
#import "VColor.h"
#import "Token.h"
#import "TokenMgr.h"
#import "Transaction.h"

@interface TransactionQrcodeViewController ()

@property (nonatomic, strong) Transaction *transaction;
@property (nonatomic, strong) VsysTransaction *oriTran;
@property (nonatomic, strong) Account *account;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomNoteLabel;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *fullContent;
@property (weak, nonatomic) IBOutlet UIView *leftWrapView;
@property (weak, nonatomic) IBOutlet UIView *rightWrapView;

@end

@implementation TransactionQrcodeViewController

- (instancetype)initWithOriginTransaction:(VsysTransaction *)transaction account:(Account *)account {
    if (self = [super init]) {
        self.oriTran = transaction;
        self.account = account;
    }
    return self;
}

- (instancetype)initWithTransaction:(Transaction *)transaction account:(Account *)account {
    if (self = [super init]) {
        self.transaction = transaction;
        self.oriTran = transaction.originTransaction;
        self.account = account;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)clickPre:(id)sender {
    if (self.current > 1) {
        self.current--;
        [self render:self.current];
    }
}

- (IBAction)clickNext:(id)sender {
    if (self.current < self.total) {
        self.current++;
        [self render:self.current];
    }
}

- (void)renderQrcode {
    self.current = 1;
    self.total = 1;
    NSMutableDictionary *dict = @{@"protocol": VsysProtocol}.mutableCopy;
    if (self.transaction.transactionType == VsysTxTypeContractRegister) {
        // create token transaction
        dict[@"api"] = @(VsysTransactionOldApi);
        dict[@"opc"] = VsysOpcTypeContract;
        dict[@"address"] = self.transaction.senderAddress;
        dict[@"contract"] = VsysBase58EncodeToString(self.transaction.originTransaction.contract);
        dict[@"description"] = self.transaction.originTransaction.description;
        dict[@"contractInit"] = VsysBase58EncodeToString(self.transaction.originTransaction.data);
        VsysContract *c = [VsysContract new];
        [c decodeRegister:self.transaction.originTransaction.data];
        dict[@"contractInitTextual"] = [NSString stringWithFormat:@"init(max=%lld,unity=%lld,tokenDescription='%@')", c.max / c.unity, c.unity, c.tokenDescription];
        NSString *s = @"";
        if ([VsysBase58EncodeToString(self.transaction.originTransaction.contract) isEqualToString:VsysConstContractSplit]) {
            s = VLocalize(@"scan.qrcode.support.split");
        }
        dict[@"contractInitExplain"] = [NSString stringWithFormat:VLocalize(@"scan.qrcode.explain"), s, c.max / c.unity];
    }else if (self.transaction.transactionType == VsysTxTypeContractExecute) {
        // execute function transaction
        dict[@"api"] = @(VsysTransactionOldApi);
        dict[@"opc"] = VsysOpcTypeFunction;
        dict[@"address"] = self.transaction.senderAddress;
        dict[@"attachment"] = self.transaction.originTransaction.description;
        dict[@"contractId"] = self.transaction.originTransaction.contractId;
        dict[@"functionId"] = @(self.transaction.originTransaction.funcIdx);
        dict[@"function"] = VsysBase58EncodeToString(self.transaction.originTransaction.data);
        Token *token = [TokenMgr.shareInstance getTokenByAddress:self.transaction.senderAddress tokenId:VsysContractId2TokenId(self.transaction.originTransaction.contractId, 0)];
        if ([self.transaction.contractFuncName isEqualToString:VsysActionSend]) {
            dict[@"functionExplain"] = [NSString stringWithFormat:VLocalize(@"scan.qrcode.function.explain.send"), [NSString stringWithDecimal:[NSString getAccurateDouble:self.transaction.originTransaction.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], [NSString isNilOrEmpty:token.name] ? @"tokens" : token.name, self.transaction.originTransaction.recipient];
        }else if ([self.transaction.contractFuncName isEqualToString:VsysActionIssue]) {
            dict[@"functionExplain"] = [NSString stringWithFormat:VLocalize(@"scan.qrcode.function.explain.issue"), [NSString stringWithDecimal:[NSString getAccurateDouble:self.transaction.originTransaction.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], [NSString isNilOrEmpty:token.name] ? @"tokens" : token.name];
        }else if ([self.transaction.contractFuncName isEqualToString:VsysActionDestroy]) {
            dict[@"functionExplain"] = [NSString stringWithFormat:VLocalize(@"scan.qrcode.function.explain.burn"), [NSString stringWithDecimal:[NSString getAccurateDouble:self.transaction.originTransaction.amount unity:token.unity] maxFractionDigits:[NSString getDecimal:token.unity] minFractionDigits:2 trimTrailing:YES], [NSString isNilOrEmpty:token.name] ? @"tokens" : token.name];
        }
    }else {
        // normal transaction
        if (self.oriTran.amount > (pow(2, 53) - 1) && self.oriTran.amount % 100 > 0) {
            dict[@"api"] = @(VsysTransactionNewApi);
        }else {
            dict[@"api"] = @(VsysTransactionOldApi);
        }
        dict[@"opc"] = VsysOpcTypeTransction;
        if (self.oriTran.txType != 0) {
            dict[@"transactionType"] = @(self.oriTran.txType);
        }
        
        if (self.oriTran.txId) {
            dict[@"txId"] = self.oriTran.txId;
        }
        
        if (self.oriTran.amount != 0) {
            dict[@"amount"] = @(self.oriTran.amount);
        }
        
        if (self.account.originAccount.publicKey) {
            dict[@"senderPublicKey"] = self.account.originAccount.publicKey;
        }
        
        if (self.oriTran.recipient) {
            dict[@"recipient"] = self.oriTran.recipient;
        }
        
        dict[@"attachment"] = [[NSString alloc] initWithData:VsysBase58Encode(self.oriTran.attachment) encoding:NSUTF8StringEncoding];
    }
    
    // common obj
    if (self.oriTran.fee != 0) {
        dict[@"fee"] = @(self.oriTran.fee);
    }
    
    if (self.oriTran.feeScale != 0) {
        dict[@"feeScale"] = @(self.oriTran.feeScale);
    }
    
    if (self.oriTran.timestamp != 0) {
        if (self.oriTran.timestamp > 100000000000000) {
            dict[@"timestamp"] = @(self.oriTran.timestamp / 1000000);
        } else {
            dict[@"timestamp"] = @(self.oriTran.timestamp);
        }
    }
    self.fullContent = [self convertToJsonData:dict];
    if (self.current == 0) {
        self.current = 1;
    }
    [self render:self.current];
}

-(void)render:(NSInteger)pagination {
    if (self.transaction.originTransaction.txType == 8) {
        VsysQRCodePagination *pageContent = VsysGetPaginationContent(self.fullContent, self.current);
        self.current = pageContent.current;
        self.total = pageContent.total;
        self.bottomNoteLabel.hidden = NO;
        if (self.total > 1) {
            self.leftWrapView.hidden = NO;
            self.rightWrapView.hidden = NO;
        }
        if (self.current == 1) {
            self.leftWrapView.alpha = 0.2;
        }else {
            self.leftWrapView.alpha = 1;
        }
        if (self.current == self.total) {
            self.rightWrapView.alpha = 0.2;
        }else {
            self.rightWrapView.alpha = 1;
        }
        self.total = pageContent.total;
        self.bottomNoteLabel.text = [NSString stringWithFormat:VLocalize(@"scan.qrcode.page.bottom.note"), self.current, self.total];
        self.bottomNoteLabel.textColor = VColor.themeColor;
        UIImage *img = [UIImage imageWithQrCodeStr:pageContent.currentContent size:self.imageView.bounds.size.width];
        self.imageView.image = img;
    }else {
        UIImage *img = [UIImage imageWithQrCodeStr:self.fullContent size:self.imageView.bounds.size.width];
        self.imageView.image = img;
    }
}

-(NSString*) convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    return mutStr;
}
@end


