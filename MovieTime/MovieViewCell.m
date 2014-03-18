//
//  MovieViewCell.m
//  MovieTime
//
//  Created by Sai Kante on 3/16/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "MovieViewCell.h"
#import "MovieDetailViewController.h"

@implementation MovieViewCell

@synthesize movieNameLabel = _movieNameLabel;
@synthesize movieDescLabel = _movieDescLabel;
@synthesize movieImage = _movieImage;
@synthesize movieCastLabel=_movieCastLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   
}

@end
