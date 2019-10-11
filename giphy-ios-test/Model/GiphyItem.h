#import <UIKit/UIKit.h>

@interface GiphyItem : NSObject

@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *urlPreview;
@property (nonatomic, strong) NSString *urlFullSize;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize fullSize;

@end
