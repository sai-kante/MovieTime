//
//  MovieDetailViewController.m
//  MovieTime
//
//  Created by Sai Kante on 3/16/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *MoviePoster;
@property (weak, nonatomic) IBOutlet UILabel *Summary;
@property (weak, nonatomic) IBOutlet UILabel *Cast;
@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Movies" style:UIBarButtonItemStylePlain target:self action:@selector(onBackButton:)];
    if(self.movieDict!=NULL) {
        self.title=[NSString stringWithFormat:@"%@",[self.movieDict objectForKey:@"title"]];

        self.Cast.text = [NSString stringWithFormat:@"%@",[self.movieDict objectForKey:@"synopsis"]];
        self.Summary.text = [NSString stringWithFormat:@"%@",[self.movieDict objectForKey:@"synopsis"]];
        [self.MoviePoster setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.movieDict objectForKey:@"posters"] objectForKey:@"detailed"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
