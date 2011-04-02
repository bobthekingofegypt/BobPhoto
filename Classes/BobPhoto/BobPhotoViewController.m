#import "BobPhotoViewController.h"
#import "DiskThumbEntryView.h"
#import "BobDiskPhoto.h"
#import "BobPhotoPageController.h"

@implementation BobPhotoViewController

@synthesize photos = _photos;

- (id)init {
    self = [super init];
    if (self) {
        _photos = [[NSMutableArray alloc] init];
		_thumbnailImages = [[NSMutableDictionary alloc] initWithCapacity:[_photos count]];
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:3];
        bobCache = [[BobCache alloc] initWithCapacity:100];
		
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

	_bsgView = [[BSGView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, self.view.frame.size.height)];
	_bsgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_bsgView.datasource = self;
	_bsgView.bsgViewDelegate = self;
	_bsgView.alwaysBounceVertical = YES;
    _bsgView.preCacheColumnCount = 15;
	
	_bsgView.entrySize = CGSizeMake(75, 75);
	_bsgView.entryPadding = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
	[_bsgView reloadData];
    
	[self.view addSubview:_bsgView];
}

-(void) viewWillAppear:(BOOL)animated {
    [_bsgView reloadData];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        numberOfEntriesPerRow = 4;
    } else {
        numberOfEntriesPerRow = 6;
    }
	return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_bsgView reloadData];
}

-(BSGEntryView *)bsgView:(BSGView *)bsgView viewForEntryAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = IndexFromIndexPath(indexPath, [self numberOfEntriesPerRow]);
	DiskThumbEntryView *entry = (DiskThumbEntryView *)[bsgView dequeReusableEntry:@"Bob"];
	
	if (entry == nil) {
		entry = [[[DiskThumbEntryView alloc] initWithFrame:CGRectMake(0, 0, _bsgView.entrySize.width, _bsgView.entrySize.height) 
                                        andReuseIdentifier:@"Bob"] autorelease];
        entry.bobCache = bobCache;
        entry.operationQueue = operationQueue;
	} 
	
    BobDiskPhoto *photo = (BobDiskPhoto *)[_photos objectAtIndex:index];
	[entry setPath:photo.thumbnailLocation];
    [entry triggerDownload];
	return entry;
}

-(void) didSelectEntryAtIndexPath:(NSIndexPath *) index {
	BobPhotoPageController *controller = [[BobPhotoPageController alloc] initWithPhotos:_photos andCurrentIndex:IndexFromIndexPath(index, numberOfEntriesPerRow)];
    controller.operationQueue = operationQueue;
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
