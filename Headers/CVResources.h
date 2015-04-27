//
//  CVResources.h
//  Convergance
//
//  Created by Matt Clarke on 21/07/2013.
//
//

#import <Foundation/Foundation.h>
//#import <SpringBoard6.0/SBAwayBulletinListItem.h>
#import <BulletinBoard/BBBulletin.h>
#import <QuartzCore/QuartzCore.h>
//#import <SpringBoard6.0/SBWorkspace.h>

@interface CVResources : NSObject 

+(void)setIsUnlocking:(BOOL)val;
+(BOOL)getIsUnlocking;

+(BOOL)unlockedWithBulletin;
+(void)setUnlockedWithBulletin:(BOOL)val;

//+(void)addBulletinToAvailableLockNotifications:(SBAwayBulletinListItem*)bulletin atIndexPath:(NSIndexPath*)path;
//+(void)removeBulletinFromAvailableLockNotifications:(SBAwayBulletinListItem*)bulletin;
+(void)addBundleIdToLockBulletinList:(NSString*)identifier;
+(void)removeBundleIdFromLockBulletins:(NSString*)identifier;
+(void)emptyLockBulletinList;
+(NSMutableArray*)getAvailableLockNotifications;
+(NSMutableArray*)getLockBulletinIds;
+(void)emptyAvailableLockBulletins;

+(void)setLockFullscreenNotificationIndexPath:(NSIndexPath*)row;
+(int)getLockFullscreenNotificationIndexPath;
+(void)addNewBBBulletin:(BBBulletin*)bulletin toDictionaryWithKey:(NSString*)key;
+(void)removeBBBulletin:(BBBulletin*)bulletin fromDictionaryWithKey:(NSString*)key;
+(NSMutableArray*)arrayfromLockNotificationDictionaryForKey:(NSString*)key;
+(void)setLockFullscreenNotificationBundleId:(NSString*)bundleid;
+(NSString*)getLockFullscreenNotificationBundleId;
+(void)setShowingLockFullscreenNotification:(BOOL)enabled;
+(BOOL)getShowingLockFullscreenNotification;
+(void)setLockFullscreenBBBulletin:(id)bulletin;
+(BBBulletin*)getLockFullscreenBBBulletin;
+(void)setOriginalLockNotifCellRect:(CGRect)rect;
+(CGRect)getOriginalLockNotifCellRect;

+(void)setLockWorkspace:(id)workspace;
//+(SBWorkspace*)getLockWorkspace;
+(void)removeLockWorkspace;

+(BOOL)biteSMSQrEnabled;
+(BOOL)couriaEnabledForBulletin:(NSString*)arg1;
+(BOOL)dontUseCustomNotificationIcons;

+(BOOL)isGuestModeEnabled;

+(BOOL)overridePasscodeSet;

+(float)perceivedBrightnessOfImage:(UIImage*)image inRect:(CGRect)rect;
+(BOOL)hasLightWallpaper;

+(NSString*)themedResourceFilePathWithName:(NSString*)name andExtension:(NSString*)ext;
+(NSString*)themedBundleFilePathWithName:(NSString*)name;
+(NSString*)localisedStringForKey:(NSString*)key value:(NSString*)val;

+(BOOL)lockScreenEnabled;
+(void)setCachedLockscreenNil;
+(BOOL)showBatteryPercent;
+(NSArray*)lockWidgets;
+(NSArray*)lockToggles;
+(int)lockBlurRadius;
+(BOOL)isUsingLightFonts;
+(int)lockArtworkVariant;
+(BOOL)isFirstLock;
+(void)setIsFirstLock:(BOOL)set;
+(BOOL)lockedYet;
+(void)setLockedYet:(BOOL)val;
+(BOOL)needsRefreshLockWallpaper;
+(void)setNeedsRefreshLockWallpaper:(BOOL)set;

+(BOOL)lockHTMLEnabled;
+(NSString*)lockHTMLTheme;
+(BOOL)lockHTMLDoesScroll;

+(void)setDontAnimateOut:(BOOL)dontAnimate;
+(BOOL)getDontAnimateOut;
+(void)setCurrentPasscodeDictionary:(NSDictionary*)dict;
+(NSDictionary*)getCurrentPasscodeDictionary;

+(void)reloadSettings;
+(void)reloadNotificationInformation;

@end
