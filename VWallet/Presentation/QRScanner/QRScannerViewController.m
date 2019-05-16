//
// QRScannerViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "QRScannerViewController.h"
#import <Masonry.h>

#import "Language.h"
#import "QRScanner.h"
#import "QRScannerMaskView.h"
#import "VColor.h"
#import "VAlertViewController.h"

@interface QRScannerViewController ()

@property (nonatomic, copy) NSString *qrRegexStr;
@property (nonatomic, copy) NSString *noMatchTipText;
@property (nonatomic, strong) void(^resultBlock)(NSString *__nullable);

@property (nonatomic, strong) QRScanner *qrScanner;
@property (nonatomic, strong) QRScannerMaskView *qrScannerMaskView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *torchBtn;

@property (nonatomic, assign) UIStatusBarStyle beforeStatusBarStyle;

@end

@implementation QRScannerViewController

- (instancetype)initWithQRRegexStr:(NSString *)qrRegexStr noMatchTipText:(NSString *)noMatchTipText result:(void (^)(NSString * _Nullable))result {
    if (self = [super init]) {
        self.qrRegexStr = qrRegexStr;
        self.noMatchTipText = noMatchTipText;
        self.resultBlock = result;
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (CGRect)getRectOfInterest {
    CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds);
    CGFloat interestSize = MIN(width, height) * 0.7;
    CGFloat x = (width - interestSize) / 2 / width;
    CGFloat y = ((height - interestSize) / 2) / height;
    CGFloat w = interestSize / width;
    CGFloat h = interestSize / height;
//    return CGRectMake(y, x, w, h);
    return CGRectMake(x, y, w, h);
}

- (QRScanner *)qrScanner {
    if (!_qrScanner) {
        __weak typeof(self) weakSelf = self;
        _qrScanner = [[QRScanner alloc] initWithResult:^(NSString * _Nullable qrCode) {
            [weakSelf scanResult:qrCode];
        }];
    }
    return _qrScanner;
}

- (void)initView {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationItem.title = VLocalize(@"scan_qr_code");
    self.view.backgroundColor = UIColor.blackColor;
    
    _contentView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:_contentView];
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        if (@available(iOS 11.0, *)) {
            [self.navigationItem setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
        }
        CGRect contentFrame = _contentView.frame;
        contentFrame.origin.y = -(CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame) + 44.f);
        _contentView.frame = contentFrame;
    } else {
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame), 58.f, 44.f)];
        [closeBtn setImage:[UIImage imageNamed:@"ico_close"] forState:UIControlStateNormal];
        [closeBtn setTintColor:UIColor.whiteColor];
        [self.view addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.qrScanner.rectOfInterest = [self getRectOfInterest];
    [self.qrScanner initSettings];
    self.qrScanner.layer.frame = _contentView.bounds;
    [_contentView.layer addSublayer:self.qrScanner.layer];
    
    _qrScannerMaskView = [[QRScannerMaskView alloc] initWithFrame:_contentView.bounds];
    _qrScannerMaskView.rectOfInterest = [self getRectOfInterest];
    [_contentView addSubview:_qrScannerMaskView];
    
    if (self.qrScanner.hasTorch) {
        _torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _torchBtn.backgroundColor = UIColor.grayColor;
        _torchBtn.tintColor = VColor.grayColor;
        _torchBtn.layer.cornerRadius = 24.f;
        [_torchBtn setImage:[UIImage imageNamed:@"ico_torch"] forState:UIControlStateNormal];
        [self.view addSubview:_torchBtn];
        __weak typeof(self) weakSelf = self;
        [_torchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(48.f, 48.f));
            make.centerX.mas_equalTo(0);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom).mas_offset(-32.f);
            } else {
                make.bottom.mas_equalTo(-32.f);
            }
        }];
        [_torchBtn addTarget:self action:@selector(torchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)scanResult:(NSString *)qrCode {
    [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
    [self.qrScannerMaskView pauseScanAnimation];
    NSString *alertMsg;
    if (_qrRegexStr.length && _noMatchTipText.length) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _qrRegexStr];
        if (![pre evaluateWithObject:qrCode]) {
            alertMsg = _noMatchTipText;
        }
    }

    if (alertMsg.length) {
        __weak typeof(self) weakSelf = self;
        VAlertViewController *alert = [[VAlertViewController alloc] initWithTitle:alertMsg secondTitle:nil contentView:nil cancelTitle:VLocalize(@"back") confirmTitle:VLocalize(@"ok") cancel:^{
            [weakSelf backAnimated:YES];
        } confirm:^{
            [weakSelf.qrScanner startRunning];
            [weakSelf.qrScannerMaskView startScanAnimation];
        }];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self backAnimated:NO];
    if (_resultBlock) {
        _resultBlock(qrCode);
    }
}

- (void)torchBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.qrScanner.torchSwitch = btn.selected;
    if (btn.selected) {
        btn.tintColor = UIColor.whiteColor;
        btn.backgroundColor = VColor.themeColor;
    } else {
        btn.backgroundColor = UIColor.grayColor;
        btn.tintColor = VColor.grayColor;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.beforeStatusBarStyle = UIApplication.sharedApplication.statusBarStyle;
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.qrScanner startRunning];
    [self.qrScannerMaskView startScanAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIApplication.sharedApplication.statusBarStyle = self.beforeStatusBarStyle;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.torchBtn.selected) {
        [self torchBtnClick:self.torchBtn];
    }
    [self.qrScanner stopRunning];
    [self.qrScannerMaskView stopScanAnimation];
}

- (void)closeBtnClick {
    [self backAnimated:YES];
}

- (void)backAnimated:(BOOL)animated {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

@end
