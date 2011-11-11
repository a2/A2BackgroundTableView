//
//  A2BackgroundTableView.m
//
//  Created by Alexsander Akers on 9/4/11.
//  Copyright (c) 2011 Pandamonia LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "A2BackgroundTableView.h"

static NSString *const ADBackgroundImageKey = @"ADBackgroundImage";
CGFloat const A2BackgroundTableViewBleedRoom = 2000.0;

@interface A2BackgroundTableView ()

@property (nonatomic) CGFloat lastConfiguredHeight;
@property (nonatomic, retain) CALayer *backgroundLayer;

@end

@implementation A2BackgroundTableView

@synthesize backgroundImage = _backgroundImage;
@synthesize backgroundLayer = _backgroundLayer;
@synthesize lastConfiguredHeight = _lastConfiguredHeight;

- (id) initWithBackgroundImage: (UIImage *) tile
{
	return [self initWithFrame: CGRectZero backgroundImage: tile];
}
- (id) initWithFrame: (CGRect) frame
{
	return [self initWithFrame: frame backgroundImage: nil];
}
- (id) initWithFrame: (CGRect) frame backgroundImage: (UIImage *) tile
{
	NSAssert(tile != nil, @"A2BackgroundTableView must be supplied with a tileable background image.");
	if ((self = [super initWithFrame: frame style: UITableViewStyleGrouped]))
	{
		self.backgroundImage = tile;
	}
	
	return self;
}
- (id) initWithFrame: (CGRect) frame style: (UITableViewStyle) style
{
	return [self initWithFrame: frame backgroundImage: nil];
}

- (void) dealloc
{
	self.backgroundImage = nil;
	self.backgroundLayer = nil;
	
	[super dealloc];
}
- (void) setContentSize: (CGSize) contentSize
{
	[super setContentSize: contentSize];
	
	CGFloat h = MAX(CGRectGetHeight(self.bounds), contentSize.height);
	if (self.lastConfiguredHeight != h)
	{
		if (self.backgroundLayer)
		{
			CGRect r = self.backgroundLayer.frame;
			r.size.height = h + 2 * A2BackgroundTableViewBleedRoom;
			r.size.width = self.bounds.size.width;
			self.backgroundLayer.frame = r;
		}
		else
		{
			self.backgroundLayer = [CALayer layer];
			self.backgroundLayer.backgroundColor = [UIColor colorWithPatternImage: self.backgroundImage].CGColor;
			self.backgroundLayer.frame = CGRectMake(0, -A2BackgroundTableViewBleedRoom, CGRectGetWidth(self.bounds), h + 2 * A2BackgroundTableViewBleedRoom);
			self.backgroundLayer.zPosition = -1.0;
			
			[self.layer addSublayer: self.backgroundLayer];
		}
		
		[self.layer.sublayers enumerateObjectsUsingBlock: ^(CALayer *layer, NSUInteger idx, BOOL *stop) {
			if (!layer.hidden && CGRectEqualToRect(self.layer.bounds, layer.frame)) layer.hidden = YES;
		}];
		
		self.lastConfiguredHeight = h;
	}
}

#pragma mark - Coding

- (id) initWithCoder: (NSCoder *) decoder
{
	if ((self = [super initWithCoder: decoder]))
	{
		if ([decoder allowsKeyedCoding])
			self.backgroundImage = [decoder decodeObjectForKey: ADBackgroundImageKey];
		else
			self.backgroundImage = [decoder decodeObject];
	}
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
	[super encodeWithCoder: coder];
	
	if ([coder allowsKeyedCoding])
		[coder encodeObject: self.backgroundImage forKey: ADBackgroundImageKey];
	else
		[coder encodeObject: self.backgroundImage];
}

@end
