//
//  MapAnnotationView.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "MapAnnotationView.h"

#import "Constants.h"

@implementation MapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];

    self.image = [UIImage imageNamed:TWEET_PIN];
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSString *imgName;
    
    if( selected ) {
        
        NSLog(@"I AM THE CHOSEN ONE");
        imgName = TWEET_PIN_SELECTED;
    } else {
        imgName = TWEET_PIN;
    }
    
    self.image = [UIImage imageNamed:imgName];
    
    [super setSelected:selected animated:YES];
}


-(void)dealloc
{
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
