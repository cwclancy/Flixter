//
//  Movie.h
//  flix
//
//  Created by Connor Clancy on 7/2/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSURL *backdropURL;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *releaseDate;
- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)moviesWithDictionaries:(NSArray *)dicts;
+ (NSDictionary *)movieToDict:(Movie *)movie;
@end
