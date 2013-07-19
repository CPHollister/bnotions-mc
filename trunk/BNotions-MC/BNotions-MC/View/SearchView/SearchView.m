//
//  SearchView.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "SearchView.h"

#import "Constants.h"

@implementation SearchView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SEARCH_BAR]];
        [self addSubview:background];
        
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(14, 12, 240, 23)];
        inputField.backgroundColor = [UIColor clearColor];
        inputField.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:18];
        inputField.placeholder = @"Search on Twitter";
        inputField.autocorrectionType = UITextAutocorrectionTypeNo;
        inputField.returnKeyType = UIReturnKeyDone;
        [inputField addTarget:self action:@selector(inputFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];

        [self addSubview:inputField];
    }
    return self;
}

- (void)inputFieldDone:(id)sender
{
    if( [self.delegate respondsToSelector:@selector(readyToCloseSearchView)] ) {
        [self.delegate readyToCloseSearchView];
    }
}


- (void) onRotationGesture:(UIGestureRecognizer *)gesture
{
        
}


- (NSString *) searchValue
{
    return inputField.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) dealloc
{
    [inputField release];
    inputField = nil;
        
    [super dealloc];
}

@end
