//
//  BobPhotoSourceImpl.m
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobPhotoSourceImpl.h"


@implementation BobPhotoSourceImpl

@synthesize imageLocation, imageLocationRetina;

-(NSString *) location {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        if (imageLocationRetina) {
            return imageLocationRetina;
        }
    }
    
    return imageLocation;
}

-(BOOL) retina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        if (imageLocationRetina) {
            return YES;
        }
    }
    return NO;
}

-(void) dealloc {
    [imageLocation release];
    [imageLocationRetina release];
    [super dealloc];
}

@end
