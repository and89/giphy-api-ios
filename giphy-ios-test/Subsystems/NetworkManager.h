//
//  NetworkManager.h
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

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
