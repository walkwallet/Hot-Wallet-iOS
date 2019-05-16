//
//  SectionHeaderView.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const SectionHeaderViewIdentifier = @"SectionHeaderView";

@interface SectionHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *descBtn;

@end

NS_ASSUME_NONNULL_END
