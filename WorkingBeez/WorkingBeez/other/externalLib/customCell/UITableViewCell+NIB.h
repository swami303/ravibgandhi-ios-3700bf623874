#import <UIKit/UIKit.h>

@interface UITableViewCell (NIB)

+ (NSString*)cellID;
+ (NSString*)nibName;
+ (id)loadCell;
+ (id)dequeOrCreateInTable:(UITableView*)tableView;

@end
