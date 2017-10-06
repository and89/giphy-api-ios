//
//  GiphyItem.h
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiphyItem : NSObject

@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *urlPreview;
@property (nonatomic, strong) NSString *urlFullSize;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize fullSize;

@end
