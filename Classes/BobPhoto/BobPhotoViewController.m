#import "BobPhotoViewController.h"
#import "DiskThumbEntryView.h"
#import "BobDiskPhoto.h"
#import "BobPhotoPageController.h"

@implementation BobPhotoViewController

@synthesize photos = _photos;

- (id)init {
    self = [super init];
    if (self) {
		_thumbnailImages = [[NSMutableDictionary alloc] initWithCapacity:[_photos count]];
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:3];
        bobCache = [[BobCache alloc] initWithCapacity:100];
        
        _contentInsetsPortrait = UIEdgeInsetsMake(66.0f, 2.0f, 2.0f, 2.0f);
        _contentInsetsLandscape = UIEdgeInsetsMake(50.0f, 2.0f, 2.0f, 2.0f);
		
		numberOfEntriesPerRow = 4;
    }
    return self;
}

- (void)dealloc {
	[_photos release];
	[_thumbnailImages release];
	[_bsgView release];
    [super dealloc];
}

- (void)loadView {
	[super loadView];
	self.wantsFullScreenLayout = YES;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	backgroundView.backgroundColor = [UIColor greenColor];
	
	_bsgView = [[BSGView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,backgroundView.frame.size.width, backgroundView.frame.size.height)];
	_bsgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_bsgView.datasource = self;
	_bsgView.bsgViewDelegate = self;
	_bsgView.alwaysBounceVertical = YES;
	_bsgView.contentInset = _contentInsetsPortrait;
	
	_bsgView.entrySize = CGSizeMake(75, 75);
	_bsgView.entryPadding = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
	[_bsgView reloadData];
	[backgroundView addSubview:_bsgView];
	self.view = backgroundView;
	[backgroundView release];
}

-(void) viewWillAppear:(BOOL)animated {
    [_bsgView reloadData];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		numberOfEntriesPerRow = 6;
        _bsgView.contentInset = _contentInsetsLandscape;
	} else {
		numberOfEntriesPerRow = 4;
        _bsgView.contentInset = _contentInsetsPortrait;
	}
	return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_bsgView reloadData];
}

-(BSGEntryView *)bsgView:(BSGView *)bsgView viewForEntryAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = IndexFromIndexPath(indexPath, numberOfEntriesPerRow);
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
