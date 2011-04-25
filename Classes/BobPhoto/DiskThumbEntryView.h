#import <Foundation/Foundation.h>
#import "BSGEntryView.h"
#import "BobDiskLoadOperation.h"
#import "BobCache.h"
#import "BobPhotoSource.h"

@interface DiskThumbEntryView : BSGEntryView {
    @private
	UIImage *image;
    BobDiskLoadOperation *_bobDiskLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    id<BobPhotoSource> photoSource_;
}

@property (nonatomic, retain) BobDiskLoadOperation *bobDiskLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(void) setPhotoSource:(id<BobPhotoSource>) photoSource;
-(void) prepareForReuse;
-(void) triggerDownload;

@end
