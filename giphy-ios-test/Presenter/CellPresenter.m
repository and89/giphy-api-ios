#import "CellPresenter.h"
#import "ResultTableViewCell.h"
#import "ImageManager.h"

@interface CellPresenter ()

@end

@implementation CellPresenter

- (void)configureCell {
    __weak typeof(self) welf = self;
    UIImage *img = [[ImageManager sharedInstance] imageForId:self.item withCompletionBlock:^(UIImage *downloadedImage) {
        __strong typeof(self) sSelf = welf;
        if (sSelf.cell) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                __strong typeof(welf.cell) cellPtr = welf.cell;
                [cellPtr setPreview:downloadedImage];
                [cellPtr setNeedsDisplay];
            }];
        }
    }];
    [self.cell setPreview:img];
}

- (void)cancel {
    
}

@end
