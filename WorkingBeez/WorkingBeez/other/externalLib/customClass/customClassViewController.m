//
//  customClassViewController.m
//  NMT
//
//  Created by Bhavesh on 31/08/15.
//  Copyright (c) 2015 Haresh  Vavadiya. All rights reserved.
//

#import "customClassViewController.h"
#import "WorkingBeez-Bridging-Header.h"
@interface customClassViewController ()
{
    NSDictionary *dictToReturn;
    UIView *bounceView;
    
    NSURLConnection *ReqCon;
    NSMutableData *ReqData;
    
    NSString *strNotificationName;
    UIView *hudView;
}

@end

@implementation customClassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma -mark Alert

-(void)alertMessage:(NSString *)message
{
    if([message isEqualToString:@"Error on server side"])
    {
        //message = ERROR_MESSAGE;
    }
    else if([message isEqualToString:@"Successfull Transaction"])
    {
        message = @"Done! 👍";
    }
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:ALERT_TITLE message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [av show];
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:ALERT_TITLE
//                                 message:message
//                                 preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* okButton = [UIAlertAction
//                                actionWithTitle:@"Okay"
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action) {
//                                    //Handle your yes please button action here
//                                }];
//    [alert addAction:okButton];
//    
//    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)alertMessageWithTitle:(NSString *)message with :(NSString*)title
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [av show];
    
//    UIAlertController * alert = [UIAlertController
//                                 alertControllerWithTitle:title
//                                 message:message
//                                 preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* okButton = [UIAlertAction
//                               actionWithTitle:@"Okay"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action) {
//                                   //Handle your yes please button action here
//                               }];
//    [alert addAction:okButton];
//    [self presentViewController:alert animated:YES completion:nil];
}


#pragma -mark LeftView In Out
-(void)moveLeftViewIn:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.x = self.view.frame.size.width - pickerFrame.size.width;
    float animDuration = 0;
    if (animate)
    {
        if(view1.tag == 5555)
        {
            animDuration = 3;
        }
        else
        {
            animDuration = 0.3;
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}

-(void)moveLeftViewOut:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.x = self.view.frame.size.width+500;
    
    float animDuration = 0;
    
    if (animate)
    {
        animDuration = 0.3;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}

#pragma -mark RightView In Out
-(void)moveRightViewIn:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.x = 0;
    float animDuration = 0;
    if (animate)
    {
        if(view1.tag == 5556)
        {
             animDuration = 3;
        }
        else
        {
             animDuration = 0.3;
        }
       
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}

-(void)moveRightViewOut:(BOOL) animate view:(UIView *)view1
{
    
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.x =  0 - self.view.frame.size.width;
    
    float animDuration = 0;
    
    if (animate) {
        animDuration = 0.3;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}

#pragma -mark Bottom Up Down
-(void)moveBottomViewIn:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.y = self.view.frame.size.height - pickerFrame.size.height;
    float animDuration = 0;
    if (animate) {
        animDuration = 0.3;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}
-(void)moveBottomViewOut:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    float animDuration = 0;
    
    if (animate) {
        animDuration = 0.3;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}

#pragma -mark Top Up Down
-(void)moveTopViewIn:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.y = 64;
    float animDuration = 0;
    if (animate) {
        animDuration = 0.3;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}
-(void)moveTopViewOut:(BOOL) animate view:(UIView *)view1
{
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.y = 0 - pickerFrame.size.height;
    
    float animDuration = 0;
    
    if (animate) {
        animDuration = 0.3;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animDuration];
    
    view1.frame = pickerFrame;
    
    [UIView commitAnimations];
}

#pragma -HUD
-(void)showSVHud:(NSString *)str
{
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    //[SVProgressHUD showWithStatus: @"Loading" maskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD showWithStatus:str];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    /*
     @[@(DGActivityIndicatorAnimationTypeNineDots),
     @(DGActivityIndicatorAnimationTypeTriplePulse),
     @(DGActivityIndicatorAnimationTypeFiveDots),
     @(DGActivityIndicatorAnimationTypeRotatingSquares),
     @(DGActivityIndicatorAnimationTypeDoubleBounce),
     @(DGActivityIndicatorAnimationTypeTwoDots),
     @(DGActivityIndicatorAnimationTypeThreeDots),
     @(DGActivityIndicatorAnimationTypeBallPulse),
     @(DGActivityIndicatorAnimationTypeBallClipRotate),
     @(DGActivityIndicatorAnimationTypeBallClipRotatePulse),
     @(DGActivityIndicatorAnimationTypeBallClipRotateMultiple),
     @(DGActivityIndicatorAnimationTypeBallRotate),
     @(DGActivityIndicatorAnimationTypeBallZigZag),
     @(DGActivityIndicatorAnimationTypeBallZigZagDeflect),
     @(DGActivityIndicatorAnimationTypeBallTrianglePath),
     @(DGActivityIndicatorAnimationTypeBallScale),
     @(DGActivityIndicatorAnimationTypeLineScale),
     @(DGActivityIndicatorAnimationTypeLineScaleParty),
     @(DGActivityIndicatorAnimationTypeBallScaleMultiple),
     @(DGActivityIndicatorAnimationTypeBallPulseSync),
     @(DGActivityIndicatorAnimationTypeBallBeat),
     @(DGActivityIndicatorAnimationTypeLineScalePulseOut),
     @(DGActivityIndicatorAnimationTypeLineScalePulseOutRapid),
     @(DGActivityIndicatorAnimationTypeBallScaleRipple),
     @(DGActivityIndicatorAnimationTypeBallScaleRippleMultiple),
     @(DGActivityIndicatorAnimationTypeTriangleSkewSpin),
     @(DGActivityIndicatorAnimationTypeBallGridBeat),
     @(DGActivityIndicatorAnimationTypeBallGridPulse),
     @(DGActivityIndicatorAnimationTypeRotatingSandglass),
     @(DGActivityIndicatorAnimationTypeRotatingTrigons),
     @(DGActivityIndicatorAnimationTypeTripleRings),
     @(DGActivityIndicatorAnimationTypeCookieTerminator),
     @(DGActivityIndicatorAnimationTypeBallSpinFadeLoader)];
     */
    
    if(hudView != nil)
    {
        [hudView removeFromSuperview];
    }
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:249/255.0 green:82/255.0 blue:136/255.0 alpha:1]];
    hudView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    activityIndicatorView.frame = CGRectMake(0, 0, 64, 68.5714);
    [hudView addSubview:activityIndicatorView];
    hudView.tag = 555;
    activityIndicatorView.center = hudView.center;
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:hudView];
    [activityIndicatorView startAnimating];
}
-(void)hideSVHud
{
    //[SVProgressHUD dismiss];
    if(hudView != nil)
    {
        [hudView removeFromSuperview];
    }
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *vv = [[keyWindow subviews]lastObject];
    if (vv.tag == 555)
    {
        [vv removeFromSuperview];
    }
}

#pragma -mark Bounce Animation
-(void)bounceViewIn:(BOOL) animate view:(UIView *)view1
{
    bounceView = view1;
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.x = self.view.frame.size.width - pickerFrame.size.width;
    view1.frame = pickerFrame;
     [self openOverlayViewCreateAccount];
}
-(void)bounceViewOut:(BOOL) animate view:(UIView *)view1;
{
    bounceView = view1;
    CGRect pickerFrame = view1.frame;
    pickerFrame.origin.x = self.view.frame.size.width+500;
    view1.frame = pickerFrame;
    
}

-(void)openOverlayViewCreateAccount
{
    bounceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    bounceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
    
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    bounceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    bounceView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}
#pragma -mark Check Internet Connectivity
-(BOOL)checkInternet
{
    Reachability *networkRachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkRachable currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"No Internet connection" message:@"Your request cannot be completed because you are not connected to Internet. Verify your data connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@"No Internet connection"
//                                     message:@"Your request cannot be completed because you are not connected to Internet. Verify your data connection and try again."
//                                     preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* okButton = [UIAlertAction
//                                   actionWithTitle:@"Okay"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action) {
//                                       //Handle your yes please button action here
//                                   }];
//        [alert addAction:okButton];
//        [self presentViewController:alert animated:YES completion:nil];
        
        
        return NO;
    }
    return YES;
}
#pragma -mark Replace Null with String
- (NSMutableDictionary *)dictionaryByReplacingNullsWithStrings:(NSMutableDictionary *)jobList
{
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:jobList];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in [replaced allKeys])
    {
        id object = [replaced objectForKey:key];
        if (object == nul)
        {
            [replaced setObject:blank
                         forKey:key];
        }
        else
            if ([object isKindOfClass:[NSDictionary class]])
            {
                [replaced setObject:[self replaceNullInNested:object]
                             forKey:key];
            }
            else
                if ([object isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *dc = [[NSMutableArray alloc] init];
                    for (NSDictionary *tempDict in object)
                    {
                        [dc addObject:[self dictionaryByReplacingNullsWithStrings:tempDict]];
                    }
                    [replaced setObject:dc
                                 forKey:key];
                }
    }
    return replaced;
}

- (NSMutableDictionary *)replaceNullInNested:(NSMutableDictionary *)targetDict
{
    // make it to be NSMutableDictionary in case that it is nsdictionary
    NSMutableDictionary *m = [targetDict mutableCopy];
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:m];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in [replaced allKeys])
    {
        const id object = [replaced objectForKey:key];
        if (object == nul)
        {
            [replaced setObject:blank
                         forKey:key];
        }
        else
            if ([object isKindOfClass:[NSArray class]])
            {
                //            NSLog(@"found null inside and key is %@", key);
                // make it to be able to set value by create a new one
                NSMutableArray *a = [object mutableCopy];
                for (int i = 0; i < [a count]; i++)
                {
                    for (NSString *subKey in [[a objectAtIndex:i] allKeys])
                    {
                        if ([[object objectAtIndex:i] valueForKey:subKey] == nul)
                        {
                            [[object objectAtIndex:i] setValue:blank
                                                        forKey:subKey];
                        }
                    }
                }
                // replace the updated one with old one
                [replaced setObject:a
                             forKey:key];
            }
    }
    return replaced;
}
-(BOOL)validateABN : (NSString*) abn
{
    if(abn.length==11)
    {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [abn length]; i++)
        {
            [array addObject:[NSString stringWithFormat:@"%c", [abn characterAtIndex:i]]];
            if(i==0)
            {
                [array replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:0] intValue]-1]];
                [array replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:0] intValue]*10]];
            }
            else if(i==1)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*1]];
            }
            else if(i==2)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*3]];
            }
            else if(i==3)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*5]];
            }
            else if(i==4)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*7]];
            }
            else if(i==5)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*9]];
            }
            else if(i==6)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*11]];
            }
            else if(i==7)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*13]];
            }
            else if(i==8)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*15]];
            }
            else if(i==9)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*17]];
            }
            else if(i==10)
            {
                [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",[[array objectAtIndex:i] intValue]*19]];
            }
            
        }
        int sum=0;
        for (int i = 0; i < array.count; i++)
        {
            
            sum = sum+[[array objectAtIndex:i] intValue];
        }
        if(sum%89==0)
        {
            return 1;
        }
        else
        {
            return 0;
        }
        
    }
    return 0;
}

@end
