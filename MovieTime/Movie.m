//
//  Movie.m
//  MovieTime
//
//  Created by Sai Kante on 3/16/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (NSString*)movieName {
    return [NSString stringWithFormat:@"%@",[self objectForKey:@"title"]];
}

- (NSString*)movieInfo {
    return [NSString stringWithFormat:@"%@",[self objectForKey:@"synopsis"]];
}

- (NSURL*)movieImageUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self objectForKey:@"posters"] objectForKey:@"thumbnail"]]];
}


@end
