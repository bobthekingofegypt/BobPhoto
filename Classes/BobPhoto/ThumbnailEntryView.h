#import <Foundation/Foundation.h>
#import "BSGEntryView.h"
#import "BobImageLoadOperation.h"
#import "BobCache.h"
#import "BobPhotoSource.h"

@interface ThumbnailEntryView : BSGEntryView {
    @private
	UIImage *image;
    BobImageLoadOperation *_bobImageLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    id<BobPhotoSource> photoSource_;
}

@property (nonatomic, retain) BobImageLoadOperation *bobImageLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(void) setPhotoSource:(id<BobPhotoSource>) photoSource;
-(void) prepareForReuse;
-(void) triggerDownload;

@end
