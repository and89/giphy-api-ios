#import "Common.h"

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;

- (instancetype)init;

- (void)requestWithUrlString:(NSString *)urlString withBlock:(responseT)block;

- (void)requestImageWithUrl:(NSString *)url withBlock:(responseT)block;

- (void)requestPreview:(NSString *)url withBlock:(responseT)block;

- (void)cleanUp;

@end
