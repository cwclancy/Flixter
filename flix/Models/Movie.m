//
//  Movie.m
//  flix
//
//  Created by Connor Clancy on 7/2/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(id)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    self.title = dict[@"title"];
    self.releaseDate = dict[@"release_date"];
    self.overview = dict[@"overview"];
    self.ID = dict[@"id"];
    
    // backdrop URL
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *backdropURLString = dict[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    self.backdropURL = backdropURL;
    
    // poster URL
    NSString *posterURLString = dict[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.posterURL = posterURL;
    
    return self;
}

+(NSArray *)moviesWithDictionaries:(NSArray *)dicts {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dicts) {
        Movie *movie = [[Movie alloc] initWithDictionary:dict];
        [temp addObject:movie];
    }
    NSArray *res = [NSArray arrayWithArray:temp];
    return res;
}

+(NSDictionary *)movieToDict:(Movie *)movie {
    NSDictionary *dict = @{
                           @"title" : movie.title,
                           @"release_date" : movie.releaseDate,
                           @"overview" : movie.overview,
                           };
    return dict;
}


@end
