//
//  placeholderTextView.h
//  WorkingBeez
//
//  Created by Brainstorm on 2/20/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
IB_DESIGNABLE
@interface placeholderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
