//
// AddressDetailViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AddressDetailViewController.h"
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
#import "VStoryboard.h"
#import "VThemeButton.h"
#import "AlertViewController.h"
#import "AlertNavController.h"
#import "ToastPasswordViewController.h"
#import <Masonry/Masonry.h>
#import "VAlertViewController.h"
#import "NSString+Decimal.h"
#import "PasswordAuthAlertViewController.h"
#import "PasswordInput.h"

@interface AddressDetailViewController ()
@property (nonatomic, copy) NSArray<SectionItem *> *contentData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Account *account;
@property (nonatomic, assign) BOOL showPrivateKey;
@property (nonatomic, assign) BOOL showSeed;
@property (weak, nonatomic) IBOutlet VThemeButton *deleteBtn;
@end

@implementation AddressDetailViewController

- (void)updateAccout: (Account *)account {
    self.account = account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.address.detail");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.view.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorColor = VColor.rootViewBgColor;
    
    [self initContentData];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:ArrowTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:ArrowTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NormalTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:NormalTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:SectionHeaderViewIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    [self.deleteBtn setTitle:VLocalize(@"delete") forState:UIControlStateNormal];
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
        return nil;
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
    
    return nil;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    if ([item.identifier isEqualToString:@"address"] || [item.identifier isEqualToString:@""]) {
        return 96;
    } else {
        return 72;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    
    if ([item.identifier isEqualToString:@"address"]) {
        UIPasteboard.generalPasteboard.string = self.account.originAccount.address;
        [self remindWithMessage:VLocalize(@"tip.copy.success")];
    }
    
    if ([item.identifier isEqualToString:@"public"]) {
        UIPasteboard.generalPasteboard.string = self.account.originAccount.publicKey;
        [self remindWithMessage:VLocalize(@"tip.copy.success")];
    }
    
    PasswordInput *model = [[PasswordInput alloc] init];
    model.placeholder = VLocalize(@"password.auth.detail");
    __weak typeof(self) weakSelf = self;
    PasswordAuthAlertViewController *vc = [[PasswordAuthAlertViewController alloc] initWithModel:model];
    
    if ([item.identifier isEqualToString:@"private"]) {
        if (self.showPrivateKey) {
            UIPasteboard.generalPasteboard.string = self.account.originAccount.privateKey;
            [self remindWithMessage:VLocalize(@"tip.copy.success")];
        } else {
            model.title = VLocalize(@"tip.address.detail.private.key.title");
            [vc showPasswordAlert:self result:^(BOOL success) {
                if (success) {
                    weakSelf.showPrivateKey = !self.showPrivateKey;
                    [weakSelf initContentData];
                    [weakSelf.tableView reloadData];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }
    
    if ([item.identifier isEqualToString:@"seed"]) {
        if (self.showSeed) {
            UIPasteboard.generalPasteboard.string = WalletMgr.shareInstance.seed;
            [self remindWithMessage:VLocalize(@"tip.copy.success")];
        } else {
            model.title = VLocalize(@"tip.address.detail.mnemonic.title");
            [vc showPasswordAlert:self result:^(BOOL success) {
                if (success) {
                    self.showSeed = !self.showSeed;
                    [self initContentData];
                    [self.tableView reloadData];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }
    
    [self initContentData];
    [self.tableView reloadData];
}

- (void)initContentData {
    NSMutableArray *contentData = @[].mutableCopy;
    NSString *amountStr = [NSString stringWithDecimal:[NSString getAccurateDouble:self.account.availableBalance unity:VsysVSYS] maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
    NSArray <CellItem *> *cellItems1 = @[
         VCellItem(@"address", ArrowTableViewCellIdentifier, self.account.originAccount.address, @"", @"", @{@"secondTitle": ([NSString stringWithFormat:@"%@ VSYS", amountStr])})
                                         ];
    NSArray <CellItem *> *cellItems2 = @[
         VCellItem(@"public", ArrowTableViewCellIdentifier, self.account.originAccount.publicKey, @"", @"", @{})
                                         ];
    
    [contentData addObject:VSectionItem(VLocalize(@"address.detail.section1.title"), cellItems1)];
    [contentData addObject:VSectionItem(VLocalize(@"address.detail.section2.title"), cellItems2)];
    
    if (![self.account.originAccount.privateKey isEqualToString:@""]) {
        NSArray <CellItem *> *cellItems3 = @[
                                             VCellItem(@"private", ArrowTableViewCellIdentifier, self.showPrivateKey ? self.account.originAccount.privateKey : VLocalize(@"address.detail.cell.hide.title"), @"", @"", @{})
                                             ];
        NSArray <CellItem *> *cellItems4 = @[
                                             VCellItem(@"seed", ArrowTableViewCellIdentifier, self.showSeed ? WalletMgr.shareInstance.seed : VLocalize(@"address.detail.cell.hide.title"), @"", @"", @{})
                                             ];
        [contentData addObject:VSectionItem(VLocalize(@"address.detail.section3.title"), cellItems3)];
        [contentData addObject:VSectionItem(VLocalize(@"address.detail.section4.title"), cellItems4)];
        self.deleteBtn.hidden = YES;
    } else {
        self.deleteBtn.hidden = NO;
    }
    self.contentData = contentData.copy;
}

- (IBAction)deleteBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    VAlertViewController *vc = [[VAlertViewController alloc] initWithTitle:VLocalize(@"tip.address.detail.delete.title") secondTitle:VLocalize(@"") contentView:^(UIStackView * _Nonnull view) {
        
    } cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"delete") cancel:^{
        
    } confirm:^{
        [WalletMgr.shareInstance deleteMonitorAccount:weakSelf.account];
        if (weakSelf.popToRoot) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
