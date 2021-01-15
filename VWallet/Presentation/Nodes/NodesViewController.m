//
//  Nodes.m
//  VWallet
//
//  Copyright © 2021 veetech. All rights reserved.
//

#import "TransactionDetailTableViewCell.h"
#import "NodesViewController.h"
#import "LeaseNode.h"
#import "Language.h"
#import "UIViewController+NavigationBar.h"
#import "ApiServer.h"
#import "NSString+Asterisk.h"

static NSString *const CellIdentifier = @"TransactionDetailTableViewCell";


@interface NodesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *showData;
@end

@implementation NodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self fetchNodes];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"tip.transaction.node.title");
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeToThemeNavigationBar];
}

- (void)fetchNodes {
    __weak typeof (self) weakSelf = self;
    [ApiServer getLeaseNodeList:^(BOOL isSuc, NSArray<LeaseNode *> * _Nonnull nodeList) {
        if(isSuc) {
            NSMutableArray *showData = [NSMutableArray new];
            for (LeaseNode *superNode in nodeList) {
                if(![superNode isSuperNode]) {
                    continue;
                }
                
                [showData addObject:@{@"title" : [NSString stringWithFormat:@"%@ (%@)", superNode.name, [superNode.address explicitCount:12 maxAsteriskCount:6]], @"value" : @"SuperNode", @"hiddenCopy":[NSNumber numberWithBool:YES]}];
                for (LeaseNode *subNode in superNode.subNodeList) {
                    [showData addObject:@{@"title" : [NSString stringWithFormat:@"%@ (%@)", superNode.name, [superNode.address explicitCount:12 maxAsteriskCount:6]], @"value" : [NSString stringWithFormat:@"SubNode: %@", subNode.name], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
                }
            }
            weakSelf.showData = showData.copy;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.showInfo = self.showData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

