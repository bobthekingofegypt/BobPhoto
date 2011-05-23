#import "BobPageScrollView.h"
#import "BobPage.h"

#define kDefaultPadding 0

@interface BobPageScrollView(Private)
-(NSUInteger) numberOfPages;
-(CGRect) calculateFrameSize;
-(CGSize) calculateContentSize:(NSUInteger) pageCount;
-(BobPage *) pageForIndex:(NSUInteger)index;
-(BOOL) isDisplayingPageForIndex:(NSUInteger) index;
-(void) layoutPages;
-(void) setUpPage:(BobPage *)page forIndex:(NSUInteger)index;
-(void) removePageForIndex:(NSUInteger) index;
-(void) resetPageFrameForIndex:(NSUInteger) index;
@end


@implementation BobPageScrollView

@synthesize datasource = _datasource, padding = _padding, currentIndex;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.padding = kDefaultPadding;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		originalFrame = frame;
		
        pagedScrollView = [[UIScrollView alloc] initWithFrame:originalFrame];
		pagedScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		pagedScrollView.pagingEnabled = YES;
		pagedScrollView.showsVerticalScrollIndicator = NO;
		pagedScrollView.showsHorizontalScrollIndicator = NO;
		pagedScrollView.delegate = self;
		pagedScrollView.backgroundColor = [UIColor blackColor];
		
		[self addSubview:pagedScrollView];
		
		reusablePages = [[NSMutableDictionary alloc] init];
		visiblePages = [[NSMutableDictionary alloc] init];
		
		firstShowingPageIndex = 0;
		lastShowingPageIndex = 0;
		
		currentIndex = 0;
    }
    return self;
}

- (void)dealloc {
	_datasource = nil;
	[pagedScrollView release];
	[reusablePages release];
	[visiblePages release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark BobPageScrollView methods

-(void) reloadData {
	numberOfPages = [self numberOfPages];
	pagedScrollView.frame = [self calculateFrameSize];
	pagedScrollView.contentSize = [self calculateContentSize:numberOfPages];
	
	if (!pagedScrollView.dragging) {
		pagedScrollView.contentOffset = CGPointMake(currentIndex * pagedScrollView.frame.size.width, 0.0f);
	}
	
	[self layoutPages];
}


-(CGRect) calculateFrameSize {
	return CGRectMake(originalFrame.origin.x - self.padding, 
					  originalFrame.origin.y, 
					  self.bounds.size.width + (self.padding * 2), 
					  self.bounds.size.height);
}


-(CGSize) calculateContentSize:(NSUInteger) pageCount {
	return CGSizeMake((self.bounds.size.width + (2 * self.padding)) * pageCount, self.bounds.size.height);
}


-(void) layoutPages {
	CGRect visibleBounds = pagedScrollView.bounds;
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	lastNeededPageIndex  = MIN(lastNeededPageIndex, [self numberOfPages] - 1);
	
	for (NSUInteger index = firstShowingPageIndex; index < firstNeededPageIndex; index++) {
		[self removePageForIndex:index];
	}
	
	for (NSUInteger index = lastShowingPageIndex; index > lastNeededPageIndex; index--) {
		[self removePageForIndex:index];
	}
	
	int overlap = (int)CGRectGetMinX(visibleBounds) % (int)CGRectGetWidth(visibleBounds);
	if (overlap < (CGRectGetWidth(visibleBounds) / 2.0f)) {
		currentIndex = firstNeededPageIndex;
	} else {
		currentIndex = lastNeededPageIndex;
	}
	
	for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {		
		if (![self isDisplayingPageForIndex:index]) {
			BobPage *page = [self pageForIndex:index];
			[self setUpPage:page forIndex:index];
			[pagedScrollView addSubview:page];
			[visiblePages setObject:page forKey:[NSNumber numberWithInt:index]];
		} else {
			[self resetPageFrameForIndex:index];
		}
	}
	
	firstShowingPageIndex = firstNeededPageIndex;
	lastShowingPageIndex = lastNeededPageIndex;
}

-(void) removePageForIndex:(NSUInteger) index {
	NSNumber *indexNumber = [NSNumber numberWithInt:index];
	BobPage *page = [visiblePages objectForKey:indexNumber];
	
	if (page) {
		NSString *entryKey = [[page.reuseIdentifier copy] autorelease];
		NSMutableSet *set = [reusablePages objectForKey:entryKey];
		if (set == nil) {
			set = [[[NSMutableSet alloc] init] autorelease];
		}
		[set addObject:page];
	
		[reusablePages setObject:set forKey:entryKey];
		[page removeFromSuperview];
		[visiblePages removeObjectForKey:indexNumber];
	}
}

-(BOOL) isDisplayingPageForIndex:(NSUInteger) index {
	BobPage *page = [visiblePages objectForKey:[NSNumber numberWithInt:index]];
	if (page) {
		return YES;
	} 
	
	return NO;
}

-(void) setUpPage:(BobPage *)page forIndex:(NSUInteger)index {
	page.index = index;
	page.frame = CGRectMake((pagedScrollView.frame.size.width * index) + self.padding, 
							0.0f, 
							pagedScrollView.frame.size.width - (2 * self.padding), 
							pagedScrollView.frame.size.height);
}

-(void) resetPageFrameForIndex:(NSUInteger) index {
	BobPage *page = [visiblePages objectForKey:[NSNumber numberWithInt:index]];
	if (page) {
		[self setUpPage:page forIndex:index];
	}
}
	

-(BobPage *) dequeueReusablePageWithIdentifier:(NSString *)reuseIdentifier {
	NSMutableSet *set = [reusablePages objectForKey:reuseIdentifier];
	if (set != nil) {
		BobPage *page = [set anyObject];
		if (page != nil) {
			[[page retain] autorelease];
			[set removeObject:page];
		}
		[page prepareForReuse];
		return page;
	}
	
	return nil;
}


#pragma mark -
#pragma mark BobPageScrollDatasource methods

-(NSUInteger) numberOfPages {
	return [self.datasource numberOfPages];
}

-(BobPage *) pageForIndex:(NSUInteger)index {
	return [self.datasource bobPageScrollView:self pageForIndex:index];
}

#pragma mark -
#pragma mark Position view methods

-(void) scrollToPage:(NSUInteger)page animated:(BOOL)animated {
    CGSize pageSize = CGSizeMake((self.bounds.size.width + (2 * self.padding)), self.bounds.size.height);
    NSInteger x = page * pageSize.width;
    [pagedScrollView scrollRectToVisible:CGRectMake(x, 0, pageSize.width, pageSize.height) animated:NO];
    [self layoutPages];
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (pagedScrollView.dragging && !(!pagedScrollView.dragging && pagedScrollView.decelerating)) {
		[self layoutPages];
	}
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //currentIndex = 
    [_datasource bobPageScrollView:self settledOnPage:currentIndex];
}

@end
