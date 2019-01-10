//
// MnemonicWordBackupViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "MnemonicWordBackupViewController.h"
#import "Language.h"
#import "MnemonicWordCheckViewController.h"
#import "VNavigationController.h"
#import "UIViewController+NavigationBar.h"

@interface MnemonicWordBackupViewController ()

@property (nonatomic, strong) NSArray<NSString *> *mnemonicWordArrsy;
@property (nonatomic, assign) BOOL createWallet;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mnemonicWordsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation MnemonicWordBackupViewController

- (UINavigationController *)naviVC {
    VNavigationController *naviVC = [[VNavigationController alloc] initWithRootViewController:self];
//    naviVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    naviVC.colorStyle = 1;
    return naviVC;
}

- (instancetype)initWithMnemonicWordArray:(NSArray<NSString *> *)mnemonicWordArrsy createWallet:(BOOL)createWallet {
    if (self = [super init]) {
        self.mnemonicWordArrsy = mnemonicWordArrsy;
        self.createWallet = createWallet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.mnemonic.backup");
    _titleLabel.text = VLocalize(@"menmonic.backup.title");
    [_nextBtn setTitle:VLocalize(@"menmonic.backup.btn1.title") forState:UIControlStateNormal];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 12.f;
    ps.alignment = NSTextAlignmentCenter;
    _mnemonicWordsLabel.attributedText = [[NSAttributedString alloc] initWithString:[_mnemonicWordArrsy componentsJoinedByString:@"   "] attributes:@{NSParagraphStyleAttributeName : ps}];
    
    if (self.navigationController.childViewControllers.firstObject == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_close"] style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    }
}

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnClick {
    MnemonicWordCheckViewController *mnemonicWordCheckVC = [[MnemonicWordCheckViewController alloc] initWithMnemonicWordArray:self.mnemonicWordArrsy createWallet:self.createWallet];
    [self.navigationController pushViewController:mnemonicWordCheckVC animated:YES];
}

@end
