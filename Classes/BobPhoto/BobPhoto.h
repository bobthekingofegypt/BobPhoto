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
    BobPhotoSource *image_;
    BobPhotoSource *thumbnail_;
}

@property (nonatomic, retain) BobPhotoSource *image;
@property (nonatomic, retain) BobPhotoSource *thumbnail;

+(BobPhoto *) bobPhotoWithThumbnail:(BobPhotoSource *)thumbnail andImage:(BobPhotoSource *)image;

@end
