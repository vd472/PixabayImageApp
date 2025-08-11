//
//  PixabayImageRepository.h
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import <Foundation/Foundation.h>
@class PixabayAPIService, PersistenceService, PixabayImageModel;

typedef void (^PixabayRepositoryCompletion)(NSArray<PixabayImageModel *> *images, NSError *error);

/**
 * PixabayImageRepository
 *
 * Provides a clean interface for searching images, combining data from both the remote Pixabay API
 * and local Core Data cache. Handles fetching, caching, and persistence of image results using
 * underlying service classes. Implements a repository pattern to separate data logic from UI and network code.
 */
@interface PixabayImageRepository : NSObject

- (instancetype)initWithAPIService:(PixabayAPIService *)apiService
                 persistenceService:(PersistenceService *)persistenceService;

- (void)searchImagesWithQuery:(NSString *)query
                        page:(NSInteger)page
                  completion:(PixabayRepositoryCompletion)completion;


@end

