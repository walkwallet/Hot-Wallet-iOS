//
// SettingsTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "SettingsTableViewController.h"
#import "CellItem.h"
#import "Language.h"
#import "SectionItem.h"
#import "ArrowTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "NormalTableViewCell.h"
#import "SectionHeaderView.h"
#import "AppState.h"
#import "TouchIDTool.h"
#import "UIViewController+Alert.h"
#import "WalletMgr.h"
#import "VColor.h"
#import "DeviceLockTableViewController.h"
#import "AddressesTableViewController.h"
#import "VStoryboard.h"
#import "UIViewController+Alert.h"
#import "WindowManager.h"
#import "AlertViewController.h"
#import "AlertNavController.h"
#import "MnemonicWordBackupViewController.h"
#import "ToastPasswordViewController.h"
#import <Masonry/Masonry.h>
#import "UIViewController+NavigationBar.h"
#import "PasswordInput.h"
#import "VAlertViewController.h"
#import "PasswordAuthAlertViewController.h"

@interface SettingsTableViewController ()

@property (nonatomic, copy) NSArray<SectionItem *> *contentData;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = VLocalize(@"nav.title.settings");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorColor = VColor.separatorColor;
    
    [self initContentData];

    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:ArrowTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:ArrowTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NormalTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:NormalTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:SectionHeaderViewIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    VColor.sharedInstance.coldTheme = NO;
    [self changeToWhiteNavigationBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentData[section].cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentData.count <= indexPath.section || self.contentData[indexPath.section].cellItems.count <= indexPath.row) {
        return [UITableViewCell new];
    }

    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.type forIndexPath:indexPath];

    if (item.type == ArrowTableViewCellIdentifier) {
        [(ArrowTableViewCell *)cell setupCellItem:item];
        return cell;
    }
    
    if (item.type == NormalTableViewCellIdentifier) {
        [(NormalTableViewCell *)cell setupCellItem:item];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionItem *item = self.contentData[section];
    if (item.title.length > 0) {
        SectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        view.titleLabel.text = item.title;
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.contentData[section].title isEqualToString:@""]) {
        return 24;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    if ([item.identifier isEqualToString:@"auto_backup"] || [item.identifier isEqualToString:@"connection"]) {
        return 64;
    } else {
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    
    if ([item.identifier isEqualToString:@"device_lock"]) {
        DeviceLockTableViewController *vc = [[DeviceLockTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([item.identifier isEqualToString:@"addresses"]) {
        AddressesTableViewController *vc = [[AddressesTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([item.identifier isEqualToString:@"language"]) {
        NSArray *lans = [Language supportLanguages];
        NSInteger now = [lans indexOfObject: [Language.shareInstance getDescByType:Language.shareInstance.languageType]];
        [self actionSheetWithSelectedIndex:now withActionDatas:lans handler:^(NSInteger index) {
            Language.shareInstance.languageType = [Language.shareInstance getLanguaegTypeByDesc:lans[index]];
            UITabBarController *tabBarVC = VStoryboard.Main.instantiateInitialViewController;
            [tabBarVC setSelectedIndex:1];
            [WindowManager changeToRootViewController:tabBarVC];
        }];
    }
    
    if ([item.identifier isEqualToString:@"backup_mnemonic"]) {
        __weak typeof(self) weakSelf = self;
        PasswordInput *model = [[PasswordInput alloc] init];
        model.title = VLocalize(@"settings.section2.cell1.title");
        model.placeholder = VLocalize(@"password.auth.detail");
        PasswordAuthAlertViewController *vc = [[PasswordAuthAlertViewController alloc] initWithModel:model];
        [vc showPasswordAlert:self result:^(BOOL success) {
            if (success) {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                NSArray<NSString *> *mnemonicWordArray = [WalletMgr.shareInstance.seed componentsSeparatedByString:@" "];
                MnemonicWordBackupViewController *backupVC = [[MnemonicWordBackupViewController alloc] initWithMnemonicWordArray:mnemonicWordArray createWallet:NO];
                [weakSelf.navigationController pushViewController:backupVC animated:YES];
            }
        }];
        return;
    }
    
    if ([item.identifier isEqualToString:@"logout"]) {
        VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.logout.title") secondTitle:VLocalize(@"tip.logout.detail") contentView:^(UIStackView * _Nonnull view) {
            
        } cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"logout") cancel:^{
            
        } confirm:^{
            [WalletMgr.shareInstance logoutWallet];
            [WindowManager changeToRootViewController:VStoryboard.Generate.instantiateInitialViewController];
        }];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    if ([item.identifier isEqualToString:@"about"]) {
        UIViewController *vc = VStoryboard.About.instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

- (void)initContentData {
    NSArray <CellItem *> *cellItems1 = @[
      VCellItem(@"device_lock", ArrowTableViewCellIdentifier, VLocalize(@"settings.section1.cell1.title"), @"ico_lock", VLocalize(@""), @{}),
      ];
    
    NSArray <CellItem *> *cellItems2 = @[
     VCellItem(@"backup_mnemonic", ArrowTableViewCellIdentifier, VLocalize(@"settings.section2.cell1.title"), @"ico_backup_word", VLocalize(@"settings.section2.cell1.detail"), @{}),
     VCellItem(@"addresses", ArrowTableViewCellIdentifier, VLocalize(@"settings.section2.cell2.title"), @"ico_address", VLocalize(@""), @{})
     ];
    
    
    NSArray <CellItem *> *cellItems3 = @[
     VCellItem(@"", ArrowTableViewCellIdentifier, VLocalize(@"settings.section3.cell4.title"), @"ico_web", [WalletMgr.shareInstance networkDescription], (@{@"no_arrow":@(YES), @"descColor": VColor.textSecondColor})),
     VCellItem(@"language", ArrowTableViewCellIdentifier, VLocalize(@"settings.section3.cell1.title"), @"ico_language", [Language.shareInstance getDescByType:Language.shareInstance.languageType], (@{@"descColor": VColor.textSecondColor})),
     VCellItem(@"about", ArrowTableViewCellIdentifier, VLocalize(@"settings.section3.cell2.title"), @"ico_about", @"", @{})
     ];
    
    NSArray <CellItem *> *cellItems4 = @[
     VCellItem(@"logout", NormalTableViewCellIdentifier, VLocalize(@"settings.section3.cell3.title"), @"ico_cancel", @"", @{@"titleColor": VColor.redColor})
     ];
    
    NSArray *contentData = @[
         VSectionItem(VLocalize(@"settings.section1.title"), cellItems1),
         VSectionItem(VLocalize(@"settings.section2.title"), cellItems2),
         VSectionItem(VLocalize(@"settings.section3.title"), cellItems3),
         VSectionItem(@"", cellItems4),
    ];
    self.contentData = contentData;
}

@end
