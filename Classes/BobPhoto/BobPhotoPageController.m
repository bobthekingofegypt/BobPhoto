#import "BobPhotoPageController.h"
#import "BobPageImage.h"
#import "BobDiskPhoto.h"
#import "BobPhotoPage.h"

@implementation BobPhotoPageController

@synthesize operationQueue, bobThumbnailCache;

-(id) initWithPhotos:(NSMutableArray *)photos andCurrentIndex:(NSUInteger)index {
    self = [super init];
	if (self) {
		_photos = [photos retain];
        bobCache = [[BobCache alloc] initWithCapacity:3];
		
		currentIndex = index;
        showingChrome = YES;
	}
	
	return self;
}

- (void)dealloc {
    [bobCache release];
    [operationQueue release];
	[_bobPageScrollView release];
	[_photos release];
    [super dealloc];
}

-(void) loadView {
	[super loadView];	
	[self setWantsFullScreenLayout:YES];
    
	_bobPageScrollView = [[BobPageScrollView alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width, self.view.frame.size.height)];
	_bobPageScrollView.padding = 10.0f;
	_bobPageScrollView.datasource = self;
	_bobPageScrollView.currentIndex = currentIndex;
    [_bobPageScrollView reloadData];
    
	[self.view addSubview:_bobPageScrollView];
}

-(void) viewWillAppear:(BOOL)animated {
     [_bobPageScrollView reloadData];
}

-(void) setCurrentIndex:(NSUInteger)index {
	[_bobPageScrollView reloadData];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_bobPageScrollView reloadData];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark -
#pragma mark BobPageScrollViewDatasource methods

-(NSUInteger) numberOfPages {
	return [_photos count];
}

-(BobPage *) bobPageScrollView:(BobPageScrollView *)bobPageScrollView pageForIndex:(NSUInteger)index {
	static NSString *reuseIdentifier = @"PhotoPage";
	BobPhotoPage *page = (BobPhotoPage *)[bobPageScrollView dequeueReusablePageWithIdentifier:reuseIdentifier];
	if (!page) {
		page = [[[BobPhotoPage alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f) andReuseIdentifier:reuseIdentifier] autorelease];
        page.bobCache = bobCache;
        page.bobThumbnailCache = bobThumbnailCache;
        page.operationQueue = operationQueue;
        page.touchDelegate = self;
	}
	
	BobDiskPhoto *photo = (BobDiskPhoto *)[_photos objectAtIndex:index];
    [page setPath:photo];
	
	return page;
}

-(void) photoViewTouched:(BobPhotoPage *)bobPhotoPage {
    showingChrome = showingChrome ? NO : YES;
    [[UIApplication sharedApplication] setStatusBarHidden:!showingChrome animated:YES];
    [self.navigationController setNavigationBarHidden:!showingChrome animated:YES];
    [self.navigationController setToolbarHidden:!showingChrome animated:YES];
}

@end
