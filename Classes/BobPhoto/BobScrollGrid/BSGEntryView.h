#import <UIKit/UIKit.h>


@interface BSGEntryView : UIView {
	
    BOOL _selected;
	BOOL _highlighted;
    
	@private
	NSString *_reuseIdentifier;
		
	
	
	UIView *backgroundView;
	UIView *selectedBackgroundView;
	UIView *contentView;
}

@property (nonatomic, readonly) NSString *reuseIdentifier;
@property (nonatomic, readonly) BOOL selected;
@property (nonatomic, readonly) BOOL highlighted;
@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, readonly) UIView *selectedBackgroundView;
@property (nonatomic, readonly) UIView *contentView;

-(id) initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier;
-(void) prepareForReuse;
-(void) setSelected:(BOOL)selected animated:(BOOL)animated;
-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
