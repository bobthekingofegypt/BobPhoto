//
//  BobPhotoSourceImpl.m
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobPhotoSourceImpl.h"


@implementation BobPhotoSourceImpl

-(NSString *) cacheKey {
    if (imageCacheKey) {
        return imageCacheKey;
    }

    NSString *withoutHTTP = [[self location] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    return [withoutHTTP stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

@end
