//
// AddressesTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AddressesTableViewController.h"
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
#import "AddressDetailViewController.h"
#import "NSString+Decimal.h"


@interface AddressesTableViewController ()

@property (nonatomic, copy) NSArray<SectionItem *> *contentData;

@end

@implementation AddressesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.addresses");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorColor = VColor.rootViewBgColor;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:ArrowTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:ArrowTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NormalTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:NormalTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:SectionHeaderViewIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initContentData];
    [self.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressDetailViewController *vc    = [VStoryboard.Address instantiateViewControllerWithIdentifier:@"AddressDetailViewController"];
    if (indexPath.section == 0) {
        [vc updateAccout:WalletMgr.shareInstance.accounts[indexPath.row]];
    } else if (indexPath.section == 1) {
        [vc updateAccout:WalletMgr.shareInstance.monitorAccounts[indexPath.row]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initContentData {
    NSMutableArray <CellItem *> *cellItems1 = @[].mutableCopy;
    for (Account *acc in WalletMgr.shareInstance.accounts) {
        NSString *amountStr = [NSString stringWithDecimal:(acc.totalBalance * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
        [cellItems1 addObject:VCellItem(@"", ArrowTableViewCellIdentifier, acc.originAccount.address, @"", @"", @{@"secondTitle": ([NSString stringWithFormat:@"%@ VSYS", amountStr])})];
    }
    
    NSMutableArray <CellItem *> *cellItems2 = @[].mutableCopy;
    for (Account *acc in WalletMgr.shareInstance.monitorAccounts) {
        NSString *amountStr = [NSString stringWithDecimal:(acc.totalBalance * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
        [cellItems2 addObject:VCellItem(@"", ArrowTableViewCellIdentifier, acc.originAccount.address, @"", @"", @{@"secondTitle": ([NSString stringWithFormat:@"%@ VSYS", amountStr])})];
    }
    
    NSArray *contentData = @[
                             VSectionItem(VLocalize(@"addresses.section1.title"), cellItems1),
                             VSectionItem(VLocalize(@"addresses.section2.title"), cellItems2),
                             ];
    self.contentData = contentData;
}
@end
