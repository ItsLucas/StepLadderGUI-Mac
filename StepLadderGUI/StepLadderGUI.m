//
//  StepLadderGUI.m
//  StepLadderGUI
//
//  Created by Lucas on 1/24/15.
//  Copyright (c) 2015 LucasWorkShop. All rights reserved.
//

#import "StepLadderGUI.h"
#import <Foundation/Foundation.h>
#import <Foundation/NSTask.h>
@implementation StepLadderGUI
- (IBAction)startServer:(id)sender
{
    [self appendString:@"Loading Config...\n"];
    [self appendString:@"Starting StepLadder Server...\n"];
    //Get resource folder to launch
    NSBundle *bundle = [NSBundle mainBundle];
    NSMutableString *s = [NSMutableString stringWithString:[bundle resourcePath]];
    NSMutableString *wp = [NSMutableString stringWithString:[bundle resourcePath]];
    resPath = wp;
    NSMutableString *append = [NSMutableString stringWithString:@"/client"];
    [s appendString:append];
    NSLog(s);
    [self runCommand:s:wp:[NSArray arrayWithObjects:s,nil]];
}
- (IBAction)stopServer:(id)sender
{
    [self appendString:@"Stopping Server...\n"];
    if(task)
    {
        [task interrupt];
    }
    else
    {
        [self appendString:@"Server not running!\n"];
    }
}
- (IBAction)editConfig:(id)sender //W.I.P. Who can finish it?
{
    NSMutableString *configPath = [NSMutableString stringWithString:resPath];
    NSMutableString *append2 = [NSMutableString stringWithString:@"/client.ini"];
    [configPath appendString:append2];
    [[NSWorkspace sharedWorkspace] openFile:configPath withApplication:@"TextEdit"];
}
- (void)runCommand:(NSString *)cmdname:(NSString *)workPath:(NSArray*)args{
    task = [[NSTask alloc]init];
    [task setLaunchPath:cmdname];
    [task setArguments:args];
    [task setCurrentDirectoryPath:workPath];
    pipe = [[NSPipe alloc]init];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    NSFileHandle *fh = [pipe fileHandleForReading];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [nc addObserver:self
           selector:@selector(dataReady:)
               name:NSFileHandleReadCompletionNotification
             object:fh];
    [nc addObserver:self
           selector:@selector(taskTerminated:)
               name:NSTaskDidTerminateNotification
             object:task];
    NSTextStorage *ts = [outputConsole textStorage];
    [task launch];
    [fh readInBackgroundAndNotify];
}
- (void)dataReady: (NSNotification *)n{
    NSData *d;
    d= [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
    if([d length]){
        [self appendData:d];
    }
    if (task){
        [[pipe fileHandleForReading] readInBackgroundAndNotify];
    }
}
- (void)appendData: (NSData *)d{
    NSString *s = [[NSString alloc] initWithData:d
                                        encoding:NSUTF8StringEncoding];
    NSTextStorage *ts = [outputConsole textStorage];
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:s];
}
- (void)appendString: (NSString *)s{
    NSTextStorage *ts = [outputConsole textStorage];
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:s];
}
- (void)taskTerminated: (NSNotification *)note{
    task = nil;
}

@end
