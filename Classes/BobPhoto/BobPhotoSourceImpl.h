//
//  BobPhotoSourceImpl.h
//  BobPhoto
//
//  Created by Richard Martin on 24/04/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BobPhotoSource.h"

@interface BobPhotoSourceImpl : NSObject<BobPhotoSource> {
    NSString *imageLocation;
    NSString *imageLocationRetina;
}

@property (nonatomic, copy) NSString *imageLocation;
@property (nonatomic, copy) NSString *imageLocationRetina;

@end
