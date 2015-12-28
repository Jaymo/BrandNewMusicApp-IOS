//
//  NSLayoutConstraint+EvenDistribution.m
//  BrandNewMusicApp
//
//

#import "NSLayoutConstraint+EvenDistribution.h"

@implementation NSLayoutConstraint (EvenDistribution)
+ (NSArray *) fluidConstraintWithItems:(NSDictionary *) dictViews
                              asString:(NSArray *) stringViews
                             alignAxis:(NSString *) axis
                        verticalMargin:(NSUInteger) vMargin
                      horizontalMargin:(NSUInteger) hMargin
                           innerMargin:(NSUInteger) iMargin

{
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity: dictViews.count];
    NSMutableString *globalFormat = [NSMutableString stringWithFormat:@"%@:|-%d-",
                                     axis,
                                     [axis isEqualToString:@"V"] ? vMargin : hMargin
                                     ];
    
    
    
    for (NSUInteger i = 0; i < dictViews.count; i++) {
        
        if (i == 0)
            [globalFormat appendString:[NSString stringWithFormat: @"[%@]-%d-", stringViews[i], iMargin]];
        else if(i == dictViews.count - 1)
            [globalFormat appendString:[NSString stringWithFormat: @"[%@(==%@)]-", stringViews[i], stringViews[i-1]]];
        else
            [globalFormat appendString:[NSString stringWithFormat: @"[%@(==%@)]-%d-", stringViews[i], stringViews[i-1], iMargin]];
        
        NSString *localFormat = [NSString stringWithFormat: @"%@:|-%d-[%@]-%d-|",
                                 [axis isEqualToString:@"V"] ? @"H" : @"V",
                                 [axis isEqualToString:@"V"] ? hMargin : vMargin,
                                 stringViews[i],
                                 [axis isEqualToString:@"V"] ? hMargin : vMargin];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:localFormat
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:dictViews]];
        
        
    }
    [globalFormat appendString:[NSString stringWithFormat:@"%d-|",
                                [axis isEqualToString:@"V"] ? vMargin : hMargin
                                ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:globalFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:dictViews]];
    
    return constraints;
    
}

@end
