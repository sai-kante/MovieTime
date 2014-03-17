//
//  MovieViewCell.h
//  MovieTime
//
//  Created by Sai Kante on 3/16/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *movieNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *movieDescLabel;
@property (nonatomic, weak) IBOutlet UIImageView *movieImage;

@end
