#import <UIKit/UIKit.h>

#import "ItemManager.h"
#import "GiphyItem.h"
#import "NetworkManager.h"

@interface ItemManager ()

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign) NSUInteger currentOffset;
@property (nonatomic, assign) NSUInteger itemsPerRequest;
@property (nonatomic, assign) NSUInteger totalCount;

- (NSString *)filteredUrlString:(NSString *)str;

- (NSArray<GiphyItem *> *)parseRawJSONData:(NSData *)data;

@end

@implementation ItemManager

+ (instancetype)sharedInstance {
    static ItemManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ItemManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _searchString = nil;
        _currentOffset = 0;
        _itemsPerRequest = 100;
        _totalCount = 0;
        _items = [[NSMutableArray alloc] initWithCapacity:1024];
    }
    return self;
}

- (void)cleanUp {
    self.currentOffset = 0;
    self.totalCount = 0;
    [self.items removeAllObjects];
}

- (void)requestItemsWithName:(NSString *)name andResultBlock:(fetchResultT)block {
    self.searchString = [self filteredUrlString:name];
    
    NSString *queryString = [[NSMutableString alloc] initWithFormat:@"http://api.giphy.com/v1/gifs/search?api_key=%@&q=%@&offset=%lu&limit=%lu", giphyAPI_key, self.searchString, self.currentOffset, self.itemsPerRequest];
    [[NetworkManager sharedInstance] requestWithUrlString:queryString withBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        @autoreleasepool {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSInteger code = httpResponse.statusCode;
            if (error || code != 200 || !data) {
                if (block) {
                    block(nil, error);
                }
                return;
            }
            
            NSArray<GiphyItem *> *resultItems = [self parseRawJSONData:data];
            
            if (resultItems.count) {
                [self.items addObjectsFromArray:resultItems];
            }
            
            if (block) {
                block(resultItems, error);
            }
        }
    }];
}

- (void)loadMoreItemsWithResultBlock:(fetchResultT)block {
    [self requestItemsWithName:self.searchString andResultBlock:block];
}

- (GiphyItem *)itemForIndexPath:(NSIndexPath *)path {
    NSAssert(path.row < self.items.count, @"out of bound error");
    return self.items[path.row];
}

- (NSString *)filteredUrlString:(NSString *)str {
    NSString *preparedString = [str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    return preparedString;
}

- (NSArray<GiphyItem *> *)parseRawJSONData:(NSData *)data {
    NSError *jsonParseError = nil;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonParseError];
    if (![NSJSONSerialization isValidJSONObject:parsedData]) {
        return nil;
    }
    
    NSNumber *totalCountData = parsedData[@"pagination"][@"total_count"];
    NSNumber *count = parsedData[@"pagination"][@"count"];
    self.totalCount = totalCountData.unsignedIntegerValue;
    self.currentOffset += count.unsignedIntegerValue;
    
    if (!self.totalCount) {
        return nil;
    }
    
    NSArray *dataItems = parsedData[@"data"];
    
    NSMutableArray<GiphyItem *> *resultItems = [[NSMutableArray alloc] initWithCapacity:count.unsignedIntegerValue];
    
    for (__kindof NSDictionary *dataItem in dataItems) {
        GiphyItem *giphyItem = [GiphyItem new];
        giphyItem.ident = dataItem[@"id"];
        NSDictionary *images = dataItem[@"images"];
        
        NSDictionary *fixed = images[@"fixed_height_still"];
        
        giphyItem.urlPreview = fixed[@"url"];
        NSString *w = fixed[@"width"];
        NSString *h = fixed[@"height"];
        giphyItem.size = CGSizeMake(w.intValue, h.intValue);
        
        NSDictionary *full = images[@"original_still"];
        giphyItem.urlFullSize = full[@"url"];
        w = full[@"width"];
        h = full[@"height"];
        giphyItem.fullSize = CGSizeMake(w.intValue, h.intValue);
        
        [resultItems addObject:giphyItem];
    }
    
    return resultItems;
}

@end
