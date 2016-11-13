//
//  LocalSubstitutionCache.m
//  LocalSubstitutionCache
//
//  Created by Matt Gallagher on 2010/09/06.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "LocalSubstitutionCache.h"

@implementation LocalSubstitutionCache

- (NSDictionary *)substitutionPaths
{
	return
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"fakeGlobalNavBG.png", @"http://images.apple.com/global/nav/images/globalnavbg.png",
		nil];
}

- (NSString *)mimeTypeForPath:(NSString *)originalPath
{
	//
	// Current code only substitutes PNG images
	//
	return @"image/png";	
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    //NSLog(@"cachedResponseForRequest %@",request);
//    ZSMAppDelegate *appDelegate = (ZSMAppDelegate*)[[UIApplication sharedApplication] delegate];
//	//
//	// Get the path for the request
//	//
//    //request  
////    if([request.URL.absoluteString rangeOfString:@"?"].length != 0){
////        NSString *tempUrl = [[[[request.URL.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:1] componentsSeparatedByString:@"&DATE="] objectAtIndex:0];
////        if([tempUrl rangeOfString:@"ticket="].length < 1){
////            tempUrl = [NSString stringWithFormat:@"%@?%@&ticket=%@",[[request.URL.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:0] , tempUrl, appDelegate.ticket];
////            request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:tempUrl]];
////        }
////    }
//	NSString *pathString = [[request URL] absoluteString] ;
//
//	//
//	// See if we have a substitution file for this path
//	//    
//    
//	NSString *substitutionFileName = [[self substitutionPaths] objectForKey:pathString];
//
//	if (!substitutionFileName)
//	{
//        
//        /*NSString *pathString = [[request URL] absoluteString] ;
//        NSString *cachedirpath = [[pathString stringByReplacingOccurrencesOfString:@"https:/" withString:@"https"] stringByReplacingOccurrencesOfString:@"http:/" withString:@"http"];
//        NSString *fileName = [cachedirpath lastPathComponent];
//        cachedirpath = [[cachedirpath componentsSeparatedByString:fileName] objectAtIndex:0];
//        
//        if([fileName rangeOfString:@"?"].length != 0)
//        {   
//            if([[[fileName componentsSeparatedByString:@"?"] objectAtIndex:0] isEqualToString:@"ImageView.sas"])
//            {
//                NSString *params = [[[[fileName componentsSeparatedByString:@"?"] objectAtIndex:1] componentsSeparatedByString:@"&DATE="] objectAtIndex:0];
//                NSData *encptedParamData = [params dataUsingEncoding: NSASCIIStringEncoding];
//                [Base64 initialize];
//                NSString *b64EncParam = [Base64 encode:encptedParamData];    
//                NSString *b64EncFileName = [NSString stringWithFormat:@"%@%@",b64EncParam,[[fileName componentsSeparatedByString:@"?"] objectAtIndex:0]];
//                fileName = b64EncFileName;
//                
//                BOOL isDir = NO;
//                if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",CACHE_DIR_PATH,@"https/show.zoho.com/"] isDirectory:&isDir])
//                    if(![[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",CACHE_DIR_PATH,@"https/show.zoho.com/"] withIntermediateDirectories:YES attributes:nil error:NULL]){
//                    }
//                
//                if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@%@",CACHE_DIR_PATH,@"https/show.zoho.com/",fileName]]){
//                    NSData *fileData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@%@",CACHE_DIR_PATH,@"https/show.zoho.com/",fileName]];
//                    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:@"" expectedContentLength:[fileData length] textEncodingName:nil];
//                    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
//                    NSLog(@"here");
//                    return cachedResponse;
//                }else {
//                    return [super cachedResponseForRequest:request];
//                }
//            }
//            else {
//                return [super cachedResponseForRequest:request];
//            }
//        }*/
//        
//        NSString *documentsDirectory = CACHE_DIR_PATH;
//        NSArray* tokens = [request.URL.relativePath componentsSeparatedByString:@"/"];
//        NSString *fileName = [request.URL.absoluteString lastPathComponent];
//        NSString* pathWithoutRessourceName=@"";
//        for (int i=0; i<[tokens count]-1; i++) {
//            pathWithoutRessourceName = [pathWithoutRessourceName stringByAppendingString:[NSString stringWithFormat:@"%@%@", [tokens objectAtIndex:i], @"/"]];
//        }
//        
//        if([fileName rangeOfString:@"?"].length != 0)
//        {   
//            
//            if([fileName rangeOfString:@"document.do"].length == 0)
//            {
//                NSString *params=@"";
//                params = [[[[fileName componentsSeparatedByString:@"?"] objectAtIndex:1] componentsSeparatedByString:@"&DATE="] objectAtIndex:0];
//                if(![params isEqualToString:@""])
//                {
//                    NSData *encptedParamData = [params dataUsingEncoding: NSASCIIStringEncoding];
//                    [Base64 initialize];
//                    NSString *b64EncParam = [Base64 encode:encptedParamData];    
//                    NSString *b64EncFileName = [NSString stringWithFormat:@"%@%@",b64EncParam,[[fileName componentsSeparatedByString:@"?"] objectAtIndex:0]];
//                    fileName = b64EncFileName;
//                }
//            
//                NSString* storagePath = [NSString stringWithFormat:@"%@%@%@", documentsDirectory,pathWithoutRessourceName, fileName];
//                if([[NSFileManager defaultManager] fileExistsAtPath:storagePath]){
//                    NSData *fileData = [NSData dataWithContentsOfFile:storagePath];
//                    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:@"" expectedContentLength:[fileData length] textEncodingName:nil];
//                    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
//                    
//                    return cachedResponse;
//                }else {
//                    return [super cachedResponseForRequest:request];
//                }
//                
//            }else {
//                
//                return [super cachedResponseForRequest:request];
//            }
//            
//        }else {
//            NSString *params=@"";
//            params = [[fileName componentsSeparatedByString:@"&DATE="] objectAtIndex:0];
//            if(![params isEqualToString:@""])
//            {
//                NSData *encptedParamData = [params dataUsingEncoding: NSASCIIStringEncoding];
//                [Base64 initialize];
//                NSString *b64EncParam = [Base64 encode:encptedParamData];    
//                NSString *b64EncFileName = [NSString stringWithFormat:@"%@%@",b64EncParam,[[fileName componentsSeparatedByString:@"?"] objectAtIndex:0]];
//                fileName = b64EncFileName;
//            }
//            NSString* storagePath = [NSString stringWithFormat:@"%@%@%@", documentsDirectory,pathWithoutRessourceName, fileName];
//            if([[NSFileManager defaultManager] fileExistsAtPath:storagePath]){
//                NSData *fileData = [NSData dataWithContentsOfFile:storagePath];
//                NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:@"" expectedContentLength:[fileData length] textEncodingName:nil];
//                NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
//
//                return cachedResponse;
//            }else {
//                return [super cachedResponseForRequest:request];
//            }
//        }
        
        return [super cachedResponseForRequest:request];
	//}
	
	//
	// If we've already created a cache entry for this path, then return it.
	//
//	NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:pathString];
//	if (cachedResponse)
//	{
//		return cachedResponse;
//	}
//	
//	//
//	// Get the path to the substitution file
//	//
//	NSString *substitutionFilePath =
//		[[NSBundle mainBundle]
//			pathForResource:[substitutionFileName stringByDeletingPathExtension]
//			ofType:[substitutionFileName pathExtension]];
//	NSAssert(substitutionFilePath, @"File %@ in substitutionPaths didn't exist", substitutionFileName);
//	
//	//
//	// Load the data
//	//
//	NSData *data = [NSData dataWithContentsOfFile:substitutionFilePath];
//	
//	//
//	// Create the cacheable response
//	//
//	NSURLResponse *response =
//		[[NSURLResponse alloc]
//			initWithURL:[request URL]
//			MIMEType:[self mimeTypeForPath:pathString]
//			expectedContentLength:[data length]
//			textEncodingName:nil]
//		;
//	cachedResponse =
//		[[NSCachedURLResponse alloc] initWithResponse:response data:data] ;
//	
//	//
//	// Add it to our cache dictionary
//	//
//	if (!cachedResponses)
//	{
//		cachedResponses = [[NSMutableDictionary alloc] init];
//	}
//	[cachedResponses setObject:cachedResponse forKey:pathString];
//	
//	return cachedResponse;
//}
//
//- (void)removeCachedResponseForRequest:(NSURLRequest *)request
//{
//	//
//	// Get the path for the request
//	//
//    
//	NSString *pathString = [[request URL] path];
//	if ([cachedResponses objectForKey:pathString])
//	{
//		[cachedResponses removeObjectForKey:pathString];
//	}
//	else
//	{
//		[super removeCachedResponseForRequest:request];
//	}
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
//    NSLog(@"storeCachedResponse size %i %@",[cachedResponse.data length],request);
//    
//    
//    NSString *documentsDirectory = CACHE_DIR_PATH;
//    NSArray* tokens = [request.URL.relativePath componentsSeparatedByString:@"/"];
//    NSString *fileName = [request.URL.absoluteString lastPathComponent];
//    NSString* pathWithoutRessourceName=@"";
//    for (int i=0; i<[tokens count]-1; i++) {
//        pathWithoutRessourceName = [pathWithoutRessourceName stringByAppendingString:[NSString     stringWithFormat:@"%@%@", [tokens objectAtIndex:i], @"/"]];
//    }
//
//    NSString* absolutePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, pathWithoutRessourceName];
//    
//    if([fileName rangeOfString:@"?"].length != 0)
//    {   if([fileName rangeOfString:@"document.do"].length == 0)
//        {
//            NSString *params=@"";
//            params = [[[[fileName componentsSeparatedByString:@"?"] objectAtIndex:1] componentsSeparatedByString:@"&DATE="] objectAtIndex:0];
//            if(![params isEqualToString:@""])
//            {
//                
//                NSData *encptedParamData = [params dataUsingEncoding: NSASCIIStringEncoding];
//                [Base64 initialize];
//                NSString *b64EncParam = [Base64 encode:encptedParamData];    
//                NSString *b64EncFileName = [NSString stringWithFormat:@"%@%@",b64EncParam,[[fileName componentsSeparatedByString:@"?"] objectAtIndex:0]];
//                fileName = b64EncFileName;
//            }
//            NSString* storagePath = [NSString stringWithFormat:@"%@%@%@", documentsDirectory,pathWithoutRessourceName, fileName];
//        //NSLog(@"storagePath %@",storagePath);
//            NSData* content;
//            NSError* error = nil;
//            content = cachedResponse.data;
//            [[NSFileManager defaultManager] createDirectoryAtPath:absolutePath withIntermediateDirectories:YES attributes:nil error:&error];
//            BOOL ok;
//            ok = [content writeToFile:storagePath atomically:YES];
//        }else {
//            [super storeCachedResponse:cachedResponse forRequest:request];
//        }
//        
//    }else {
//        NSString *params=@"";
//        params = [[fileName componentsSeparatedByString:@"&DATE="] objectAtIndex:0];
//
//        if(![params isEqualToString:@""])
//        {
//            NSData *encptedParamData = [params dataUsingEncoding: NSASCIIStringEncoding];
//            [Base64 initialize];
//            NSString *b64EncParam = [Base64 encode:encptedParamData];    
//            NSString *b64EncFileName = [NSString stringWithFormat:@"%@%@",b64EncParam,[[fileName componentsSeparatedByString:@"?"] objectAtIndex:0]];
//            fileName = b64EncFileName;
//        }
//        NSString* storagePath = [NSString stringWithFormat:@"%@%@%@", documentsDirectory,pathWithoutRessourceName, fileName];
//        NSData* content;
//        NSError* error = nil;
//        content = cachedResponse.data;
//        [[NSFileManager defaultManager] createDirectoryAtPath:absolutePath withIntermediateDirectories:YES attributes:nil error:&error];
//        BOOL ok;
//        ok = [content writeToFile:storagePath atomically:YES];
//
//    }
    
    [super storeCachedResponse:cachedResponse forRequest:request];
}

@end
