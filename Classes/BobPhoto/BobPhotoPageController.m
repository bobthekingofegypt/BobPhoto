#import "BobPhotoPageController.h"
#import "BobPageImage.h"
#import "BobDiskPhoto.h"
#import "BobPhotoPage.h"

@interface BobPhotoPageController()
-(void) setupArrows;
-(void) updateChrome;
-(void) setPageTitle;
@end

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
    [left release];
    [play release];
    [right release];
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
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonPressed)];
    play = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play.png"] style:UIBarButtonItemStylePlain target:self action:@selector(playSlideShow)];
    right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed)];
    self.toolbarItems = [NSArray arrayWithObjects:space, left, space, play, space, right, space, nil];
    
    [space release];
    [self setupArrows];
    [self setPageTitle];
}

-(void) setPageTitle {
    self.title = [NSString stringWithFormat:@"%d of %d", _bobPageScrollView.currentIndex + 1, [_photos count]];
}

-(void) setupArrows {
   [self setPageTitle];
    if (_bobPageScrollView.currentIndex == 0) {
        left.enabled = NO;
    } else if (_bobPageScrollView.currentIndex == ([_photos count] - 1)) {
        right.enabled = NO;
    }
}

-(void) leftButtonPressed {
    if (_bobPageScrollView.currentIndex  > 0) {
        [_bobPageScrollView scrollToPage:(_bobPageScrollView.currentIndex - 1) animated:NO];
         right.enabled = YES;
        [self setupArrows];
    }
}

-(void) rightButtonPressed {
    if (_bobPageScrollView.currentIndex  < ([_photos count] - 1)) {
        [_bobPageScrollView scrollToPage:(_bobPageScrollView.currentIndex + 1) animated:NO];
        left.enabled = YES;
        [self setupArrows];
    }
}

-(void) changePage {
    playingSlideshow = YES;
    [self rightButtonPressed];
}

-(void) playSlideShow {
    if (playingSlideshow) {
        if (slideshowTimer) {
            [slideshowTimer invalidate];
            [slideshowTimer release], slideshowTimer = nil;
            playingSlideshow = NO;
        }
    } else {
        if (!slideshowTimer) {
            slideshowTimer = [[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changePage) userInfo:nil repeats:YES] retain];
        }
        [play setImage:[UIImage imageNamed:@"pause.png"]];
        showingChrome = NO;
        [self updateChrome];
        playingSlideshow = YES;
    }
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
    
    if (slideshowTimer) {
        [slideshowTimer invalidate];
        [slideshowTimer release], slideshowTimer = nil;
        playingSlideshow = NO;
        [play setImage:[UIImage imageNamed:@"play.png"]];
    }
    
    [self updateChrome];
}

-(void) updateChrome {
    [[UIApplication sharedApplication] setStatusBarHidden:!showingChrome animated:YES];
    [self.navigationController setNavigationBarHidden:!showingChrome animated:YES];
    [self.navigationController setToolbarHidden:!showingChrome animated:YES];
}

@end
