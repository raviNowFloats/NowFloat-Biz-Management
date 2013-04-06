//
//  NSString+CamelCase.m
//  NowFloatsv1
//
//  Created by Sumanta Roy on 10/09/12.
//
//

#import "NSString+CamelCase.h"

@implementation NSString (CamelCase)
-(NSString *)stringByConvertingCamelCaseToCapitalizedWords {
    
    NSMutableString *ret = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [self length]; i++) {
        unichar oneChar = [self characterAtIndex:i];
        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:oneChar])
            [ret appendFormat:@" %C", oneChar];
        else
            [ret appendFormat:@"%C", oneChar];
    }
    return [[ret capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}



@end
