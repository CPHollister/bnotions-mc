//
//  SearchView.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

@required
- (void) readyToCloseSearchView;

@end

@interface SearchView : UIView
{
    UITextField *inputField;
    
    UIImageView *background;
    
    NSMutableArray *searches;
}

@property (nonatomic, assign) id delegate;

- (NSString *) searchValue;

@end
