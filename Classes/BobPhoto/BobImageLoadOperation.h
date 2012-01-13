//
//  BobDiskLoadOperation.h
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BobCache.h"
#import "BobPhotoSource.h"

@protocol BobImageLoadOperationDelegate;

@interface BobImageLoadOperation : NSOperation {
    @private
    id<BobPhotoSource> photoSource_;
    UIImage *image_;
    id<BobImageLoadOperationDelegate> delegate;
    BobCache *bobCache;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) BobCache *bobCache;

-(id) initWithPhotoSource:(id<BobPhotoSource>) photoSource;

@end

@protocol BobImageLoadOperationDelegate <NSObject>
-(void) loadImage:(UIImage *) i;
-(void) imageLoadFailed;
@end
