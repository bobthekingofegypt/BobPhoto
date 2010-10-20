//
//  BobPhotoPage.h
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BobPage.h"
#import "BobCenteringImageScrollView.h"
#import "BobDiskLoadOperation.h"
#import "BobCache.h"

@interface BobPhotoPage : BobPage {
    BobCenteringImageScrollView *_scrollView;
    BobDiskLoadOperation *_bobDiskLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    NSString *path_;
}

@property (nonatomic, retain) BobDiskLoadOperation *bobDiskLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(void) setPath:(NSString *) location;

@end
