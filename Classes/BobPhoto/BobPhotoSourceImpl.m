//
//  BobPhotoSourceImpl.m
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobPhotoSourceImpl.h"

@interface UIScreen(custom) 
-(double) scale;
@end

@implementation BobPhotoSourceImpl

@synthesize imageLocation, imageLocationRetina;

-(NSString *) location {
    if (imageLocationRetina && [[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            return imageLocationRetina;
        }
    } 
    
    return imageLocation;
}

-(BOOL) retina {
    if (imageLocationRetina && [[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        return YES;
    }  
    return NO;
}

-(void) dealloc {
    [imageLocation release];
    [imageLocationRetina release];
    [super dealloc];
}

@end
