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

@property (nonatomic, strong) NSMutableArray<LeaseNode *> *nodes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *showData;
@end

@implementation NodesViewController

- (instancetype)initWithNode:(NSArray *)arr {
    if (self = [super init]) {
        if (arr.count > 0) {
            self.nodes = [arr mutableCopy];
        }else{
            self.nodes = [NSMutableArray array];
        }
        
    }
    return self;
}

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
    if (self.nodes.count <= 0) {
        __weak typeof (self) weakSelf = self;
        [ApiServer getLeaseNodeList:^(BOOL isSuc, NSArray<LeaseNode *> * _Nonnull nodeList) {
            if(isSuc) {
                NSMutableArray *showData = [NSMutableArray new];
                for (LeaseNode *superNode in nodeList) {
                    if(![superNode isSuperNode]) {
                        continue;
                    }
                    
                    [weakSelf.nodes addObject:superNode];
                    [showData addObject:@{@"title" : [NSString stringWithFormat:@"%@ (%@)", superNode.superNodeName, [superNode.address explicitCount:12 maxAsteriskCount:6]], @"value" : @"SuperNode", @"hiddenCopy":[NSNumber numberWithBool:YES]}];
                    
                    for (LeaseNode *subNode in superNode.subNodeList) {
                        subNode.superNodeName = superNode.superNodeName;
                        subNode.address = superNode.address;
                        [showData addObject:@{@"title" : [NSString stringWithFormat:@"%@ (%@)", superNode.superNodeName, [superNode.address explicitCount:12 maxAsteriskCount:6]], @"value" : [NSString stringWithFormat:@"SubNode: %@", subNode.subNodeName], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
                        [weakSelf.nodes addObject:subNode];
                    }
                }
                if(weakSelf.nodes) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"nodeArrSet" object:nil userInfo:@{@"nodeArr":weakSelf.nodes}];
                }
                weakSelf.showData = showData.copy;
                [weakSelf.tableView reloadData];
            }
        }];
    }else{
        NSMutableArray *showData = [NSMutableArray new];
        for (LeaseNode *node in self.nodes) {
            if (node.isSubNode) {
                [showData addObject:@{@"title" : [NSString stringWithFormat:@"%@ (%@)", node.superNodeName, [node.address explicitCount:12 maxAsteriskCount:6]], @"value" : [NSString stringWithFormat:@"SubNode: %@", node.subNodeName], @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            }else{
                [showData addObject:@{@"title" : [NSString stringWithFormat:@"%@ (%@)", node.superNodeName, [node.address explicitCount:12 maxAsteriskCount:6]], @"value" : @"SuperNode", @"hiddenCopy":[NSNumber numberWithBool:YES]}];
            }
        }
        self.showData = showData.copy;
        [self.tableView reloadData];
    }
    
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nodeId" object:nil userInfo:@{@"LeaseNode":self.nodes[indexPath.row]}];
    if(self.block) {
        self.block();
    }
}

@end

