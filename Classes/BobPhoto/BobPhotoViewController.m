#import "BobPhotoViewController.h"
#import "ThumbnailEntryView.h"
#import "BobPhoto.h"
#import "BobPhotoPageController.h"

@implementation BobPhotoViewController

@synthesize photos = photos_, 
            maximumConcurrentlyLoadingThumbnails = maximumConcurrentlyLoadingThumbnails_,
            maximumConcurrentlyLoadingImages = maximumConcurrentlyLoadingImages_;

-(id) initWithPhotos:(NSMutableArray *)photos {
    self = [super init];
    if (self) {
        photos_ = [photos retain];
        thumbnailImages_ = [[NSMutableDictionary alloc] initWithCapacity:[photos_ count]];
        operationQueue = [[NSOperationQueue alloc] init];
        bobCache = [[BobCache alloc] initWithCapacity:100];
		
        maximumConcurrentlyLoadingThumbnails_ = 1;
        maximumConcurrentlyLoadingImages_ = 1;
        
		numberOfEntriesPerRow = 4;
    }
    
    return self;
}

- (id)init {
    return [self initWithPhotos:[NSMutableArray array]];
}

- (void)dealloc {
	[photos_ release];
	[thumbnailImages_ release];
	[bsgView_ release];
    [operationQueue release];
    [bobCache release];
    
    [super dealloc];
}

#pragma mark
#pragma mark view lifecycle methods
#pragma mark

- (void)loadView {
	[super loadView];
	self.wantsFullScreenLayout = YES;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
	bsgView_ = [[BSGView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, self.view.frame.size.height)];
	bsgView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	bsgView_.datasource = self;
	bsgView_.bsgViewDelegate = self;
	bsgView_.alwaysBounceVertical = YES;
    bsgView_.preCacheColumnCount = 2;
	
	bsgView_.entrySize = CGSizeMake(75, 75);
	bsgView_.entryPadding = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    
	[self.view addSubview:bsgView_];
    
    [bsgView_ reloadData];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play.png"] style:UIBarButtonItemStylePlain target:self action:@selector(playSlideShow)];
    self.toolbarItems = [NSArray arrayWithObjects:space, play, space, nil];
    [space release];
    [play release];
}

-(void) viewWillAppear:(BOOL)animated {
    [operationQueue setMaxConcurrentOperationCount:maximumConcurrentlyLoadingThumbnails_];
    
    //[bsgView_ reloadData];
}

#pragma mark
#pragma mark Autorotation methods
#pragma mark

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark
#pragma mark BSGView delegate methods
#pragma mark

-(BSGEntryView *)bsgView:(BSGView *)bsgView viewForEntryAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = [bsgView indexForEntryAtIndexPath:indexPath];
	ThumbnailEntryView *entry = (ThumbnailEntryView *)[bsgView dequeReusableEntry:@"thumbnail"];
	
	if (entry == nil) {
		entry = [[[ThumbnailEntryView alloc] initWithFrame:CGRectMake(0, 0, bsgView_.entrySize.width, bsgView_.entrySize.height) 
                                        andReuseIdentifier:@"thumbnail"] autorelease];
        entry.bobCache = bobCache;
        entry.operationQueue = operationQueue;
	} 
	
    BobPhoto *photo = (BobPhoto *)[photos_ objectAtIndex:index];
	[entry setPhotoSource:photo.thumbnail];
    [entry triggerDownload];
	return entry;
}

-(void) bsgView:(BSGView *)bsgView didSelectEntryAtIndexPath:(NSIndexPath *)indexPath; {
    [operationQueue cancelAllOperations];
    [operationQueue setMaxConcurrentOperationCount:maximumConcurrentlyLoadingImages_];
	BobPhotoPageController *controller = [[BobPhotoPageController alloc] initWithPhotos:photos_ andCurrentIndex:IndexFromIndexPath(indexPath, numberOfEntriesPerRow)];
    controller.operationQueue = operationQueue;
    controller.bobThumbnailCache = bobCache;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(NSInteger) entryCount {
	return photos_.count;
}

-(NSInteger) numberOfEntriesPerRow {
    return numberOfEntriesPerRow;
}

-(void) playSlideShow {
    [operationQueue cancelAllOperations];
    [operationQueue setMaxConcurrentOperationCount:maximumConcurrentlyLoadingImages_];
	BobPhotoPageController *controller = [[BobPhotoPageController alloc] initWithPhotos:photos_ andCurrentIndex:IndexFromIndexPath(nil, numberOfEntriesPerRow)];
    controller.operationQueue = operationQueue;
    controller.bobThumbnailCache = bobCache;
	[self.navigationController pushViewController:controller animated:YES];
    [controller playSlideShow];
	[controller release];  
}

@end
