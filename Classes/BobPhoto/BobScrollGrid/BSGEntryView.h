#import <Foundation/Foundation.h>


@interface BSGEntryView : UIView {
	
	@private
	NSString *_reuseIdentifier;
		
	BOOL _selected;
	BOOL _highlighted;
	
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
