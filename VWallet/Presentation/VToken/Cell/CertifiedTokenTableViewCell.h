#import <UIKit/UIKit.h>
@class VsysToken;

@interface CertifiedTokenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) VsysToken *token;

@end
