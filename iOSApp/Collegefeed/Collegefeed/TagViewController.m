//
//  TagViewController.m
//  Collegefeed
//
//  Created by Patrick Sheehan on 5/13/14.
//  Copyright (c) 2014 Appuccino. All rights reserved.
//

#import "TagViewController.h"

@implementation TagViewController

-(IBAction) something
{
    NSArray *words = [self.tagsLabel.text componentsSeparatedByString:@" "];
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"#"])
        {
            NSRange range = [self.tagsLabel.text rangeOfString:word];
            
            [self.tagsLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", word]] withRange:range];
        }
    }
}

- (void)showTagsList:(NSString *)tag
{
    UIViewController* controller = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil]  instantiateViewControllerWithIdentifier:@"tagView"];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString* tagMessage = [url absoluteString];
    NSLog(@"tag = %@", tagMessage);
}

@end
