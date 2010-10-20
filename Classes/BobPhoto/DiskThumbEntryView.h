#import <Foundation/Foundation.h>
#import "BSGEntryView.h"
#import "BobDiskLoadOperation.h"
#import "BobCache.h"


@interface DiskThumbEntryView : BSGEntryView {
	UIImage *image;
    BobDiskLoadOperation *_bobDiskLoadOperation;
    BobCache *bobCache;
    NSOperationQueue *operationQueue;
    NSString *path_;
    //UIImageView *imageView;
}

@property (nonatomic, retain) BobDiskLoadOperation *bobDiskLoadOperation;
@property (nonatomic, retain) BobCache *bobCache;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(void) setPath:(NSString *) path;
-(void) prepareForReuse;
-(void) triggerDownload;

@end
