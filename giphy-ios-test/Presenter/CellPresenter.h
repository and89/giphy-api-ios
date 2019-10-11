#import <UIKit/UIKit.h>

@class ResultTableViewCell;
@class GiphyItem;

@interface CellPresenter : NSObject

@property (nonatomic, strong) GiphyItem *item;
@property (atomic, weak) ResultTableViewCell *cell;

- (void)configureCell;

- (void)cancel;

@end
