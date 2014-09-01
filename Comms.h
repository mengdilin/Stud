//
//  CommsDelegate.h
//  ParseStarterProject
//
//  Created by Mengdi Lin on 7/14/14.
//
//

#import <Foundation/Foundation.h>

@protocol CommsDelegate <NSObject>
@optional
-(void)commsDidLogin:(BOOL)loggedIn;
@end


@interface Comms : NSObject
//once login completes, comms class will call commsDidLogin on the delegate object
+(void)login:(id<CommsDelegate>)delegate;
@end
