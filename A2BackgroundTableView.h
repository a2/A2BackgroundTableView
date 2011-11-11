//
//  A2BackgroundTableView.h
//
//  Created by Alexsander Akers on 9/4/11.
//  Copyright (c) 2011 Pandamonia LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const A2BackgroundTableViewBleedRoom;

@interface A2BackgroundTableView : UITableView

@property (nonatomic, retain) UIImage *backgroundImage;

- (id) initWithFrame: (CGRect) frame backgroundImage: (UIImage *) tile; // Designated initializer.

@end
