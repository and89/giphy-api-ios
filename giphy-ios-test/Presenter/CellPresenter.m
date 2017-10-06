//
//  CellPresenter.m
//  giphy-ios-test
//
//  Created by andy on 06.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import "CellPresenter.h"
#import "ResultTableViewCell.h"
#import "ImageManager.h"

@interface CellPresenter ()

@end

@implementation CellPresenter

- (void)configureCell {
	__weak typeof(self) welf = self;
	UIImage *img = [[ImageManager sharedInstance] imageForId:self.item withCompletionBlock:^(UIImage *downloadedImage) {
		if (welf.cell) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[welf.cell setPreview:downloadedImage];
				[welf.cell setNeedsDisplay];
			}];
		}
	}];
	[self.cell setPreview:img];
}

- (void)cancel {
	
}

@end
