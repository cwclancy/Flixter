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
#import "TrailerViewController.h"

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
    self.navigationItem.title = @"Details";
    [self.loadingIndicator startAnimating];
    // Do any additional setup after loading the view.
    NSURL *posterURL = self.movie.posterURL;
    NSURL *backdropURL = self.movie.backdropURL;
    [self.posterView setImageWithURL:posterURL];
    [self.backdropsView setImageWithURL:backdropURL];
    // set labels
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.overview;
    self.releaseDateLabel.text = self.movie.releaseDate;
    
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

// FAVORITE LOGIC

/*
- (bool)checkIfTitleInArray:(NSString *)title {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *moviesArray = [defaults objectForKey:@"movies"];
    for (int i = 0; i < moviesArray.count; i++) {
        NSString *movieTitle = moviesArray[i][@"title"];
        if (title == movieTitle) {
            return true;
        }
    }
    return false;
}
d


- (void)addMovie:(NSDictionary *)movie {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *check = [defaults objectForKey:@"movies"];
    if (check != nil && ![self checkIfTitleInArray:self.movie.title]) {
        NSArray *local_movies = [defaults objectForKey:@"movies"];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:local_movies];
        [temp addObject:movie];
        NSArray *final = [NSArray arrayWithArray:temp];
        [defaults setObject:final forKey:@"movies"];
        self.flag = true;
    }
    else if (![self checkIfTitleInArray:self.movie.title]){
        NSMutableArray *local_movies = [[NSMutableArray alloc] init];
        [local_movies addObject:self.movie];
        [defaults setObject:(NSArray *)local_movies forKey:@"movies"];
    }
    else {
        return;
    }
}



- (NSArray *)getMovies {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSArray *)[defaults objectForKey:@"movies"];
}



- (IBAction)favoriteButton:(id)sender {
    //[self addMovie:self.movie];
    [self addMovie:[Movie movieToDict:self.movie]];
    //NSLog(self.movie[@"title"]);
    //NSArray *mv = [self getMovies];
    //NSLog([NSString stringWithFormat:@"This is the Count %lu", mv.count]);
    //NSLog(mv[0][@"title"]);

}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;
}

@end
