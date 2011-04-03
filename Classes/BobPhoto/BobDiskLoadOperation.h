//
//  BobDiskLoadOperation.h
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BobCache.h"

@protocol BobDiskLoadOperationDelegate;

@interface BobDiskLoadOperation : NSOperation {
    @private
    NSString *location_;
    UIImage *image_;
    id<BobDiskLoadOperationDelegate> delegate;
    BobCache *bobCache;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) BobCache *bobCache;

-(id) initWithLocation:(NSString *) location;

@end

@protocol BobDiskLoadOperationDelegate <NSObject>
-(void) loadImage:(UIImage *) i;
@end
