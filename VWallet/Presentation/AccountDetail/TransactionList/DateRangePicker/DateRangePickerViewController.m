//
// DateRangePickerViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "DateRangePickerViewController.h"
#import "Language.h"
#import "DateRangeOptionTableViewCell.h"
#import "DateRangeTableViewCell.h"
#import "VColor.h"
#import "DatePicker.h"
#import "NSDate+FormatString.h"

static NSString *SelectCellIdentifier = @"DateRangeOptionTableViewCell";
static NSString *RangeCellIdentifier = @"DateRangeTableViewCell";

@interface DateRangePickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) DateRangeType rangeType;
@property (nonatomic, assign) NSTimeInterval startTimestamp;
@property (nonatomic, assign) NSTimeInterval endTimestamp;
@property (nonatomic, strong) void(^resultBlock)(DateRangeType, NSTimeInterval, NSTimeInterval);

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation DateRangePickerViewController

- (instancetype)initWithRangeType:(DateRangeType)rangeType startTimestamp:(NSTimeInterval)startTimestamp endTimestamp:(NSTimeInterval)endTimestamp result:(nonnull void (^)(DateRangeType, NSTimeInterval, NSTimeInterval))result {
    if (self = [super init]) {
        self.rangeType = rangeType;
        self.startTimestamp = startTimestamp;
        self.endTimestamp = endTimestamp;
        self.resultBlock = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"nav.title.date.filter");
    [self.submitBtn setTitle:VLocalize(@"confirm") forState:UIControlStateNormal];
    
    self.tableView.rowHeight = 56;
    [self.tableView registerNib:[UINib nibWithNibName:SelectCellIdentifier bundle:nil] forCellReuseIdentifier:SelectCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:RangeCellIdentifier bundle:nil] forCellReuseIdentifier:RangeCellIdentifier];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DateRangeOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectCellIdentifier forIndexPath:indexPath];
        NSString *rangTypeStrKey = [NSString stringWithFormat:@"date.range.type.%d", (int)indexPath.row];
        NSDictionary *showInfo = @{@"title":VLocalize(rangTypeStrKey), @"selected":@(self.rangeType == indexPath.row)};
        cell.showInfo = showInfo;
        return cell;
    }
    if (indexPath.section == 1) {
        DateRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RangeCellIdentifier forIndexPath:indexPath];
        [cell setStartTimestamp:self.startTimestamp endTimestamp:self.endTimestamp];
        __weak typeof(self) weakSelf = self;
        [cell setStartDateBlock:^(UIButton * _Nonnull btn) {
            DatePicker *dataPicker = [[DatePicker alloc] initWithMinTimestamp:0 maxTimestamp:(self.endTimestamp?:NSDate.date.timeIntervalSince1970) currentTimestamp:self.startTimestamp result:^(NSTimeInterval timestamp) {
                weakSelf.startTimestamp = timestamp;
                [btn setTitle:[NSDate dateWithTimeIntervalSince1970:timestamp].dateString forState:UIControlStateNormal];
            }];
            [weakSelf presentViewController:dataPicker animated:NO completion:nil];
        }];
        [cell setEndDateBlock:^(UIButton * _Nonnull btn) {
            DatePicker *dataPicker = [[DatePicker alloc] initWithMinTimestamp:self.startTimestamp maxTimestamp:NSDate.date.timeIntervalSince1970 currentTimestamp:self.endTimestamp result:^(NSTimeInterval timestamp) {
                weakSelf.endTimestamp = timestamp;
                [btn setTitle:[NSDate dateWithTimeIntervalSince1970:timestamp].dateString forState:UIControlStateNormal];
            }];
            [weakSelf presentViewController:dataPicker animated:NO completion:nil];
        }];
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && self.resultBlock) {
        self.resultBlock(indexPath.row, 0, 0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headView = [[UIView alloc] init];
        CGFloat screenW = CGRectGetWidth(UIScreen.mainScreen.bounds);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screenW - 40, 40)];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = VLocalize(@"date.range.section.title");
        label.textColor = VColor.textSecondColor;
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [headView addSubview:label];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 39, screenW, 1)];
        separator.backgroundColor = VColor.separatorColor;
        [headView addSubview:separator];
        return headView;
    }
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

#pragma mark - Submit
- (IBAction)submitBtnClick {
    if (self.resultBlock) {
        if (self.startTimestamp <= 0 && self.endTimestamp <= 0) {
            self.rangeType = DateRangeTypeNone;
        } else {
            self.rangeType = DateRangeTypeCustom;
        }
        self.resultBlock(self.rangeType, self.startTimestamp, self.endTimestamp);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
