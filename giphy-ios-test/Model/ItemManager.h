#import "Common.h"

#import <Foundation/Foundation.h>

@class GiphyItem;

@interface ItemManager : NSObject

@property (atomic, strong) NSMutableArray<GiphyItem *> *items;

+ (instancetype)sharedInstance;

/**
 clean internal state for new search
 **/
- (void)cleanUp;

- (void)requestItemsWithName:(NSString *)name andResultBlock:(fetchResultT)block;

- (void)loadMoreItemsWithResultBlock:(fetchResultT)block;

- (GiphyItem *)itemForIndexPath:(NSIndexPath *)path;


@end
