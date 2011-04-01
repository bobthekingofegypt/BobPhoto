#import "BSGEntryView.h"


@implementation BSGEntryView

@synthesize reuseIdentifier = _reuseIdentifier, 
			selected = _selected, 
			highlighted = _highlighted,
			backgroundView,
			contentView,
			selectedBackgroundView;


-(id) initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame])) {
        _reuseIdentifier = [reuseIdentifier copy];
		
		backgroundView = [[UIView alloc] initWithFrame:frame];
		contentView = [[UIView alloc] initWithFrame:frame];
		
		selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
		selectedBackgroundView.backgroundColor = [UIColor blackColor];
		selectedBackgroundView.alpha = 0.4;
		selectedBackgroundView.hidden = YES;
		
		[self addSubview:backgroundView];
		[self addSubview:selectedBackgroundView];
		[self addSubview:contentView];
    }
    return self;
}

-(void) prepareForReuse {
	_selected = NO;
    _highlighted = NO;
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
	_selected = selected;
	if (selected) {
		selectedBackgroundView.hidden = NO;
	} else {
		selectedBackgroundView.hidden = YES;
	}
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	_highlighted = highlighted;
	if (_highlighted) {
		selectedBackgroundView.hidden = NO;
	} else {
		selectedBackgroundView.hidden = YES;
	}
}

- (void)dealloc {
    [_reuseIdentifier release];
	[backgroundView release];
	[contentView release];
	[selectedBackgroundView release];
	[super dealloc];
}

@end
