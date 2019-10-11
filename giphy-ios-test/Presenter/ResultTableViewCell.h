#import <UIKit/UIKit.h>

@class CellPresenter;

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) CellPresenter *presenter;

- (void)setPreview:(UIImage *)preview;

@end
