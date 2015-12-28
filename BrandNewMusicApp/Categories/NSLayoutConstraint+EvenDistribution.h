//
//  NSLayoutConstraint+EvenDistribution.h
//  BrandNewMusicApp
//
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (EvenDistribution)
+ (NSArray *)  fluidConstraintWithItems:(NSDictionary *) views
                               asString:(NSArray *) stringViews
                              alignAxis:(NSString *) axis
                         verticalMargin:(NSUInteger) vMargin
                       horizontalMargin:(NSUInteger) hMargin
                            innerMargin:(NSUInteger) inner;
@end
