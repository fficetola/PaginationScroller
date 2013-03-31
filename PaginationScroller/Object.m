//
//  Beer.m
//  PaginationScroller
//
//  Copyright (c) 2013 Fr@nk. All rights reserved.


#import "Object.h"

@implementation Object

@synthesize objectId = _objectd;
@synthesize name = _name;
@synthesize description = _description;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.objectId = [[dictionary objectForKey:@"id"] intValue];
        self.name = [dictionary objectForKey:@"name"];
        self.description = [dictionary objectForKey:@"description"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Object class]]) {
        return NO;
    }
    
    Object *other = (Object *)object;
    return other.objectId == self.objectId;
}

- (void)dealloc {
    [_name release];
    [_description release];
    
    [super dealloc];
}

@end
