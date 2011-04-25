//
//  BobDiskLoadOperation.h
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BobCache.h"
#import "BobPhotoSource.h"

@protocol BobDiskLoadOperationDelegate;

@interface BobDiskLoadOperation : NSOperation {
    @private
    id<BobPhotoSource> photoSource_;
    UIImage *image_;
    id<BobDiskLoadOperationDelegate> delegate;
    BobCache *bobCache;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) BobCache *bobCache;

-(id) initWithPhotoSource:(id<BobPhotoSource>) photoSource;

@end

@protocol BobDiskLoadOperationDelegate <NSObject>
-(void) loadImage:(UIImage *) i;
@end
