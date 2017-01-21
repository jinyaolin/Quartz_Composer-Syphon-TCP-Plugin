//
//  SyphonTCPServerPlugIn.m
//  SyphonTCPServer
//
//  Created by jinyaolin on 1/19/17.
//  Copyright © 2017 TECHLIFE SG Pte.Ltd. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "SyphonTCPServerPlugIn.h"

#define	kQCPlugIn_Name				@"SyphonTCPServer"
#define	kQCPlugIn_Description		@"SyphonTCPServer is a plugin for sending out Syphon Data by TCP protocols"

@implementation SyphonTCPServerPlugIn

// Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
//@dynamic inputFoo, outputBar;
@dynamic inputImage;
@dynamic inputServerName;
@dynamic inputPort;








+ (NSDictionary *)attributes
{
    // Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    // Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).
    if([key isEqualToString:@"inputImage"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Image", QCPortAttributeNameKey, nil];
    if([key isEqualToString:@"inputPort"])
        
        return [NSDictionary dictionaryWithObjectsAndKeys:
                
                @"Port", QCPortAttributeNameKey,
                
                0, QCPortAttributeDefaultValueKey,
                
                nil];
    
    if([key isEqualToString:@"inputServerName"])
        
        return [NSDictionary dictionaryWithObjectsAndKeys:
                
                @"ServerName", QCPortAttributeNameKey,
                
                @"Syphon TCP Server", QCPortAttributeDefaultValueKey,
                
                nil];
    return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
    // Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
    return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode)timeMode
{
    // Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
    return kQCPlugInTimeModeNone;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
        // Allocate any permanent resource required by the plug-in.
    }
    
    return self;
}


@end

@implementation SyphonTCPServerPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
    // Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
    // Return NO in case of fatal failure (this will prevent rendering of the composition to start).

    m_TCPSyphonSDKServer = [[TL_INetTCPSyphonSDK_Server alloc] init];
    
    [m_TCPSyphonSDKServer SetEncodeType:TCPUDPSyphonEncodeType_TURBOJPEG];
    [m_TCPSyphonSDKServer SetEncodeQuality:1.0f];


    return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
    // Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    /*
     Called by Quartz Composer whenever the plug-in instance needs to execute.
     Only read from the plug-in inputs and produce a result (by writing to the plug-in outputs or rendering to the destination OpenGL context) within that method and nowhere else.
     Return NO in case of failure during the execution (this will prevent rendering of the current frame to complete).
     
     The OpenGL context for rendering can be accessed and defined for CGL macros using:
     CGLContextObj cgl_ctx = [context CGLContextObj];
     */
    
    
    if([self didValueForInputKeyChange:@"inputPort"])
    {
        [m_TCPSyphonSDKServer SetRequestPort:self.inputPort];//If you want to set a fixed port, you can set it at here. zero is default(choose automatically).
        
    }
    
    if([self didValueForInputKeyChange:@"inputServerName"])
    {
        inputServerName=self.inputServerName;
        [m_TCPSyphonSDKServer StartServer:self.inputServerName];
        
    }
    
    if([self didValueForInputKeyChange:@"inputImage"])
    {
        id <QCPlugInInputImageSource> input = self.inputImage;
        
        if(input)
        {


            if([input lockTextureRepresentationWithColorSpace:[context colorSpace] forBounds:[input imageBounds]])
            {
                if (m_TCPSyphonSDKServer == nil)
                {
                    m_TCPSyphonSDKServer = [[TL_INetTCPSyphonSDK_Server alloc] init];
                }
                
                [m_TCPSyphonSDKServer SetSendImageByGLTexture:[context CGLContextObj] Texture:[input textureName] Width:(int)[input texturePixelsWide] Height:(int)[input texturePixelsHigh]];
                
                [input unlockTextureRepresentation];

            } else {
                [context logMessage:@"Can't obtain texture from input."];
            }
        }
    }
    
    return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
    // Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
    // Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
    [m_TCPSyphonSDKServer StopServer];
//    [m_TCPSyphonSDKServer release];
    m_TCPSyphonSDKServer = nil;
}

@end
