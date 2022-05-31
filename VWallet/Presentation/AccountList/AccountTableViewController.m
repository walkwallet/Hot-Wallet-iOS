//
// AccountTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountTableViewController.h"
#import "AccountTableViewCell.h"
#import "AddAccountTableViewCell.h"
#import "AccountDetailViewController.h"
#import "WalletMgr.h"
#import "AppState.h"
#import "UIViewController+Alert.h"
#import "Language.h"
#import "VStoryboard.h"
#import "AddMonitorAddressViewController.h"
#import "MediaManager.h"
#import "VColor.h"
#import "QRScannerViewController.h"
#import "VAlertViewController.h"

static NSString *const AddressCellIdentifier = @"AccountTableViewCell";
static NSString *const AddCellIdentifier = @"AddAccountTableViewCell";

@interface AccountTableViewController ()

@property (nonatomic, assign) AccountType accountType;

@property (nonatomic, readonly) NSArray<Account *> *showDataArray;

@end

@implementation AccountTableViewController

- (instancetype)initWithAccountType:(AccountType)accountType {
    if (self = [super init]) {
        self.accountType = accountType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    VColor.sharedInstance.coldTheme = self.accountType == AccountTypeMonitor;
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.accountType == AccountTypeMonitor && WalletMgr.shareInstance.monitorAccounts.count == 0 && !AppState.shareInstance.monitorAccontFirstAlert) {
        VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.monitor.title") secondTitle:VLocalize(@"tip.monitor.detail") contentView:^(UIStackView * _Nonnull view) {
            
        } cancelTitle:@"" confirmTitle:VLocalize(@"isee") cancel:^{
            
        } confirm:^{
            
        }];
        [self presentViewController:vc animated:YES completion:nil];
        AppState.shareInstance.monitorAccontFirstAlert = YES;
    }
}

- (void)initView {
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 8, 0);
    self.tableView.rowHeight = 149;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:AddressCellIdentifier bundle:nil] forCellReuseIdentifier:AddressCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:AddCellIdentifier bundle:nil] forCellReuseIdentifier:AddCellIdentifier];
    
}

- (NSArray *)showDataArray {
    switch (self.accountType) {
        case AccountTypeWallet:
            return WalletMgr.shareInstance.accounts;
        case AccountTypeMonitor:
            return WalletMgr.shareInstance.monitorAccounts;
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.showDataArray.count) {
        AddAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier forIndexPath:indexPath];
        cell.accountType = self.accountType;
        return cell;
    }
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressCellIdentifier forIndexPath:indexPath];
    Account *account = self.showDataArray[indexPath.row];
    account.accountType = self.accountType;
    account.sort = indexPath.row + 1;
    cell.account = self.showDataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= self.showDataArray.count) {
        switch (self.accountType) {
            case AccountTypeMonitor:
            {
                
                __weak typeof(self) weakSelf = self;
//                [self actionAheetWithSelectedIndex:-1 withActionDatas:@[VLocalize(@"tip.monitor.address.add.title1"), VLocalize(@"tip.monitor.address.add.title2")] handler:^(NSInteger index) {
                AddMonitorAddressViewController *vc = [VStoryboard.Address instantiateViewControllerWithIdentifier:@"AddMonitorAddressViewController"];
//                    if (index == 0) {
                [MediaManager checkCameraPermissionsWithCallVC:self result:^ {
                    QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:VLocalize(@"tip.qrcode.unsupported.types") result:^(NSString * _Nullable qrCode) {
                        vc.configureBlock = ^(AddMonitorAddressViewController * _Nonnull vc) {
                            [vc processWithQrCode:qrCode];
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }];
                    [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
                }];
//                    } else {
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                    return ;
//                }];
                break;
            }
            case AccountTypeWallet:
            {
                __weak typeof(self) weakSelf = self;
                VAlertViewController *vc = [[VAlertViewController alloc] initWithIconName:@"ico_wallet_circle" title:VLocalize(@"tip.account.add.title") secondTitle:VLocalize(@"tip.account.add.detail") contentView:^(UIStackView * _Nonnull view) {
                    
                } cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"add") cancel:^{
                    
                } confirm:^{
                    if (weakSelf.accountType == AccountTypeWallet) {
                        [weakSelf addAccountWithCount:1];
                    }
                }];
                [self presentViewController:vc animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
        return;
    }
    AccountDetailViewController *detailVC = [[AccountDetailViewController alloc] initWithAccount:self.showDataArray[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)addAccountWithCount:(NSInteger)count {
    if (count <= 0) return;
    NSMutableArray *newAccountArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *newAccountSeedArray = [NSMutableArray arrayWithCapacity:count];
    NSInteger accountCount = WalletMgr.shareInstance.nonce + 1;
    for (NSInteger i = accountCount; i < accountCount + count; i++) {
        Account *account = [[Account alloc] init];
        account.originAccount = [WalletMgr.shareInstance.wallet generateAccount:i];
        [newAccountArray addObject:account];
        [newAccountSeedArray addObject:account.originAccount.accountSeed];
    }
    NSArray *originAccountArray = WalletMgr.shareInstance.accounts ?: @[];
    NSArray *originAccountSeedArray = WalletMgr.shareInstance.accountSeeds ?: @[];
    WalletMgr.shareInstance.accounts = [originAccountArray arrayByAddingObjectsFromArray:newAccountArray];
    WalletMgr.shareInstance.accountSeeds = [originAccountSeedArray arrayByAddingObjectsFromArray:newAccountSeedArray];
    WalletMgr.shareInstance.nonce += count;
    NSError *error;
    if (AppState.shareInstance.autoBackupEnable) {
        error = [WalletMgr.shareInstance saveToStorage];
    }
    if (error) {
        WalletMgr.shareInstance.accounts = originAccountArray;
        WalletMgr.shareInstance.accountSeeds = originAccountSeedArray;
        WalletMgr.shareInstance.nonce = WalletMgr.shareInstance.accounts.count - 1;
        NSLog(@" - create account fail - error = %@", error);
    } else {
        [self.tableView reloadData];
    }
}

@end
