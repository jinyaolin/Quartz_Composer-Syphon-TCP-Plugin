//
//  AppDelegate.h
//  SampleTCPServer
//
//  Created by Nozomu MIURA on 2015/12/06.
//  Copyright © 2015 TECHLIFE SG Pte.Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GLView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    CVDisplayLinkRef			displayLink;
    NSOpenGLContext				*sharedContext;
    
    IBOutlet NSWindow			*window;
    IBOutlet GLView				*glView;

}

- (NSOpenGLPixelFormat *) createGLPixelFormat;

@end

