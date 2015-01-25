//
//  StepLadderGUI.h
//  StepLadderGUI
//
//  Created by Lucas on 1/24/15.
//  Copyright (c) 2015 LucasWorkShop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
@interface StepLadderGUI : NSObject{
    NSTask *task;
    NSPipe *pipe;
    IBOutlet NSTextView *outputConsole;
}
- (IBAction)startServer:(id)sender;
- (IBAction)stopServer:(id)sender;
- (IBAction)editConfig:(id)sender;
@end
