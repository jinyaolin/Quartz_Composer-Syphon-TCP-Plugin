//
//  SyphonTCPServerPlugIn.h
//  SyphonTCPServer
//
//  Created by jinyaolin on 1/19/17.
//  Copyright © 2017 TECHLIFE SG Pte.Ltd. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "TL_INetSyphonSDK/TL_INetSyphonSDK.h"

@interface SyphonTCPServerPlugIn : QCPlugIn {
    id<QCPlugInInputImageSource> inputImage;
    NSString* inputServerName;
    double inputPort;
    //NSUInteger source;
    BOOL                needsReshape;
    float               rotationRad;
    
    TL_INetTCPSyphonSDK_Server*    m_TCPSyphonSDKServer;
    GLuint                         m_SyphonCopyTexture;
    
    
}






// Declare here the properties to be used as input and output ports for the plug-in e.g.
//@property double inputFoo;
//@property (copy) NSString* outputBar;
@property (assign) id<QCPlugInInputImageSource> inputImage;
//@property (assign) NSUInteger inputSource;
@property (assign) NSString* inputServerName;

@property (assign) double inputPort;

@end
