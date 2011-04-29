#import "BobPhotoViewController.h"
#import "ThumbnailEntryView.h"
#import "BobPhoto.h"
#import "BobPhotoPageController.h"

@implementation BobPhotoViewController

@synthesize photos = _photos, 
            maximumConcurrentlyLoadingThumbnails = maximumConcurrentlyLoadingThumbnails_,
            maximumConcurrentlyLoadingImages = maximumConcurrentlyLoadingImages_;

- (id)init {
    self = [super init];
    if (self) {
        _photos = [[NSMutableArray alloc] init];
		_thumbnailImages = [[NSMutableDictionary alloc] initWithCapacity:[_photos count]];
        operationQueue = [[NSOperationQueue alloc] init];
        bobCache = [[BobCache alloc] initWithCapacity:100];
		
        maximumConcurrentlyLoadingThumbnails_ = 1;
        maximumConcurrentlyLoadingImages_ = 1;
        
		numberOfEntriesPerRow = 4;
    }
    return self;
}

- (void)dealloc {
	[_photos release];
	[_thumbnailImages release];
	[_bsgView release];
    [operationQueue release];
    [bobCache release];
    
    [super dealloc];
}

- (void)loadView {
	[super loadView];
	self.wantsFullScreenLayout = YES;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
	_bsgView = [[BSGView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, self.view.frame.size.height)];
	_bsgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_bsgView.datasource = self;
	_bsgView.bsgViewDelegate = self;
	_bsgView.alwaysBounceVertical = YES;
    _bsgView.preCacheColumnCount = 2;
	
	_bsgView.entrySize = CGSizeMake(75, 75);
	_bsgView.entryPadding = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    
	[self.view addSubview:_bsgView];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [operationQueue setMaxConcurrentOperationCount:maximumConcurrentlyLoadingThumbnails_];
    [_bsgView reloadData];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        numberOfEntriesPerRow = 4;
    } else {
        numberOfEntriesPerRow = 6;
    }
     [_bsgView prepareOrientationChange];
	return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
   
}



-(BSGEntryView *)bsgView:(BSGView *)bsgView viewForEntryAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = IndexFromIndexPath(indexPath, [self numberOfEntriesPerRow]);
	ThumbnailEntryView *entry = (ThumbnailEntryView *)[bsgView dequeReusableEntry:@"thumbnail"];
	
	if (entry == nil) {
		entry = [[[ThumbnailEntryView alloc] initWithFrame:CGRectMake(0, 0, _bsgView.entrySize.width, _bsgView.entrySize.height) 
                                        andReuseIdentifier:@"thumbnail"] autorelease];
        entry.bobCache = bobCache;
        entry.operationQueue = operationQueue;
	} 
	
    BobPhoto *photo = (BobPhoto *)[_photos objectAtIndex:index];
	[entry setPhotoSource:photo.thumbnail];
    [entry triggerDownload];
	return entry;
}

-(void) didSelectEntryAtIndexPath:(NSIndexPath *) index {
    [operationQueue setMaxConcurrentOperationCount:maximumConcurrentlyLoadingImages_];
	BobPhotoPageController *controller = [[BobPhotoPageController alloc] initWithPhotos:_photos andCurrentIndex:IndexFromIndexPath(index, numberOfEntriesPerRow)];
    controller.operationQueue = operationQueue;
    controller.bobThumbnailCache = bobCache;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(NSInteger) entryCount {
	return _photos.count;
}

-(NSInteger) numberOfEntriesPerRow {
    return numberOfEntriesPerRow;
}

@end
