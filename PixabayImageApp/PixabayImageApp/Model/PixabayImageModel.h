//
//  PixabayImageModel.h
//  PixabayImageApp
//
//  Created by vijayesha on 31.07.25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * PixabayImageModel
 *
 * Represents an image result from the Pixabay API, including all metadata such as
 * preview and large image URLs, user, tags, and statistics (likes, favorites, comments).
 * Provides initializers for mapping from API responses and helpers for Core Data or persistence.
 */

@interface PixabayImageModel : NSObject

@property (nonatomic, assign) NSString* imageId;
@property (nonatomic, copy) NSString *previewURL;
@property (nonatomic, copy) NSString *largeImageURL;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger favorites;
@property (nonatomic, assign) NSInteger comments;
@property (nonatomic, strong) NSString *searchQuery;

// Initialize from Pixabay API dictionary
- (instancetype)initWithDictionary:(NSDictionary *)dictionary searchQuery:(NSString *)query;
- (NSDictionary *)toDictionary;


@end

NS_ASSUME_NONNULL_END
