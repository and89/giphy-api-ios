//
//  ImageManager.h
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import "Common.h"

#import <UIKit/UIKit.h>

@interface ImageManager : NSObject

+ (instancetype)sharedInstance;

- (instancetype)init;

- (UIImage *)imageForId:(NSString *)identifier;

- (UIImage *)imageForId:(const GiphyItem *)item withCompletionBlock:(fetchImageT)block;

- (void)cleanUp;

@end
