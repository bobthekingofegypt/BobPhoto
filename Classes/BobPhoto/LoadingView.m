//
//  LoadingView.m
//  BobPhoto
//
//  Created by Richard Martin on 03/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "LoadingView.h"

#define kSize 20.0f

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    return self;
}

-(void) layoutSubviews {
    activityIndicator.frame = CGRectMake((self.bounds.size.width / 2) - (kSize / 2), (self.bounds.size.height / 2) - (kSize / 2), kSize, kSize);
}

- (void)dealloc {
    [activityIndicator stopAnimating];
    [activityIndicator release];
    
    [super dealloc];
}

@end
