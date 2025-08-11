//
//  PixabayAPIService.h
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import <Foundation/Foundation.h>

@class PixabayImageIN;

typedef void (^PixabayAPICompletion)(NSArray<PixabayImageIN *> *images, NSError *error);

/**
 * PixabayAPIService
 *
 * Handles network requests to the Pixabay API for searching images.
 * Builds and sends requests using the provided API key, parses JSON responses into model objects,
 * and delivers results asynchronously via completion handlers.
 */
@interface PixabayAPIService : NSObject

- (instancetype)initWithAPIKey:(NSString *)apiKey;
- (NSURLSessionDataTask *)searchImagesWithQuery:(NSString *)query
                                           page:(NSInteger)page
                                      completion:(PixabayAPICompletion)completion;
@end

