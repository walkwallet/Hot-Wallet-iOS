//
// AboutTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AboutTableViewController.h"
#import "VColor.h"
#import "Language.h"
#import "CellItem.h"
#import "SectionItem.h"
#import "ArrowTableViewCell.h"
#import "SectionHeaderView.h"
#import "VColor.h"

@interface AboutTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic, copy) NSArray<SectionItem *> *contentData;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.title = VLocalize(@"nav.title.about");

    self.tableView.backgroundColor = VColor.tableViewBgColor;
    self.tableView.separatorColor = VColor.rootViewBgColor;
    
    [self initContentData];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:ArrowTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:ArrowTableViewCellIdentifier];
    
//    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
//    NSString *icon = [[info valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
//    self.logoImageView.image = [UIImage imageNamed:icon];
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

    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)initContentData {
    NSArray <CellItem *> *cellItems1 = @[
         VCellItem(@"", ArrowTableViewCellIdentifier, VLocalize(@"about.cell1.title"), @"", @"v.systems", (@{@"no_arrow":@(YES)})),
         VCellItem(@"", ArrowTableViewCellIdentifier, VLocalize(@"about.cell2.title"), @"", VLocalize([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]), (@{@"no_arrow":@(YES)})),
     ];
    NSArray *contentData = @[
         VSectionItem(VLocalize(@""), cellItems1),
     ];
    self.contentData = contentData;
}

@end
