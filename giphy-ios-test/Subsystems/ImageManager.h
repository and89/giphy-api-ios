#import "Common.h"

#import <UIKit/UIKit.h>

@interface ImageManager : NSObject

+ (instancetype)sharedInstance;

- (instancetype)init;

- (UIImage *)imageForId:(NSString *)identifier;

- (UIImage *)imageForId:(const GiphyItem *)item withCompletionBlock:(fetchImageT)block;

- (void)cleanUp;

@end
