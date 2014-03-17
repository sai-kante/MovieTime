//
//  MoviesListViewController.m
//  MovieTime
//
//  Created by Sai Kante on 3/15/14.
//  Copyright (c) 2014 saiPersonal. All rights reserved.
//

#import "MoviesListViewController.h"
#import "MovieViewCell.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MoviesListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *MoviesList_VC;
@property (strong, nonatomic) NSArray *moviesList;

@end

@implementation MoviesListViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title=@"MoviesList";
    self.moviesList=[[NSArray alloc] init];
    
    UINib *movieCellNib= [UINib nibWithNibName:@"MovieViewCell" bundle:nil];
    [self.MoviesList_VC registerNib:movieCellNib forCellReuseIdentifier:@"MovieViewCell"];
    
    
    self.MoviesList_VC.dataSource=self;
    self.MoviesList_VC.autoresizesSubviews=false;
    self.MoviesList_VC.delegate = self;
    
    [self queryMovies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) queryMovies
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"%@", object);
        self.moviesList=[object objectForKey:@"movies"];
        //NSLog(@"%@", self.moviesList);
        [self.MoviesList_VC reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moviesList.count;
    //return moviesListTemp.count;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSDictionary *tempDictionary= [self.moviesList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"title"]];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"synopsis"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[tempDictionary objectForKey:@"posters"] objectForKey:@"thumbnail"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    
    //[cell setNeedsLayout];
    return cell;
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MovieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieViewCell"
                           forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
     NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieViewCell" owner:self options:nil];
     cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *movie=self.moviesList[indexPath.row];
    
    cell.movieNameLabel.text = [NSString stringWithFormat:@"%@",[movie objectForKey:@"title"]];;
    cell.movieDescLabel.text = [NSString stringWithFormat:@"%@",[movie objectForKey:@"synopsis"]];
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[movie objectForKey:@"posters"] objectForKey:@"thumbnail"]]] placeholderImage:[UIImage imageNamed:@"noImage.png"]];
    cell.selected=false;
    //[cell setNeedsLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailViewController *detailedView=[[MovieDetailViewController alloc] init];
    detailedView.movieDict=self.moviesList[indexPath.row];
    if(detailedView.movieDict!=NULL) {
        [self.navigationController pushViewController:detailedView animated:YES];
    }
}




@end
