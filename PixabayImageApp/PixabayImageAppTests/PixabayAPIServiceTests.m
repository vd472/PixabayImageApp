//
//  PixabayAPIServiceTests.m
//  PixabayImageAppTests
//
//  Created by vijayesha on 01.08.25.
//

#import <XCTest/XCTest.h>
#import "PixabayAPIService.h"
#import "PixabayImageModel.h"

#pragma mark - Mock NSURLProtocol

@interface MockURLProtocol : NSURLProtocol
@end

static NSData *mockedResponseData = nil;
static NSError *mockedError = nil;

@implementation MockURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request { return YES; }
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request { return request; }
- (void)startLoading {
    if (mockedError) {
        [self.client URLProtocol:self didFailWithError:mockedError];
    } else {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"application/json" expectedContentLength:mockedResponseData.length textEncodingName:nil];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:mockedResponseData];
        [self.client URLProtocolDidFinishLoading:self];
    }
}
- (void)stopLoading {}
@end

#pragma mark - Tests

@interface PixabayAPIServiceTests : XCTestCase
@property (nonatomic, strong) PixabayAPIService *service;
@end

@implementation PixabayAPIServiceTests

- (void)setUp {
    [super setUp];
    self.service = [[PixabayAPIService alloc] initWithAPIKey:@"DUMMY_KEY"];
    [NSURLProtocol registerClass:[MockURLProtocol class]];
}

- (void)tearDown {
    [NSURLProtocol unregisterClass:[MockURLProtocol class]];
    mockedResponseData = nil;
    mockedError = nil;
    [super tearDown];
}

- (void)testSearchImagesReturnsModelsOnValidJSON {
    // Arrange: fake JSON for a single image
    NSDictionary *dict = @{
        @"hits": @[
            @{
                @"id": @123,
                @"previewURL": @"http://example.com/prev.jpg",
                @"largeImageURL": @"http://example.com/large.jpg",
                @"user": @"tester",
                @"tags": @"test,apple",
                @"likes": @99,
                @"favorites": @5,
                @"comments": @1
            }
        ]
    };
    mockedResponseData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    mockedError = nil;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Completion called"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.protocolClasses = @[[MockURLProtocol class]];
    
    self.service = [[PixabayAPIService alloc] initWithAPIKey:@"DUMMY"];
    
    // Act
    NSURLSessionDataTask *task = [self.service searchImagesWithQuery:@"apple" page:1 completion:^(NSArray<PixabayImageModel *> *images, NSError *error) {
        // Assert
        XCTAssertNil(error);
        XCTAssertNotNil(images);
        XCTAssertEqual(images.count, 1);
        PixabayImageModel *img = images.firstObject;
        XCTAssertEqualObjects(img.user, @"tester");
        XCTAssertEqualObjects(img.previewURL, @"http://example.com/prev.jpg");
        XCTAssertEqual(img.likes, 99);
        [expectation fulfill];
    }];
    [task resume];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testSearchImagesHandlesNetworkError {
    // Arrange
    mockedResponseData = nil;
    mockedError = [NSError errorWithDomain:@"test" code:123 userInfo:nil];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Completion called"];
    NSURLSessionDataTask *task = [self.service searchImagesWithQuery:@"fail" page:1 completion:^(NSArray<PixabayImageModel *> *images, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(images);
        [expectation fulfill];
    }];
    [task resume];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testSearchImagesHandlesBadJSON {
    // Arrange: not JSON data
    mockedResponseData = [@"bad data" dataUsingEncoding:NSUTF8StringEncoding];
    mockedError = nil;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Completion called"];
    NSURLSessionDataTask *task = [self.service searchImagesWithQuery:@"badjson" page:1 completion:^(NSArray<PixabayImageModel *> *images, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(images);
        [expectation fulfill];
    }];
    [task resume];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testSearchImagesWithEmptyQueryReturnsEmptyArray {
    // This never hits network!
    XCTestExpectation *expectation = [self expectationWithDescription:@"Completion called"];
    NSURLSessionDataTask *task = [self.service searchImagesWithQuery:@"" page:1 completion:^(NSArray<PixabayImageModel *> *images, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(images);
        XCTAssertEqual(images.count, 0);
        [expectation fulfill];
    }];
    XCTAssertNil(task);
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end
