//
//  CellPresenter.h
//  giphy-ios-test
//
//  Created by andy on 06.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultTableViewCell;
@class GiphyItem;

@interface CellPresenter : NSObject

@property (nonatomic, strong) GiphyItem *item;
@property (atomic, weak) ResultTableViewCell *cell;

- (void)configureCell;

- (void)cancel;

@end
