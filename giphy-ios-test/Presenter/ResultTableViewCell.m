//
//  ResultTableViewCell.m
//  giphy-ios-test
//
//  Created by andy on 02.10.17.
//  Copyright © 2017 andy. All rights reserved.
//

#import "ResultTableViewCell.h"

@interface ResultTableViewCell ()

@end

@implementation ResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.previewImage.image = nil;
	self.loadingIndicator.hidden = NO;
}

- (void)setPreview:(UIImage *)preview {
	self.previewImage.image = preview;
	self.previewImage.hidden = (preview == nil ? YES : NO);
	if (preview) {
		[self.loadingIndicator stopAnimating];
		self.loadingIndicator.hidden = YES;
	} else {
		self.loadingIndicator.hidden = NO;
		[self.loadingIndicator startAnimating];
	}
}

@end
