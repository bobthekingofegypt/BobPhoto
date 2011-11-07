#import "BSGView.h"

NSInteger IndexFromIndexPath(NSIndexPath *path, NSInteger entriesPerRow) {
	return (path.row * entriesPerRow) + path.section;
}

@interface BSGView ()
@property (nonatomic, retain) NSIndexPath *startingIndexPath;
@property (nonatomic, retain) NSIndexPath *endingIndexPath;
@end


@interface BSGView (Private)
-(void) redrawForLocation:(CGPoint)scrollLocation;
-(void) removeAllVisibleItems;
@end



@implementation BSGView

@synthesize datasource = _datasource, 
			bsgViewDelegate = _bsgViewDelegate, 
			entryPadding = _entryPadding,
			entrySize = _entrySize,
			startingIndexPath,
			endingIndexPath,
            numberOfEntriesPerRow = _numberOfEntriesPerRow,
            preCacheColumnCount,
            contentInsetsLandscape = _contentInsetsLandscape,
            contentInsetsPortrait = _contentInsetsPortrait,
            selectedEntry;



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		self.datasource = nil;
		self.bsgViewDelegate = nil;
		
		self.startingIndexPath = nil;
		self.endingIndexPath = nil;
		highlightedEntry = nil;
		selectedEntry = nil;
		
		self.entryPadding = UIEdgeInsetsZero;
		self.entrySize = CGSizeZero;
		
		_numberOfRows = 0;
		_numberOfEntriesPerRow = 0;
		
		visibleEntries = [[NSMutableDictionary alloc] init];
		reusableEntries = [[NSMutableDictionary alloc] init];
		 
		self.backgroundColor = [UIColor whiteColor];
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.userInteractionEnabled = YES;
		self.scrollEnabled = YES;
		self.delegate = self;
		self.bsgViewDelegate = nil;
		//self.alwaysBounceVertical = NO;
		//self.alwaysBounceHorizontal = NO;
		
		self.autoresizesSubviews = NO;
        
        _contentInsetsPortrait = UIEdgeInsetsMake(66.0f, 2.0f, 46.0f, 2.0f);
        _contentInsetsLandscape = UIEdgeInsetsMake(52.0f, 2.0f, 32.0f, 2.0f);
        
        preCacheColumnCount = 0;
	}
	
	return self;
}

-(void) dealloc {
	self.datasource = nil;
	self.bsgViewDelegate = nil;
	[startingIndexPath release], startingIndexPath = nil;
	[endingIndexPath release], endingIndexPath = nil;
	[highlightedEntry release], highlightedEntry = nil;
	[selectedEntry release], selectedEntry = nil;
	[visibleEntries release], visibleEntries = nil;
	[reusableEntries release], reusableEntries = nil;
	
	[super dealloc];
}

#pragma mark 
#pragma mark ScrollView delegate methods
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView {
	
}

-(void) removeVisibleItemForX:(NSInteger)x andY:(NSInteger)y {
	NSIndexPath *key = [NSIndexPath indexPathForRow:y inSection:x];
	BSGEntryView *entry = [visibleEntries objectForKey:key];

	if (entry != nil) {
		[[entry retain] autorelease];
		[entry removeFromSuperview];
		[visibleEntries removeObjectForKey:key];
		NSString *entryKey = [[entry.reuseIdentifier copy] autorelease];
		NSMutableSet *set = [reusableEntries objectForKey:entryKey];
		if (set == nil) {
			set = [[[NSMutableSet alloc] init] autorelease];
		}
		[set addObject:entry];
		
		[reusableEntries setObject:set forKey:entryKey];
		entriesOnScreen -= 1;
	}
}

-(void) removePreviouslyVisibleEntriesForStartingIndex:(NSIndexPath *)newStartingIndex 
										andEndingIndex:(NSIndexPath *)newEndingIndex {
	BOOL movedBackwards = (startingIndexPath.section > newStartingIndex.section);
	BOOL movedUp = (startingIndexPath.row > newStartingIndex.row);
	 
	 NSInteger startX =  movedBackwards ? newEndingIndex.section : startingIndexPath.section;
	 NSInteger endX = movedBackwards ? endingIndexPath.section : newStartingIndex.section;
	 
	 NSInteger startY = movedUp ? newEndingIndex.row : startingIndexPath.row;
	 NSInteger endY = movedUp ? endingIndexPath.row : newStartingIndex.row;
	 
	 for (NSInteger x = startX; x < endX; ++x) {
		 for (NSInteger y = startingIndexPath.row; y < newEndingIndex.row; ++y) {
			 [self removeVisibleItemForX:x andY:y];
		 }
	 }
	
	NSInteger redrawXStart = movedBackwards ? startingIndexPath.section : endX;
	NSInteger redrawXEnd = movedBackwards ? startX : endingIndexPath.section;
	 
	 for (NSInteger y = startY; y < endY; ++y) {
		 for (NSInteger x = redrawXStart; x < redrawXEnd; ++x) {
			 [self removeVisibleItemForX:x andY:y];
		 }
	 }
}

-(void) drawEntryAtPointX:(NSInteger)x andY:(NSInteger)y {
	NSIndexPath *key = [NSIndexPath indexPathForRow:y inSection:x];
	NSInteger index = IndexFromIndexPath(key, _numberOfEntriesPerRow);
	if (index >= _entryCount) {
		return;
	}
	BSGEntryView *entry = [self.datasource bsgView:self viewForEntryAtIndexPath:key];
	
	NSInteger xPoint = (x * _entrySizeWithPadding.width) + self.entryPadding.left;
	NSInteger yPoint = (y * _entrySizeWithPadding.height) + self.entryPadding.top;
	entry.frame = CGRectMake(xPoint, yPoint, self.entrySize.width, self.entrySize.height);
	
	if (xPoint > (self.contentOffset.x + self.frame.size.width)) {
		xPoint = self.contentOffset.x + self.frame.size.width;
	}
	if (yPoint > (self.contentOffset.y + self.frame.size.height)) {
		yPoint = self.contentOffset.y + self.frame.size.height;
		
	}
	
	if (!entry.superview) {
		if (!self.dragging) {
			[self addSubview:entry];
		} else {
			[self addSubview:entry];
		}
		entriesOnScreen += 1;
	}
	[visibleEntries setObject:entry forKey:key];
}

-(BOOL) isValidIndex:(NSInteger)x andY:(NSInteger)y {
	return ((y * _numberOfEntriesPerRow) + x < _entryCount) &&
			(x < _numberOfEntriesPerRow);
}

-(BOOL) isValidIndexPath:(NSIndexPath *)indexPath {
	return [self isValidIndex:indexPath.section andY:indexPath.row];
}

-(void) addNewVisibleEntriesForStartingIndex:(NSIndexPath *)newStartingIndex 
							   andEndingIndex:(NSIndexPath *)newEndingIndex {
	BOOL movedBackwards = (startingIndexPath.section > newStartingIndex.section);
	BOOL movedUp = (startingIndexPath.row > newStartingIndex.row);
	
	NSInteger startX =  movedBackwards ? newStartingIndex.section : endingIndexPath.section;
	NSInteger endX = movedBackwards ? startingIndexPath.section : newEndingIndex.section;
	
	NSInteger startY = movedUp ? newStartingIndex.row : endingIndexPath.row;
	NSInteger endY = movedUp ? startingIndexPath.row : newEndingIndex.row;
	
    for (NSInteger y = newStartingIndex.row; y < newEndingIndex.row; ++y) {
        for (NSInteger x = startX; x < endX; ++x) {
			NSIndexPath *key = [NSIndexPath indexPathForRow:y inSection:x];
            BSGEntryView *entry = [visibleEntries objectForKey:key];
			if (entry) {
//                NSInteger xPoint = (x * _entrySizeWithPadding.width) + self.entryPadding.left;
//                NSInteger yPoint = (y * _entrySizeWithPadding.height) + self.entryPadding.top;
//                NSLog(@"Old - %@", NSStringFromCGRect(entry.frame));
//                entry.frame = CGRectMake(xPoint, yPoint, self.entrySize.width, self.entrySize.height);
//                NSLog(@"new - %@", NSStringFromCGRect(entry.frame));
//                
//                if (xPoint > (self.contentOffset.x + self.frame.size.width)) {
//                    xPoint = self.contentOffset.x + self.frame.size.width;
//                }
//                if (yPoint > (self.contentOffset.y + self.frame.size.height)) {
//                    yPoint = self.contentOffset.y + self.frame.size.height;
//                
//                }
				continue;
            }
            [self drawEntryAtPointX:(NSInteger)x andY:(NSInteger)y];
			
		}
	}
	
	NSInteger redrawXStart = movedBackwards ? endX : newStartingIndex.section;
	NSInteger redrawXEnd = movedBackwards ? newEndingIndex.section : startX;
	
	for (NSInteger y = startY; y < endY; ++y) {
		for (NSInteger x = redrawXStart; x < redrawXEnd; ++x) {
			NSIndexPath *key = [NSIndexPath indexPathForRow:y inSection:x];
			
			if ([visibleEntries objectForKey:key])
				continue;
			[self drawEntryAtPointX:(NSInteger)x andY:(NSInteger)y];
		}
	}
}

- (void)redrawForLocation:(CGPoint)scrollLocation {    
	NSInteger minXIndex = MAX(floor(scrollLocation.x / _entrySizeWithPadding.width), 0);
	NSInteger maxXIndex = MIN(ceil((scrollLocation.x + self.frame.size.width) / _entrySizeWithPadding.width), 
							  _numberOfEntriesPerRow);
	
	NSInteger minYIndex = MAX(floor(scrollLocation.y / _entrySizeWithPadding.height) - preCacheColumnCount, 0);
	NSInteger maxYIndex =  MIN((ceil((scrollLocation.y + self.frame.size.height) / _entrySizeWithPadding.height) + preCacheColumnCount), 
							   _numberOfRows);
	
	NSIndexPath *newStartingIndex = [NSIndexPath indexPathForRow:minYIndex inSection:minXIndex];
	NSIndexPath *newEndingIndex = [NSIndexPath indexPathForRow:maxYIndex inSection:maxXIndex];
	
	[self removePreviouslyVisibleEntriesForStartingIndex:newStartingIndex andEndingIndex:newEndingIndex];	
	[self addNewVisibleEntriesForStartingIndex:newStartingIndex andEndingIndex:newEndingIndex];
	
	self.startingIndexPath = [NSIndexPath indexPathForRow:minYIndex inSection:minXIndex];
	self.endingIndexPath = [NSIndexPath indexPathForRow:maxYIndex inSection:maxXIndex];
}

-(NSIndexPath *) indexPathForPoint:(CGPoint)point {
	NSInteger x = point.x / _entrySizeWithPadding.width;
	NSInteger y = point.y / _entrySizeWithPadding.height;
	return [NSIndexPath indexPathForRow:y inSection:x];
}


#pragma mark 
#pragma mark Public BSGView Methods
#pragma mark -


-(BSGEntryView *) dequeReusableEntry:(NSString *)reuseIdentifier {

	NSMutableSet *set = [reusableEntries objectForKey:reuseIdentifier];
	if (set != nil) {
		BSGEntryView *entry = [set anyObject];
		if (entry != nil) {
			[[entry retain] autorelease];
			[set removeObject:entry];
            [entry prepareForReuse];
		}
		return entry;
	}
	
	return nil;
}

-(void) reloadData {
	
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.contentInset = _contentInsetsLandscape;
    } else {
        self.contentInset = _contentInsetsPortrait;
    }
    
	[startingIndexPath release], startingIndexPath = nil;
	[endingIndexPath release], endingIndexPath = nil;
	
	_entryCount = [self.datasource entryCount];
	_numberOfEntriesPerRow = [self.datasource numberOfEntriesPerRow];
	_numberOfRows = ceil(_entryCount / (double)_numberOfEntriesPerRow);

	NSInteger entryWidthWithPadding = (self.entrySize.width + self.entryPadding.left + self.entryPadding.right);
	NSInteger entryHeightWithPadding = (self.entrySize.height + self.entryPadding.top + self.entryPadding.bottom);
	_entrySizeWithPadding = CGSizeMake(entryWidthWithPadding, entryHeightWithPadding);
	
	NSInteger contentWidth = ceil((_entrySizeWithPadding.width) * _numberOfEntriesPerRow);
	NSInteger contentHeight = ceil((_entrySizeWithPadding.height) * _numberOfRows);
	self.contentSize = CGSizeMake(contentWidth, contentHeight);
	[self removeAllVisibleItems];
	
	oldBounds = self.bounds;
    
    [self redrawForLocation:self.contentOffset];
}

-(void) resetBounds {
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.contentInset = _contentInsetsLandscape;
    } else {
        self.contentInset = _contentInsetsPortrait;
    }
    
	[startingIndexPath release], startingIndexPath = nil;
	[endingIndexPath release], endingIndexPath = nil;
	
	_entryCount = [self.datasource entryCount];
	_numberOfEntriesPerRow = [self.datasource numberOfEntriesPerRow];
	_numberOfRows = ceil(_entryCount / (double)_numberOfEntriesPerRow);
    
	NSInteger entryWidthWithPadding = (self.entrySize.width + self.entryPadding.left + self.entryPadding.right);
	NSInteger entryHeightWithPadding = (self.entrySize.height + self.entryPadding.top + self.entryPadding.bottom);
	_entrySizeWithPadding = CGSizeMake(entryWidthWithPadding, entryHeightWithPadding);
	
	NSInteger contentWidth = ceil((_entrySizeWithPadding.width) * _numberOfEntriesPerRow);
	NSInteger contentHeight = ceil((_entrySizeWithPadding.height) * _numberOfRows);
	self.contentSize = CGSizeMake(contentWidth, contentHeight);
	
	oldBounds = self.bounds;
}

-(void) prepareOrientationChange {
    [self reloadData];
    return;
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.contentInset = _contentInsetsLandscape;
    } else {
        self.contentInset = _contentInsetsPortrait;
    }
    
    [startingIndexPath release], startingIndexPath = nil;
	[endingIndexPath release], endingIndexPath = nil;
    
    _numberOfEntriesPerRow = [self.datasource numberOfEntriesPerRow];
	_numberOfRows = ceil(_entryCount / (double)_numberOfEntriesPerRow);
    
    entriesOnScreen = 0;
    
    NSInteger contentWidth = ceil((_entrySizeWithPadding.width) * _numberOfEntriesPerRow);
	NSInteger contentHeight = ceil((_entrySizeWithPadding.height) * _numberOfRows);
	self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

-(void) removeAllVisibleItems {
	NSArray *indexes = [visibleEntries allKeys];
	for (NSIndexPath *index in indexes) {
		[self removeVisibleItemForX:index.section andY:index.row];
	}
}

-(void) updateSelectedEntry:(NSIndexPath *) path {
	if (![self isValidIndexPath:path]) {
		return;
	}	
	[highlightedEntry setSelected:YES animated:NO];
	[highlightedEntry release], highlightedEntry = nil;
	
	if ([_bsgViewDelegate respondsToSelector:@selector(didDeselectEntryAtIndexPath:)]) {
		[_bsgViewDelegate didDeselectEntryAtIndexPath:selectedEntry];
	} else {
		BSGEntryView *entry = [visibleEntries objectForKey:selectedEntry];
		if (entry != nil) {
			[entry setSelected:NO animated:YES];
		}
	}
			
	[selectedEntry release], selectedEntry = nil;
	
	selectedEntry = [path retain];
	if ([_bsgViewDelegate respondsToSelector:@selector(didSelectEntryAtIndexPath:)]) {
		[_bsgViewDelegate didSelectEntryAtIndexPath:selectedEntry];
	}
}


-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
	CGPoint point = [[touches anyObject] locationInView:self];
	_initialTouchPoint = point;
	
	NSIndexPath *path = [self indexPathForPoint:point];
	BSGEntryView *entry = [visibleEntries objectForKey:path];	
	if (entry != nil && CGRectContainsPoint(entry.frame, point)) {
		_touchingAnEntry = YES;
		highlightedEntry = [entry retain];
		[entry setHighlighted:YES animated:NO];
	}	
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!_touchingAnEntry) {
		return;
	}
	
	CGPoint point = [[touches anyObject] locationInView:self];
	if (highlightedEntry == nil || !CGRectContainsPoint(highlightedEntry.frame, point)) {
		_touchingAnEntry = NO;
		[highlightedEntry setHighlighted:NO animated:NO];
		[highlightedEntry release], highlightedEntry = nil;
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!_touchingAnEntry) {
		[self touchesCancelled:touches withEvent:event];
		return;
	}
	
	CGPoint point = [[touches anyObject] locationInView:self];
	NSIndexPath *path = [self indexPathForPoint:point];
	[self updateSelectedEntry:path];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	_touchingAnEntry = NO;
	if (highlightedEntry != nil) {
		[highlightedEntry setHighlighted:NO animated:NO];
		[highlightedEntry release], highlightedEntry = nil;
	}
}

-(void) layoutSubviews {
	[super layoutSubviews];
	if (entriesOnScreen == _entryCount) {
		return;
	}
	if (_entrySize.width == 0 || _entrySize.height == 0) {
		return;
	}
	
	[self redrawForLocation:self.contentOffset];
}


-(NSArray *) visibleEntries {
    return [visibleEntries allValues];
}

-(void) deselectEntryAtIndexPath:(NSIndexPath *)indexPath {
    BSGEntryView *entry = [visibleEntries objectForKey:indexPath];
    [entry setHighlighted:NO animated:NO];
    [entry setSelected:NO animated:YES];

}

@end



