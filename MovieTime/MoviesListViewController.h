//
//  MoviesListViewController.h
//  MovieTime
//
//  Created by Sai Kante on 3/15/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
+(NSString*) getCast: (NSDictionary*)movieDict;
@end
