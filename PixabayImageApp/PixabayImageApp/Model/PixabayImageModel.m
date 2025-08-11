//
//  PixabayImageModel.m
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import "PixabayImageModel.h"

@implementation PixabayImageModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary searchQuery:(NSString *)query {
    self = [super init];
    if (self) {
        self.imageId = [dictionary[@"id"] stringValue];
        self.previewURL = dictionary[@"previewURL"];
        self.largeImageURL = dictionary[@"largeImageURL"];
        self.user = dictionary[@"user"];
        self.likes = [dictionary[@"likes"] integerValue];
        self.favorites = [dictionary[@"favorites"] integerValue];
        self.comments = [dictionary[@"comments"] integerValue];
        self.searchQuery = query;
        
        // Parse tags from comma-separated string
        NSString *tagsString = dictionary[@"tags"];
        if (tagsString && ![tagsString isEqualToString:@""]) {
            self.tags = [tagsString componentsSeparatedByString:@", "];
        } else {
            self.tags = @[];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{
        @"imageId": self.imageId ?: @"",
        @"previewURL": self.previewURL ?: @"",
        @"largeImageURL": self.largeImageURL ?: @"",
        @"user": self.user ?: @"",
        @"tags": [self.tags componentsJoinedByString:@", "] ?: @"",
        @"likes": @(self.likes),
        @"favorites": @(self.favorites),
        @"comments": @(self.comments),
        @"searchQuery": self.searchQuery ?: @""
    };
}

@end
