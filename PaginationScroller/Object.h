//
//  Beer.h
//  PaginationScroller
//


#import <Foundation/Foundation.h>

@interface Object : NSObject

@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
