//
//  DetailsViewController.m
//  flix
//
//  Created by Connor Clancy on 6/27/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MoviesViewController.h"
#import "FavoritesModel.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropsView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) bool flag;
@end

@implementation DetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loadingIndicator startAnimating];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.posterView setImageWithURL:posterURL];
    [self.backdropsView setImageWithURL:backdropURL];
    // set labels
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.releaseDateLabel.text = self.movie[@"release_date"];
    
    // UI Markups
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.loadingIndicator stopAnimating];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // prepare the view
}

// FAVORITE  BUTTON

- (void)addMovie:(NSDictionary *)movie {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *check = [defaults objectForKey:@"movies"];
    if (check != nil) {
        NSLog(check[0][@"title"]);
        NSLog([NSString stringWithFormat:@"type this %lu", check.count]);
        NSArray *local_movies = [defaults objectForKey:@"movies"];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:local_movies];
        [temp addObject:movie];
        NSArray *final = [NSArray arrayWithArray:temp];
        [defaults setObject:final forKey:@"movies"];
        self.flag = true;
    }
    else {
        NSMutableArray *local_movies = [[NSMutableArray alloc] init];
        [local_movies addObject:self.movie];
        [defaults setObject:(NSArray *)local_movies forKey:@"movies"];
    }
}

- (NSArray *)getMovies {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSArray *)[defaults objectForKey:@"movies"];
}



- (IBAction)favoriteButton:(id)sender {
    [self addMovie:self.movie];
    NSLog(self.movie[@"title"]);
    NSArray *mv = [self getMovies];
    NSLog([NSString stringWithFormat:@"This is the Count %lu", mv.count]);
    NSLog(mv[0][@"title"]);

}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
}
*/

@end
