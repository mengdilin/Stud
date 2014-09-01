//
//  CommsDelegate.m
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/14/14.
//
//

#import "Comms.h"

@implementation Comms

+(void)login:(id<CommsDelegate>)delegate
{
    //Basic user info and list of friends
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        //was login successful
        if(!user)
        {
            if(!error)
            {
                //should be replaced
                NSLog(@"The user cancelled the Facebook login");
            }
            else
            {
                NSLog(@"An error occurred %@",error.localizedDescription);
            }
        }
        else
        {
            if(user.isNew)
            {
                NSLog(@"User signed up and loggined in through Facebook!");
                
            }
            else
            {
                //should be replaced
                NSLog(@"User logged in through Facebook!");
            }
            
            //callback - login successful
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if(!error)
                {
                    PFUser *user = [PFUser currentUser];
                    NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
                    [user setObject:me.objectID forKey:@"fbId"];
                    
                    //NSString *fullname = [NSString stringWithFormat:@"%@ %@",me.first_name,me.last_name];
                    [user setObject:me.name forKey:@"FullName"];
                    [user saveInBackground];
                }
                
                if([delegate respondsToSelector:@selector(commsDidLogin:)])
                {
                    [delegate commsDidLogin:YES];
                }
            }];
            
        }
    }];
}
@end
