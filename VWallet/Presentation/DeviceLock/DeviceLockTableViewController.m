//
// DeviceLockTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "DeviceLockTableViewController.h"
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
#import "AppState.h"
#import <UserNotifications/UserNotifications.h>

@interface DeviceLockTableViewController () <VTableViewCellDelegate>

@property (nonatomic, copy) NSArray<SectionItem *> *contentData;

@end

@implementation DeviceLockTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *_Nonnull settings){
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusNotDetermined:
                break;
            case UNAuthorizationStatusDenied:
                break;
            case UNAuthorizationStatusAuthorized:
                break;
            default:
                break;
        }
    }];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.device.lock");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorColor = VColor.rootViewBgColor;
    UIEdgeInsets tableContentInsets = self.tableView.contentInset;
    tableContentInsets.top = 10;
    self.tableView.contentInset = tableContentInsets;
    
    [self initContentData];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:ArrowTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:ArrowTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NormalTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:NormalTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:SwitchTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:SwitchTableViewCellIdentifier];

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
    
    if (item.type == SwitchTableViewCellIdentifier) {
        [(SwitchTableViewCell *)cell setupCellItem:item];
        ((SwitchTableViewCell *)cell).delegate = self;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)cellActionWithType:(NSInteger)type item:(CellItem *)item {
    if ([item.identifier isEqualToString:@"touchID"]) {
        if ([item.dict[@"switcher"] boolValue]) {
            [TouchIDTool authSecureID:^(BOOL support, BOOL result) {
                NSMutableDictionary *dict = [item.dict mutableCopy];
                dict[@"switcher"] = @(result);
                [AppState.shareInstance setLockEnable:result];
                item.dict = [dict copy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        } else {
//            [self confirmAlertWithTitle:VLocalize(@"settings_close_touchid_title") handler:^{
//                NSLog(@"close touchID");
//            }];
            AppState.shareInstance.lockEnable = [item.dict[@"switcher"] boolValue];
        }
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    if ([item.identifier isEqualToString:@"auto_backup"] || [item.identifier isEqualToString:@"connection"]) {
        return 64;
    } else {
        return 48;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    

    
    if ([item.identifier isEqualToString:@"lock_method"]) {
        [self actionSheetWithSelectedIndex:AppState.shareInstance.lockMethod-1 withActionDatas:@[@"SecureID", @"Password"] handler:^(NSInteger index) {
            if (index == 0) {
                [TouchIDTool authSecureID:^(BOOL support, BOOL result) {
                    if (support && result) {
                        AppState.shareInstance.lockEnable = YES;
                        AppState.shareInstance.lockMethod = 1;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self initContentData];
                            [self.tableView reloadData];
                        });
                    }
                }];
            } else if (index == 1) {
                AppState.shareInstance.lockEnable = YES;
                AppState.shareInstance.lockMethod = 2;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initContentData];
                    [self.tableView reloadData];
                });
            }
        }];
        return;
    }
    
    if ([item.identifier isEqualToString:@"auto_lock"]) {
    
        NSInteger index;
        if(AppState.shareInstance.autoLockTime == 5) {
            index = 0;
        } else if(AppState.shareInstance.autoLockTime == 10) {
            index = 1;
        } else {
            index = 2;
        }
        [self actionSheetWithSelectedIndex:index withActionDatas:@[@"5 min", @"10 min", VLocalize(@"never")] handler:^(NSInteger index) {
            if(index == 0) {
                AppState.shareInstance.autoLockTime = 5;
            } else if (index == 1){
                AppState.shareInstance.autoLockTime = 10;
            } else {
                AppState.shareInstance.autoLockTime = -1;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initContentData];
                [self.tableView reloadData];
            });
        }];
        return;
    }

}

- (void)initContentData {
    NSMutableArray <CellItem *> *cellItems1 = @[].mutableCopy;
    if (![[TouchIDTool authType] isEqualToString:@""]) {
        [cellItems1 addObject:VCellItem(@"touchID", SwitchTableViewCellIdentifier, [TouchIDTool authType], @"", @"", (@{@"descColor": VColor.textSecondColor, @"switcher":@(AppState.shareInstance.lockEnable)}))];

    }
    [cellItems1 addObject:VCellItem(@"auto_lock", ArrowTableViewCellIdentifier, VLocalize(@"device.lock.cell2.title"), @"", [AppState.shareInstance lockTimeDescription], @{})];
    NSArray *contentData = @[
                             VSectionItem(VLocalize(@""), cellItems1.copy),
                             ];
    self.contentData = contentData;
}
@end
