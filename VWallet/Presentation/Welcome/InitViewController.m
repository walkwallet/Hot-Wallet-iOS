//
// InitViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "InitViewController.h"
#import "Language.h"
#import "VStoryboard.h"
#import <Masonry/Masonry.h>
#import "VColor.h"
#import "WalletMgr.h"
#import "WindowManager.h"
@import Vsys;
#import "UIViewController+Alert.h"
#import "PasswordSettingsViewController.h"
#import "MnemonicWordImportViewController.h"
#import "MnemonicWordBackupViewController.h"
#import "ResultViewController.h"
#import "ChooseNetworkViewController.h"
#import "VStoryBoard.h"
#import "AppDelegate.h"
#import "VAlertViewController.h"

@interface InitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *importBtn;
@property (nonatomic, assign) BOOL hasShowAlert;
@end

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initView {
    self.pageTitleLabel.text = VLocalize(@"welcome.title");
    self.pageSubtitleLabel.text = VLocalize(@"welcome.detail");
    [self.createBtn setTitle:VLocalize(@"welcome.btn1.title") forState:UIControlStateNormal];
    [self.importBtn setTitle:VLocalize(@"welcome.btn2.title") forState:UIControlStateNormal];
    
    self.importBtn.alpha = 0.f;
    self.createBtn.alpha = 0.f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.hasShowAlert) {
        self.hasShowAlert = YES;
        VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.welcome.title") secondTitle:VLocalize(@"tip.welcome.detail") contentView:^(UIStackView * _Nonnull view) {
            
        } cancelTitle:@"" confirmTitle:VLocalize(@"tip.welcome.btn.title") cancel:^{
            
        } confirm:^{
            self.importBtn.alpha = 1.f;
            self.createBtn.alpha = 1.f;
        }];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)createBtnClick {
    __weak typeof(self) weakSelf = self;
    ChooseNetworkViewController *vc = [VStoryboard.Network instantiateInitialViewController];
    [vc setNextBlock:^{
        PasswordSettingsViewController *setPwdVC = [[PasswordSettingsViewController alloc] initWithTitle:VLocalize(@"nav.title.password.create") success:^(NSString * _Nonnull password) {
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            WalletMgr.shareInstance.password = password;
            WalletMgr.shareInstance.seed = VsysGenerateSeed();
            WalletMgr.shareInstance.accountSeeds = @[];
            NSError *error = [WalletMgr.shareInstance generateSalt:password];
            if (error) {
                NSLog(@"generateSalt error: %@", error);
                return;
            }
            error = [WalletMgr.shareInstance saveToStorage];
            if (error) {
                NSLog(@"save storage error: %@", error);
                return;
            }
            [weakSelf createWalletSuccess];
        }];
        [weakSelf.navigationController pushViewController:setPwdVC animated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createWalletSuccess {
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:VLocalize(@"wallet.create.success.title") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32]}];
    NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:VLocalize(@"wallet.create.success.detail") attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightLight]}];
    ResultParameter *parameter = [ResultParameter paramterWithImgResourceName:@"ico_success_tip" attrTitle:attrTitle attrMessage:attrMessage titleMessageSpecing:8];
    [parameter setOperateBtnTitle:VLocalize(@"wallet.create.success.btn1.title")];
    [parameter setSecondOperateBtnTitle:VLocalize(@"wallet.create.success.btn2.title")];
    parameter.explicitDismiss = YES;
    ResultViewController *resultVC = [[ResultViewController alloc] initWithResultParameter:parameter];
    __weak typeof(resultVC) weakResultVC = resultVC;
    [parameter setOperateBlock:^{
        NSArray<NSString *> *mnemonicWordArray = [WalletMgr.shareInstance.seed componentsSeparatedByString:@" "];
        MnemonicWordBackupViewController *backupVC = [[MnemonicWordBackupViewController alloc] initWithMnemonicWordArray:mnemonicWordArray createWallet:YES];
        [weakResultVC presentViewController:backupVC.naviVC animated:YES completion:nil];
    }];
    [parameter setSecondOperateBlock:^{
        [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
    }];
    [WindowManager changeToRootViewController:resultVC];
}

- (IBAction)importBtnClick {
    __weak typeof(self) weakSelf = self;
    ChooseNetworkViewController *vc = [VStoryboard.Network instantiateInitialViewController];
    [vc setNextBlock:^{
        MnemonicWordImportViewController *vc = [VStoryboard.Phrase instantiateViewControllerWithIdentifier:NSStringFromClass([MnemonicWordImportViewController class])];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
