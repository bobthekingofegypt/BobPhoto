//
//  BobPhotoSourceImpl.m
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobPhotoSourceImpl.h"

@interface BobPhotoSourceImpl()
-(BOOL) retina;
@end

@implementation BobPhotoSourceImpl

@synthesize imageLocation, imageLocationRetina, imageCacheKey;

-(NSString *) cacheKey {
    if (imageCacheKey) {
        return imageCacheKey;
    }

    NSString *withoutHTTP = [[self location] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    return [withoutHTTP stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}

-(NSString *) location {
    if ([self retina]) {
        return imageLocationRetina;
    }
    
    return imageLocation;
}

-(BOOL) retina {
    if (cached) {
        return retina;
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            retina = YES;
        }
    } else {
        retina = NO;
    }
    
    cached = YES;
    return retina;
}

-(void) dealloc {
    [imageLocation release];
    [imageLocationRetina release];
    [imageCacheKey release];
    [super dealloc];
}

@end
