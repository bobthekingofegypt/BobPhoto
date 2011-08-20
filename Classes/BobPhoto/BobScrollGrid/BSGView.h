#import <UIKit/UIKit.h>
#import "BSGEntryView.h"

@protocol BSGDatasource;
@protocol BSGViewDelegate;



@interface BSGView : UIScrollView<UIScrollViewDelegate> {
	id<BSGDatasource> _datasource;
	id<BSGViewDelegate> _bsgViewDelegate;
	
	UIEdgeInsets _entryPadding;
	CGSize _entrySize;
	
	@private
	CGSize _entrySizeWithPadding;
	NSInteger _numberOfRows;
	NSInteger _entryCount;
	NSInteger _numberOfEntriesPerRow;
	NSMutableDictionary *visibleEntries;
	NSMutableDictionary *reusableEntries;
	NSIndexPath *startingIndexPath;
	NSIndexPath *endingIndexPath;
	BSGEntryView *highlightedEntry;
	NSIndexPath *selectedEntry;
	CGPoint _initialTouchPoint;
	BOOL _touchingAnEntry;
	
	NSInteger entriesOnScreen;
	
	CGRect oldBounds;
	NSMutableDictionary *oldVisibleEntries;
    
    
    UIEdgeInsets _contentInsetsLandscape;
    UIEdgeInsets _contentInsetsPortrait;
    
    NSInteger preCacheColumnCount;
}

@property (nonatomic, assign) id<BSGDatasource> datasource;
@property (nonatomic, assign) id<BSGViewDelegate> bsgViewDelegate;
@property (nonatomic, assign) UIEdgeInsets entryPadding;
@property (nonatomic, assign) CGSize entrySize;
@property (nonatomic, readonly) NSInteger numberOfEntriesPerRow;
@property (nonatomic, assign) NSInteger preCacheColumnCount;
@property (nonatomic, assign) UIEdgeInsets contentInsetsLandscape;
@property (nonatomic, assign) UIEdgeInsets contentInsetsPortrait;
@property (nonatomic, assign) NSIndexPath *selectedEntry;

-(id) initWithFrame:(CGRect)frame;
-(void) reloadData;
-(BSGEntryView *) dequeReusableEntry:(NSString *)reuseIdentifier;
-(NSArray *) visibleEntries;
-(void) prepareOrientationChange;
-(void) deselectEntryAtIndexPath:(NSIndexPath *)indexPath;
-(void) resetBounds;

@end



@protocol BSGDatasource

-(BSGEntryView *)bsgView:(BSGView *)bsgView viewForEntryAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger) entryCount;
-(NSInteger) numberOfEntriesPerRow;

@end


@protocol BSGViewDelegate<NSObject>

@optional
-(void) didSelectEntryAtIndexPath:(NSIndexPath *) index;
-(void) didDeselectEntryAtIndexPath:(NSIndexPath *) index;

@end

#ifndef BSGUtil
#define BSGUtil

NSInteger IndexFromIndexPath(NSIndexPath *path, NSInteger entriesPerRow);

#endif


