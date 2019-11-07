#import <UIKit/UIKit.h>
@class Token;

@interface CertifiedTokenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) Token *token;

@end
