#import <UIKit/UIKit.h>
#import "BSGEntryView.h"
#import "BobImageLoadOperation.h"
#import "BobCache.h"
#import "BobPhotoSource.h"

@interface ThumbnailEntryView : BSGEntryView <BobImageLoadOperationDelegate> {
	UIImage *image;
    BobImageLoadOperation *bobImageLoadOperation_;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    BobPhotoSource * photoSource_;
}

@property (nonatomic, retain) BobImageLoadOperation *bobImageLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(void) setPhotoSource:(BobPhotoSource *) photoSource;
-(void) prepareForReuse;
-(void) triggerDownload;

@end
