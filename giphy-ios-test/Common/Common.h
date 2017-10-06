//
//  Common.h
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import <UIKit/UIKit.h>

@class GiphyItem;

static NSString * const giphyAPI_key = @"";

/**
 raw network response block type
 **/
typedef void (^responseT)(NSData *data, NSURLResponse *response, NSError *error);

/**
 fetch items from
 **/
typedef void (^fetchResultT)(NSArray<GiphyItem *> *items, NSError *error);

/**
 fetch image preview from cache
 **/
typedef void (^fetchImageT)(UIImage *downloadedImage);

#endif /* Common_h */
