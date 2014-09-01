static NSString * const PostCreatedNotification = @"PostCreatedNotification";



#import <CoreLocation/CoreLocation.h>

@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;



@end
