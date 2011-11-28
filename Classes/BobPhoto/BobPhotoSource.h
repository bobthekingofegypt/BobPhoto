//
//  BobPhotoSource.h
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
   ImageTypePNG,
   ImageTypeJPG,
    ImageTypeGIF
} ImageType;

@protocol BobPhotoSource <NSObject>

-(NSString *) location;
-(BOOL) retina;
-(NSString *) cacheKey;

@optional
-(ImageType) imageType;

@end
