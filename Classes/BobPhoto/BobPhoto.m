//
//  BobPhoto.m
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobPhoto.h"


@implementation BobPhoto

@synthesize image= image_, thumbnail = thumbnail_;

+(BobPhoto *) bobPhotoWithThumbnail:(id<BobPhotoSource>)thumbnail andImage:(id<BobPhotoSource>)image {
    BobPhoto *bobPhoto = [[[BobPhoto alloc] init] autorelease];
    bobPhoto.thumbnail = thumbnail;
    bobPhoto.image = image;
    
    return bobPhoto;
}

-(void) dealloc {
    [image_ release];
    [thumbnail_ release];
    [super dealloc];
}

@end
