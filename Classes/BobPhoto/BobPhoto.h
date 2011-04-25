//
//  BobPhoto.h
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BobPhotoSource.h"

@interface BobPhoto : NSObject {
    id<BobPhotoSource> image_;
    id<BobPhotoSource> thumbnail_;
}

@property (nonatomic, retain) id<BobPhotoSource> image;
@property (nonatomic, retain) id<BobPhotoSource> thumbnail;

+(BobPhoto *) bobPhotoWithThumbnail:(id<BobPhotoSource>)thumbnail andImage:(id<BobPhotoSource>)image;

@end
