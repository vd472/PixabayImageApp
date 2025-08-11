//
//  PixabayAPIService.m
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import "PixabayAPIService.h"
#import "PixabayImageModel.h"

@interface PixabayAPIService ()
@property (nonatomic, copy) NSString *apiKey;
@end

@implementation PixabayAPIService

- (instancetype)initWithAPIKey:(NSString *)apiKey {
    if (self = [super init]) {
        _apiKey = [apiKey copy];
    }
    return self;
}

- (NSURLSessionDataTask *)searchImagesWithQuery:(NSString *)query
                                           page:(NSInteger)page
                                      completion:(PixabayAPICompletion)completion {
    if (query.length == 0) {
        if (completion) completion(@[], nil);
        return nil;
    }
    NSString *escaped = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"https://pixabay.com/api/?key=%@&q=%@&page=%ld&image_type=photo&per_page=20", self.apiKey, escaped, (long)page];
    NSURL *url = [NSURL URLWithString:urlStr];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *_, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!json || jsonError) {
            completion(nil, jsonError);
            return;
        }
        NSArray *hits = json[@"hits"];
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in hits) {
            PixabayImageModel *img = [[PixabayImageModel alloc] initWithDictionary:dict searchQuery:query];
            if (img) [images addObject:img];
        }
        completion([images copy], nil);
    }];
    [task resume];
    return task;
}

@end
