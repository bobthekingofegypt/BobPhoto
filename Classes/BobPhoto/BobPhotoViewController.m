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
		
		numberOfEntriesPerRow = 4;
    }
    return self;
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
    _bsgView.delegate = self;
	
	_bsgView.contentInset = UIEdgeInsetsMake(66.0f, 2.0f, 2.0f, 2.0f);
	
	_bsgView.entrySize = CGSizeMake(75, 75);
	_bsgView.entryPadding = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
	[_bsgView reloadData];
	[backgroundView addSubview:_bsgView];
	self.view = backgroundView;
	[backgroundView release];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		numberOfEntriesPerRow = 6;
	} else {
		numberOfEntriesPerRow = 4;
	}
	return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	//[_bsgView prepareForOrientationChange:toInterfaceOrientation duration:duration];
	NSLog(@"Will rotate");
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[_bsgView reloadData];
}

-(BSGEntryView *)bsgView:(BSGView *)bsgView viewForEntryAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = IndexFromIndexPath(indexPath, numberOfEntriesPerRow);
	DiskThumbEntryView *entry = (DiskThumbEntryView *)[bsgView dequeReusableEntry:@"Bob"];
	
	if (entry == nil) {
		entry = [[[DiskThumbEntryView alloc] initWithFrame:CGRectMake(0, 0, 75, 75) andReuseIdentifier:@"Bob"] autorelease];
        entry.bobCache = bobCache;
        entry.operationQueue = operationQueue;
	} 
	
	//UIImage *image = [_thumbnailImages objectForKey:[NSNumber numberWithInt:index]];
	//if (!image) {
    BobDiskPhoto *photo = (BobDiskPhoto *)[_photos objectAtIndex:index];
		//image = [UIImage imageNamed:photo.thumbnailLocation];
		//[_thumbnailImages setObject:image forKey:[NSNumber numberWithInt:index]];
	//}
	[entry setPath:photo.thumbnailLocation];
    
    if (check) {
        [entry triggerDownload];
    }
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

- (void)dealloc {
	[_photos release];
	[_thumbnailImages release];
	[_bsgView release];
    [super dealloc];
}

-(void) loadImagesForOnscreenRows {
    NSArray *rows = [_bsgView visibleEntries];
    for (DiskThumbEntryView *view in rows) {
        [view triggerDownload];
    }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //check = NO;
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"BNABafdaf");
    if (!decelerate)
    {
        //NSLog(@"BNABafdaf");
        check = YES;
        [self loadImagesForOnscreenRows];
    }
    //NSLog(@"TEETETETET");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
