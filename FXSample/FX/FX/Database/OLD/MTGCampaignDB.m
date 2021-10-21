
//  MTGCampaignDB.m
//  MTGSDK
//
//  Created by Tony on 15/10/28.
//

#import "MTGCampaignDB.h"
#import "MTGDatabaseManager.h"
#import "MTGFrame.h"
#import "MTGCampaignExp.h"
#import "MTGVideoTrackingInfo.h"
#import "WhereModel.h"
#import "SQLAdaptor.h"
#import "MTGBaseConstants.h"
#import "MTGSKAdItem.h"

#define TABLE_NAME @"campaign"
#define C_ID @"id"
#define C_UNIT_ID @"unitid"
#define C_TAB @"tab"
#define C_PKG_NAME @"package_name"
#define C_NAME @"app_name"
#define C_DESC @"app_desc"
#define C_SIZE @"app_size"
#define C_IMAGE_SIZE @"image_size"
#define C_ICON_URL @"icon_url"
#define C_IMAGE_URL @"image_url"
#define C_IMPRESSION_URL @"impression_url"
#define C_NOTICE_URL @"notice_url"
#define C_CLICK_URL @"click_url"
#define C_ONLY_IMPRESSION_URL @"only_impression"
#define C_TEMPLATE @"template"
#define C_DATA_TEMPLATE @"data_template"
#define C_LANDING_TYPE @"landing_type"
#define C_CLICK_MODE @"click_mode"
#define C_STAR @"star"
#define C_NUMBERRATING @"number_rating"
#define C_TIMESTAMP @"ts"
#define C_CLICK_TIMEOUT @"click_ts"
#define C_FRAME_ID @"frame_id"
#define C_URL_LIST @"ad_url_list"

#define C_AD_SOURCE_ID @"ad_source_id"  //adSourceId
#define C_FCA @"fca"
#define C_FCB @"fcb"


#define C_VIDEO_URL_ENCODE @"video_url_encode"
#define C_VIDEO_LENGTH @"video_length"
#define C_VIDEO_SIZE @"video_size"
#define C_VIDEO_RESOLUTION @"video_resolution"



#define C_OFFER_COST_TYPE @"ctype"

#define C_LINK_TYPE @"link_type"

#define C_ADCALL @"adCall"

#define C_STOREKIT @"storekit"

#define C_MD5FILE @"md5file"

#define C_GUIDE_LINES @"guidelines"
#define C_REWARD_AMOUNT @"reward_amount"
#define C_REWARD_NAME @"reward_name"
#define C_HTML_URL @"html_url"
#define C_END_SCREEN_URL @"end_screen_url"

#define C_ADV_IMP @"adv_imp"

#define C_TRACKING_INFO @"tracking_info"

#define C_OTHER_FIELD_INFOS @"other_field_infos"

#define OTHER_ADSWITHOUTVIDE @"adsWithoutVideo"
#define OTHER_ENDCARDURL @"endcardURL"
#define OTHER_VIDEOENDTYPE @"videoEndType"

#define OTHER_VIDEOTEMPATEID @"video_template"
#define OTHER_TEMPLATE_URL @"template_url"
#define OTHER_ORENTATION @"orientation"
#define OTHER_PAUSEDURL @"paused_url"
#define OTHER_IMAGEDICTIONARY @"image"

#define C_ADSWITHOUTVIDE @"adsWithoutVideo"
#define C_ENDCARDURL @"endcardURL"
#define C_VIDEOENDTYPE @"videoEndType"

#define C_VIDEOTEMPATEID @"video_template"
#define C_TEMPLATE_URL @"template_url"
#define C_ORENTATION @"orientation"
#define C_PAUSEDURL @"paused_url"
#define C_IMAGEDICTIONARY @"image"

#define C_NATIVEVIDEOSECONDJUMPTEMPLATE @"nativeVideoSecondJumpTemplate"
#define C_NATIVEVIDEOGIFURL @"nativeVideoGIFUrl"

#define C_STOREKIT_LOAD_TIME @"storeLoadTime"
#define C_NOTICE_AND_CLICK_TRIGGERED_TIME_INTERVAL @"noticeAndClickTriggeredTimeInterval"

#define C_CAMPAIGN_EXTENSION_PARA_1 @"campaignExtensionPara1"
#define C_CAMPAIGN_EXTENSION_PARA_2 @"campaignExtensionPara2"
#define C_INTERACTIVEENTRANCEICON @"InteractiveEntranceIcon"
#define C_INTERACTIVERESOURCETYPE @"InteractiveResourceType"
#define C_INTERACTIVETEMPLATEURL @"InteractiveTemplateUrl"
#define C_INTERACTIVEADSORIENTATION @"interactiveAdsOrientation"
#define C_CAMPAIG_UNIT_EXTENSION_PARA_1 @"CampaignUnitExt1"
#define C_CAMPAIG_UNIT_EXTENSION_PARA_2 @"CampaignUnitExt2"

#define C_CAMPAIGN_ADTYPE @"campaignAdType"
#define C_CAMPAIGN_DEEPLINK @"deep_link"


#define C_IMPRESSIONUA @"impressionUA"
#define C_CLICKUA @"clickUA"

// v490 AdChoices begin
#define C_ADCHOICEICON @"adc_icon"
#define C_ADCHOICESIZE @"adc_size"
#define C_ADCHOICELINK @"adc_link"
#define C_PLATFORMNAME @"adc_platformName"
#define C_PLATFORMLOGO @"adc_platformLogo"
#define C_ADCHOICEADVNAME @"adc_advName"
#define C_ADCHOICEADVLOGO @"adc_advLogo"
#define C_ADCHOICEADVLINK @"adc_advLink"
// v490 AdChoices end

// v520 added, begin
#define C_CACHEAVAILABLEINTERVAL @"plct"
#define C_CACHERESERVEINTERVAL @"plctb"
// v520 added, end

#define C_BIDTOKEN @"bid_token"
#define C_ISBID    @"bid_flag"
#define C_UNIQUEID @"unique_id"
#define C_LocalMraidFileName @"mraid_file_name"

#define C_OMID @"omid"


#define C_SUPERTEMPLATEURL @"super_template_url"
#define C_SUPERTEMPLATEID @"super_template_id"
#define C_READYRATE @"ready_rate"
#define C_EXTRADATA @"ext_data"
#define C_UNITEXTRADATA @"req_ext_data"
#define C_WAITALLOFFERS @"wait_all_offers"
#define C_PVURLS @"pv_urls"

// 600
#define C_WebviewTemplateUrl      @"webview_template_url"
#define C_WebviewTemplateHtmlPath @"webview_template_path"

#define C_PlacementId @"placementId"

// 650
#define C_SKAD_INFO @"skad_info"

#define C_SKADIMP_INFO @"skimp"

#define C_PCM_INFO @"pcm"

//reward
#define C_RewardPL @"rw_pl"
// 700 add
#define C_Flb @"flb"
#define C_FlbSkiptime @"flb_skiptime"


#define C_REQUESTID @"rid"
#define C_VCN @"vcn"


// end

@implementation MTGCampaignDB

#pragma mark - 数据库表操作
+ (void)createDatabase{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        
        NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(DataTypeText),C_ID,
                                   @(DataTypeText),C_UNIT_ID,
                                   @(DataTypeInteger),C_TAB,
                                   @(DataTypeText),C_PKG_NAME,
                                   @(DataTypeText),C_NAME,
                                   @(DataTypeText),C_DESC,
                                   @(DataTypeText),C_SIZE,
                                   @(DataTypeText),C_IMAGE_SIZE,
                                   @(DataTypeText),C_ICON_URL,
                                   @(DataTypeText),C_IMAGE_URL,
                                   @(DataTypeText),C_IMPRESSION_URL,
                                   @(DataTypeText),C_NOTICE_URL,
                                   @(DataTypeText),C_CLICK_URL,
                                   @(DataTypeText),C_ONLY_IMPRESSION_URL,
                                   @(DataTypeInteger),C_TEMPLATE,
                                   @(DataTypeInteger),C_DATA_TEMPLATE,
                                   @(DataTypeText),C_LANDING_TYPE,
                                   @(DataTypeText),C_CLICK_MODE,
                                   @(DataTypeText),C_STAR,
                                   @(DataTypeInteger),C_NUMBERRATING,
                                   @(DataTypeReal),C_TIMESTAMP,
                                   @(DataTypeReal),C_CLICK_TIMEOUT,
                                   @(DataTypeText),C_FRAME_ID,
                                   @(DataTypeInteger),C_AD_SOURCE_ID,
                                   @(DataTypeInteger),C_FCA,
                                   @(DataTypeInteger),C_FCB,
                                   @(DataTypeText),C_URL_LIST,
                                   @(DataTypeText),C_VIDEO_URL_ENCODE,
                                   @(DataTypeInteger),C_VIDEO_LENGTH,
                                   @(DataTypeReal),C_VIDEO_SIZE,
                                   @(DataTypeText),C_VIDEO_RESOLUTION,
                                   @(DataTypeInteger),C_OFFER_COST_TYPE,
                                   @(DataTypeInteger),C_LINK_TYPE,
                                   @(DataTypeText),C_ADCALL,
                                   @(DataTypeText),C_GUIDE_LINES,
                                   @(DataTypeReal),C_REWARD_AMOUNT,
                                   @(DataTypeText),C_REWARD_NAME,
                                   @(DataTypeText),C_HTML_URL,
                                   @(DataTypeText),C_END_SCREEN_URL,
                                   @(DataTypeText),C_ADV_IMP,
                                   @(DataTypeText),C_TRACKING_INFO,
                                   @(DataTypeText),C_ENDCARDURL,
                                   @(DataTypeInteger),C_VIDEOENDTYPE,
                                   @(DataTypeInteger),C_ADSWITHOUTVIDE,
                                   @(DataTypeInteger),C_VIDEOTEMPATEID,
                                   @(DataTypeText),C_TEMPLATE_URL,
                                   @(DataTypeInteger),C_ORENTATION,
                                   @(DataTypeText),C_PAUSEDURL,
                                   @(DataTypeText),C_IMAGEDICTIONARY,
                                   @(DataTypeInteger),C_STOREKIT,
                                   @(DataTypeText),C_MD5FILE,
                                   @(DataTypeInteger),C_NATIVEVIDEOSECONDJUMPTEMPLATE,
                                   @(DataTypeText),C_NATIVEVIDEOGIFURL,
                                   @(DataTypeInteger),C_IMPRESSIONUA,
                                   @(DataTypeInteger),C_CLICKUA,
                                   @(DataTypeInteger),C_STOREKIT_LOAD_TIME,
                                   @(DataTypeReal),C_NOTICE_AND_CLICK_TRIGGERED_TIME_INTERVAL,
                                   @(DataTypeText),C_CAMPAIGN_EXTENSION_PARA_1,
                                   @(DataTypeText),C_CAMPAIGN_EXTENSION_PARA_2,
                                   @(DataTypeText),C_INTERACTIVEENTRANCEICON,
                                   @(DataTypeInteger),C_INTERACTIVERESOURCETYPE,
                                   @(DataTypeText),C_INTERACTIVETEMPLATEURL,
                                   @(DataTypeInteger),C_INTERACTIVEADSORIENTATION,
                                   @(DataTypeText),C_CAMPAIG_UNIT_EXTENSION_PARA_1,
                                   @(DataTypeText),C_CAMPAIG_UNIT_EXTENSION_PARA_2,
                                   @(DataTypeInteger),C_CAMPAIGN_ADTYPE,
                                   @(DataTypeText),C_CAMPAIGN_DEEPLINK,
                                   @(DataTypeText),C_ADCHOICEICON,
                                   @(DataTypeText),C_ADCHOICESIZE,
                                   @(DataTypeText),C_ADCHOICELINK,
                                   @(DataTypeText),C_PLATFORMLOGO,
                                   @(DataTypeText),C_PLATFORMNAME,
                                   @(DataTypeText),C_ADCHOICEADVLINK,
                                   @(DataTypeText),C_ADCHOICEADVLOGO,
                                   @(DataTypeText),C_ADCHOICEADVNAME,
                                   @(DataTypeInteger),C_CACHEAVAILABLEINTERVAL,
                                   @(DataTypeInteger),C_CACHERESERVEINTERVAL,
                                   @(DataTypeText),C_BIDTOKEN,
                                   @(DataTypeInteger),C_ISBID,
                                   @(DataTypeText),C_UNIQUEID,
                                   @(DataTypeText),C_LocalMraidFileName,
                                   @(DataTypeText),C_OMID,
                                   @(DataTypeText), C_SUPERTEMPLATEURL,
                                   @(DataTypeText), C_SUPERTEMPLATEID,
                                   @(DataTypeText), C_EXTRADATA,
                                   @(DataTypeText), C_UNITEXTRADATA,
                                   @(DataTypeInteger), C_READYRATE,
                                   @(DataTypeInteger), C_WAITALLOFFERS,
                                   @(DataTypeText),C_PVURLS,
                                   @(DataTypeText), C_WebviewTemplateUrl,
                                   @(DataTypeText), C_WebviewTemplateHtmlPath,
                                   @(DataTypeText), C_PlacementId,
                                   @(DataTypeText),C_SKAD_INFO,
                                   @(DataTypeText),C_SKADIMP_INFO,
                                   @(DataTypeText),C_PCM_INFO,
                                   @(DataTypeText),C_RewardPL,
                                   @(DataTypeInteger), C_Flb,
                                   @(DataTypeInteger), C_FlbSkiptime,
                                   @(DataTypeText),C_REQUESTID,
                                   @(DataTypeInteger), C_VCN,
                                   nil];
 
        NSString *sql = [SQLAdaptor createTable:TABLE_NAME ColumnKeys:infoDict primaryKey:nil];

        [db executeUpdate:sql];
    }];
}

+ (void)dropDatabase{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor dropTable:TABLE_NAME];
        [db executeUpdate:sql];
    }];
}

+ (void)updateDatabase {
    
}

#pragma mark - 业务操作
+ (void)deleteAll:(BOOL)frameOrNot{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = nil;
        if(frameOrNot){
            sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:where(C_FRAME_ID, OPR_NOT_EQUAL, @"", DataTypeText)];
        }else{
            sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText)];
        }
        if (sql) {
            [db executeUpdate:sql];
        }
    }];
}

#pragma mark - Store Ops

+ (void)insertOrUpdateWithCampaign:(MTGCampaignExp *)campaign
                            unitId:(NSString *)unitId
                           frameId:(NSString*)frameId{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor queryLinesWithColumns:[NSArray arrayWithObject:C_ID]
                                                  inTable:TABLE_NAME
                                                    where:where(C_UNIQUEID, OPR_EQUAL, campaign.uniqueId, DataTypeText).and(where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText).and(where(C_REQUESTID, OPR_EQUAL, campaign.requestID, DataTypeText).and(where(C_TAB, OPR_EQUAL, @(campaign.tab), DataTypeInteger).and(where(C_FRAME_ID, OPR_EQUAL, frameId, DataTypeText)))))];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        if (![resultSet next]) {
            NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [MTGBase clearNoneString:campaign.uniqueId],C_UNIQUEID,
                                       [MTGBase clearNoneString:campaign.adId],C_ID,
                                       [MTGBase clearNoneString:unitId],C_UNIT_ID,
                                       @(campaign.tab),C_TAB,
                                       [MTGBase clearNoneString:campaign.packageName],C_PKG_NAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.appName]],C_NAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.appDesc]],C_DESC,
                                       [MTGBase clearNoneString:campaign.appSize],C_SIZE,
                                       [MTGBase clearNoneString:campaign.imageSize],C_IMAGE_SIZE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.iconUrl]],C_ICON_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.imageUrl]],C_IMAGE_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.impressionURL]],C_IMPRESSION_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.noticeUrl]],C_NOTICE_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.clickURL]],C_CLICK_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.onlyImpressionURL]],C_ONLY_IMPRESSION_URL,
                                       @(campaign.templation),C_TEMPLATE,
                                       @(campaign.dataTemplate),C_DATA_TEMPLATE,
                                       [MTGBase clearNoneString:campaign.landingType],C_LANDING_TYPE,
                                       [MTGBase clearNoneString:campaign.clickMode],C_CLICK_MODE,
                                       @(campaign.star),C_STAR,
                                       @(campaign.numberRating),C_NUMBERRATING,
                                       @(campaign.timestamp),C_TIMESTAMP,
                                       @((double)campaign.clickTimeout),C_CLICK_TIMEOUT,
                                       [MTGBase clearNoneString:frameId],C_FRAME_ID,
                                       @(campaign.type),C_AD_SOURCE_ID,
                                       @(campaign.fca),C_FCA,
                                       @(campaign.fcb),C_FCB,
                                       campaign.adUrlList? [MTGBase jsonSerializeObject:campaign.adUrlList]:@"",C_URL_LIST,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.videoUrlEncode]],C_VIDEO_URL_ENCODE,
                                       @(campaign.videoLength),C_VIDEO_LENGTH,
                                       @(campaign.videoSize),C_VIDEO_SIZE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.videoResolution]],C_VIDEO_RESOLUTION,
                                       @(campaign.offerCostType),C_OFFER_COST_TYPE,
                                       @(campaign.link_type),C_LINK_TYPE,
                                       [MTGBase clearNoneString:campaign.adCall],C_ADCALL,
                                       [MTGBase clearNoneString:campaign.guideLines],C_GUIDE_LINES,
                                       @(campaign.rewardAmount),C_REWARD_AMOUNT,
                                       [MTGBase clearNoneString:campaign.rewardName],C_REWARD_NAME,
                                       [MTGBase clearNoneString:campaign.htmlUrl],C_HTML_URL,
                                       [MTGBase clearNoneString:campaign.endScreenUrl],C_END_SCREEN_URL,
                                       campaign.advImp? [MTGBase jsonSerializeObject:campaign.advImp]:@"",C_ADV_IMP,
                                       campaign.trackingInfo?[MTGBase jsonSerializeObject:campaign.trackingInfo.dictionary]:@"",C_TRACKING_INFO,
                                       [MTGBase clearNoneString:campaign.endcardURL],C_ENDCARDURL,
                                       @(campaign.videoEndType),C_VIDEOENDTYPE,
                                       @(campaign.adsWithoutVideo),C_ADSWITHOUTVIDE,
                                       @(campaign.videoTemplateId),C_VIDEOTEMPATEID,
                                       [MTGBase clearNoneString:campaign.templateUrl],C_TEMPLATE_URL,
                                       @(campaign.orientation),C_ORENTATION,
                                       [MTGBase  clearNoneString:campaign.pausedUrl],C_PAUSEDURL,
                                       campaign.imageDictionary?[MTGBase jsonSerializeObject:campaign.imageDictionary]:@"",C_IMAGEDICTIONARY,
                                       @(campaign.storekit),C_STOREKIT,
                                       [MTGBase clearNoneString:campaign.md5_file],C_MD5FILE,
                                       @(campaign.nativeVideoSecondJumpTemplate),C_NATIVEVIDEOSECONDJUMPTEMPLATE,
                                       [MTGBase clearNoneString:campaign.nativeVideoGifUrl],C_NATIVEVIDEOGIFURL,
                                       @(campaign.impressionUA),C_IMPRESSIONUA,
                                       @(campaign.clickUA),C_CLICKUA,
                                       @(campaign.storeKitLoadTime),C_STOREKIT_LOAD_TIME,
                                       @(campaign.noticeAndClickTriggeredTimeInterval),C_NOTICE_AND_CLICK_TRIGGERED_TIME_INTERVAL,
                                       campaign.ext1?[MTGBase jsonSerializeObject:campaign.ext1]:@"",C_CAMPAIGN_EXTENSION_PARA_1,
                                       campaign.ext2?[MTGBase jsonSerializeObject:campaign.ext2]:@"",C_CAMPAIGN_EXTENSION_PARA_2,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.ext1]],C_CAMPAIGN_EXTENSION_PARA_1,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.ext2]],C_CAMPAIGN_EXTENSION_PARA_2,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.InteractiveEntranceIcon]],C_INTERACTIVEENTRANCEICON,
                                       @(campaign.InteractiveResourceType),C_INTERACTIVERESOURCETYPE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.InteractiveTemplateUrl]],C_INTERACTIVETEMPLATEURL,
                                       @(campaign.interactiveAdsOrientation),C_INTERACTIVEADSORIENTATION,
                                       campaign.CampaignUnitExt1?[MTGBase jsonSerializeObject:campaign.CampaignUnitExt1]:@"",C_CAMPAIG_UNIT_EXTENSION_PARA_1,
                                       campaign.CampaignUnitExt2?[MTGBase jsonSerializeObject:campaign.CampaignUnitExt2]:@"",C_CAMPAIG_UNIT_EXTENSION_PARA_2,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.CampaignUnitExt1]],C_CAMPAIG_UNIT_EXTENSION_PARA_1,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.CampaignUnitExt2]],C_CAMPAIG_UNIT_EXTENSION_PARA_2,
                                       @(campaign.adType),C_CAMPAIGN_ADTYPE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.deeplinkUrlString]],C_CAMPAIGN_DEEPLINK,
                                       // v490 added, begin
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.adchoiceIcon]],C_ADCHOICEICON,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.adchoiceSize]],C_ADCHOICESIZE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.adchoiceLink]],C_ADCHOICELINK,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.platformName]],C_PLATFORMNAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.platformLogo]],C_PLATFORMLOGO,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.advName]],C_ADCHOICEADVNAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.advLink]],C_ADCHOICEADVLINK,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.advLogo]],C_ADCHOICEADVLOGO,
                                       // v490 added, end.
                                       
                                       // v520 added, begin
                                       @(campaign.cacheAvailableInterval),C_CACHEAVAILABLEINTERVAL,
                                       @(campaign.cacheReserveInterval),C_CACHERESERVEINTERVAL,
                                       // v520 added, end
                                       
                                       @(campaign.fromBidding),C_ISBID,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.bidToken]],C_BIDTOKEN,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.mraidLocalFileName]],C_LocalMraidFileName,
                                       
                                       //580 omsdk add
                                       campaign.originalOmidDataArray? [MTGBase jsonSerializeObject:campaign.originalOmidDataArray]:@"",C_OMID,
                                       //580 omsdk end
                                       // 590
                                       [MTGBase clearNoneString:campaign.superTemplateUrl],C_SUPERTEMPLATEURL,
                                       [MTGBase clearNoneString:campaign.superTemplateID],C_SUPERTEMPLATEID,
                                       campaign.extraData?[MTGBase jsonSerializeObject:campaign.extraData]:@"",C_EXTRADATA,
                                       campaign.unitExtraData?[MTGBase jsonSerializeObject:campaign.unitExtraData]:@"",C_UNITEXTRADATA,
                                       @(campaign.readyRate),C_READYRATE,
                                       @(campaign.waitForAllOffers), C_WAITALLOFFERS,
                                       campaign.pvUrls? [MTGBase jsonSerializeObject:campaign.pvUrls]:@"",C_PVURLS,
                                       // 600
                                       [MTGBase clearNoneString:campaign.webviewTemplateURL],C_WebviewTemplateUrl,
                                       [MTGBase clearNoneString:campaign.webviewTemplateHtmlLocalPath],C_WebviewTemplateHtmlPath,
                                       [MTGBase clearNoneString:campaign.placementId],C_PlacementId,
                                       campaign.skItem?[MTGBase jsonSerializeObject:campaign.skItem.dictionary]:@"",C_SKAD_INFO,
                                       campaign.skAdImpressionDescInfo?[MTGBase jsonSerializeObject:campaign.skAdImpressionDescInfo.skAdImpressionDictionary]:@"",C_SKADIMP_INFO,
                                       campaign.pcmEventAttributionInfo?[MTGBase jsonSerializeObject:campaign.pcmEventAttributionInfo.pcmEventAttributionInfoDictionary]:@"",C_PCM_INFO,
                                       campaign.rewardInfoHandler.rewardDictionary?[MTGBase jsonSerializeObject:campaign.rewardInfoHandler.rewardDictionary]:@"",C_RewardPL,
                                       @(campaign.flb),C_Flb,
                                       @(campaign.flbSkiptime),C_FlbSkiptime,
                                       [MTGBase clearNoneString:[MTGBase subStringParamKWithURL:campaign.onlyImpressionURL]],C_REQUESTID,
                                       @(campaign.maxCacheNumber),C_VCN,
                                       nil];
            sql = [SQLAdaptor insertRow:infoDict TableName:TABLE_NAME];
            [db executeUpdate:sql];
        } else {
            NSDictionary * infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [MTGBase clearNoneString:campaign.uniqueId],C_UNIQUEID,
                                       [MTGBase clearNoneString:campaign.adId],C_ID,
                                       [MTGBase clearNoneString:unitId],C_UNIT_ID,
                                       @(campaign.tab),C_TAB,
                                       [MTGBase clearNoneString:campaign.packageName],C_PKG_NAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.appName]],C_NAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.appDesc]],C_DESC,
                                       [MTGBase clearNoneString:campaign.appSize],C_SIZE,
                                       [MTGBase clearNoneString:campaign.imageSize],C_IMAGE_SIZE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.iconUrl]],C_ICON_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.imageUrl]],C_IMAGE_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.impressionURL]],C_IMPRESSION_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.noticeUrl]],C_NOTICE_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.clickURL]],C_CLICK_URL,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.onlyImpressionURL]],C_ONLY_IMPRESSION_URL,
                                       @(campaign.templation),C_TEMPLATE,
                                       @(campaign.dataTemplate),C_DATA_TEMPLATE,
                                       [MTGBase clearNoneString:campaign.landingType],C_LANDING_TYPE,
                                       [MTGBase clearNoneString:campaign.clickMode],C_CLICK_MODE,
                                       @(campaign.star),C_STAR,
                                       @(campaign.numberRating),C_NUMBERRATING,
                                       @(campaign.timestamp),C_TIMESTAMP,
                                       @((double)campaign.clickTimeout),C_CLICK_TIMEOUT,
                                       [MTGBase clearNoneString:frameId],C_FRAME_ID,
                                       @(campaign.type),C_AD_SOURCE_ID,
                                       @(campaign.fca),C_FCA,
                                       @(campaign.fcb),C_FCB,
                                       campaign.adUrlList? [MTGBase jsonSerializeObject:campaign.adUrlList]:@"",C_URL_LIST,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.videoUrlEncode]],C_VIDEO_URL_ENCODE,
                                       @(campaign.videoLength),C_VIDEO_LENGTH,
                                       @(campaign.videoSize),C_VIDEO_SIZE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.videoResolution]],C_VIDEO_RESOLUTION,
                                       @(campaign.offerCostType),C_OFFER_COST_TYPE,
                                       @(campaign.link_type),C_LINK_TYPE,
                                       [MTGBase clearNoneString:campaign.adCall],C_ADCALL,
                                       [MTGBase clearNoneString:campaign.guideLines],C_GUIDE_LINES,
                                       @(campaign.rewardAmount),C_REWARD_AMOUNT,
                                       [MTGBase clearNoneString:campaign.rewardName],C_REWARD_NAME,
                                       [MTGBase clearNoneString:campaign.htmlUrl],C_HTML_URL,
                                       [MTGBase clearNoneString:campaign.endScreenUrl],C_END_SCREEN_URL,
                                       campaign.advImp? [MTGBase jsonSerializeObject:campaign.advImp]:@"",C_ADV_IMP,
                                       campaign.trackingInfo?[MTGBase jsonSerializeObject:campaign.trackingInfo.dictionary]:@"",C_TRACKING_INFO,
                                       [MTGBase clearNoneString:campaign.endcardURL],C_ENDCARDURL,
                                       @(campaign.videoEndType),C_VIDEOENDTYPE,
                                       @(campaign.adsWithoutVideo),C_ADSWITHOUTVIDE,
                                       @(campaign.videoTemplateId),C_VIDEOTEMPATEID,
                                       [MTGBase clearNoneString:campaign.templateUrl],C_TEMPLATE_URL,
                                       @(campaign.orientation),C_ORENTATION,
                                       [MTGBase  clearNoneString:campaign.pausedUrl],C_PAUSEDURL,
                                       campaign.imageDictionary?[MTGBase jsonSerializeObject:campaign.imageDictionary]:@"",C_IMAGEDICTIONARY,
                                       @(campaign.storekit),C_STOREKIT,
                                       [MTGBase clearNoneString:campaign.md5_file],C_MD5FILE,
                                       @(campaign.nativeVideoSecondJumpTemplate),C_NATIVEVIDEOSECONDJUMPTEMPLATE,
                                       [MTGBase clearNoneString:campaign.nativeVideoGifUrl],C_NATIVEVIDEOGIFURL,
                                       @(campaign.impressionUA),C_IMPRESSIONUA,
                                       @(campaign.clickUA),C_CLICKUA,
                                       @(campaign.storeKitLoadTime),C_STOREKIT_LOAD_TIME,
                                       @(campaign.noticeAndClickTriggeredTimeInterval),C_NOTICE_AND_CLICK_TRIGGERED_TIME_INTERVAL,
                                       campaign.ext1?[MTGBase jsonSerializeObject:campaign.ext1]:@"",C_CAMPAIGN_EXTENSION_PARA_1,
                                       campaign.ext2?[MTGBase jsonSerializeObject:campaign.ext2]:@"",C_CAMPAIGN_EXTENSION_PARA_2,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.ext1]],C_CAMPAIGN_EXTENSION_PARA_1,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.ext2]],C_CAMPAIGN_EXTENSION_PARA_2,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.InteractiveEntranceIcon]],C_INTERACTIVEENTRANCEICON,
                                       @(campaign.InteractiveResourceType),C_INTERACTIVERESOURCETYPE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.InteractiveTemplateUrl]],C_INTERACTIVETEMPLATEURL,
                                       @(campaign.interactiveAdsOrientation),C_INTERACTIVEADSORIENTATION,
                                       campaign.CampaignUnitExt1?[MTGBase jsonSerializeObject:campaign.CampaignUnitExt1]:@"",C_CAMPAIG_UNIT_EXTENSION_PARA_1,
                                       campaign.CampaignUnitExt2?[MTGBase jsonSerializeObject:campaign.CampaignUnitExt2]:@"",C_CAMPAIG_UNIT_EXTENSION_PARA_2,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.CampaignUnitExt1]],C_CAMPAIG_UNIT_EXTENSION_PARA_1,
//                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.CampaignUnitExt2]],C_CAMPAIG_UNIT_EXTENSION_PARA_2,
                                       @(campaign.adType),C_CAMPAIGN_ADTYPE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.deeplinkUrlString]],C_CAMPAIGN_DEEPLINK,
                                       // v490 added, begin
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.adchoiceIcon]],C_ADCHOICEICON,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.adchoiceSize]],C_ADCHOICESIZE,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.adchoiceLink]],C_ADCHOICELINK,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.platformName]],C_PLATFORMNAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.platformLogo]],C_PLATFORMLOGO,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.advName]],C_ADCHOICEADVNAME,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.advLink]],C_ADCHOICEADVLINK,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.advLogo]],C_ADCHOICEADVLOGO,
                                       // v490 added, end.
                                       
                                       // v520 added, begin
                                       @(campaign.cacheAvailableInterval),C_CACHEAVAILABLEINTERVAL,
                                       @(campaign.cacheReserveInterval),C_CACHERESERVEINTERVAL,
                                       // v520 added, end
                                       
                                       @(campaign.fromBidding),C_ISBID,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.bidToken]],C_BIDTOKEN,
                                       [MTGBase encodeWithSqliteString:[MTGBase clearNoneString:campaign.mraidLocalFileName]],C_LocalMraidFileName,
                                       
                                       //580 omsdk add
                                       campaign.originalOmidDataArray? [MTGBase jsonSerializeObject:campaign.originalOmidDataArray]:@"",C_OMID,
                                       //580 omsdk end
                                       // 590
                                       [MTGBase clearNoneString:campaign.superTemplateUrl],C_SUPERTEMPLATEURL,
                                       [MTGBase clearNoneString:campaign.superTemplateID],C_SUPERTEMPLATEID,
                                       campaign.extraData?[MTGBase jsonSerializeObject:campaign.extraData]:@"",C_EXTRADATA,
                                       campaign.unitExtraData?[MTGBase jsonSerializeObject:campaign.unitExtraData]:@"",C_UNITEXTRADATA,
                                       @(campaign.readyRate),C_READYRATE,
                                       @(campaign.waitForAllOffers), C_WAITALLOFFERS,
                                       campaign.pvUrls? [MTGBase jsonSerializeObject:campaign.pvUrls]:@"",C_PVURLS,
                                       // 600
                                       [MTGBase clearNoneString:campaign.webviewTemplateURL],C_WebviewTemplateUrl,
                                       [MTGBase clearNoneString:campaign.webviewTemplateHtmlLocalPath],C_WebviewTemplateHtmlPath,
                                       [MTGBase clearNoneString:campaign.placementId],C_PlacementId,
                                       campaign.skItem?[MTGBase jsonSerializeObject:campaign.skItem.dictionary]:@"",C_SKAD_INFO,
                                       campaign.skAdImpressionDescInfo?[MTGBase jsonSerializeObject:campaign.skAdImpressionDescInfo.skAdImpressionDictionary]:@"",C_SKADIMP_INFO,
                                       campaign.pcmEventAttributionInfo?[MTGBase jsonSerializeObject:campaign.pcmEventAttributionInfo.pcmEventAttributionInfoDictionary]:@"",C_PCM_INFO,
                                       campaign.rewardInfoHandler.rewardDictionary?[MTGBase jsonSerializeObject:campaign.rewardInfoHandler.rewardDictionary]:@"",C_RewardPL,
                                       @(campaign.flb),C_Flb,
                                       @(campaign.flbSkiptime),C_FlbSkiptime,
                                       [MTGBase clearNoneString:[MTGBase subStringParamKWithURL:campaign.onlyImpressionURL]],C_REQUESTID,
                                       @(campaign.maxCacheNumber),C_VCN,
                                       nil];
            
            WhereModel * whereModel = where(C_UNIQUEID, OPR_EQUAL, campaign.uniqueId, DataTypeText).and(where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText).and(where(C_TAB, OPR_EQUAL, @(campaign.tab), DataTypeInteger).and(where(C_AD_SOURCE_ID, OPR_EQUAL, @(campaign.type), DataTypeInteger))));
            
            NSString *str = [SQLAdaptor updateWithRow:infoDict inTable:TABLE_NAME where:whereModel];
            
            [db executeUpdate:str];
        }
        [resultSet close];
    }];
}

#pragma mark - Query and Retrieve Ops
+ (NSArray *)queryCampaignsWithUnitId:(NSString *)unitId
                              frameId:(NSString*)frameId{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = nil;
        if(frameId){
            sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText).and(where(C_FRAME_ID, OPR_EQUAL, frameId, DataTypeText))];
        }else{
            sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText)];
        }
        if (sql) {
            MTGFMResultSet *resultSet = [db executeQuery:sql];
            while ([resultSet next]) {
                MTGCampaignExp *campaign = [MTGCampaignDB campaignWithResult:resultSet];
                [array addObject:campaign];
            }
            [resultSet close];
        }
    }];
    return array;
}

+ (MTGCampaignExp *)searchCampaignWithId:(NSString *)adId unitId:(NSString *)unitId
{
    if(!adId || adId.length == 0) {
        return nil;
    }
    
    __block MTGCampaignExp *campaign = nil;
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:where(C_ID, OPR_EQUAL, adId, DataTypeText).and(where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText))];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            campaign = [MTGCampaignDB campaignWithResult:resultSet];
        }
        [resultSet close];
    }];
    return campaign;
}

+ (MTGCampaignExp *)searchCampaignWithBidToken:(NSString *)bidToken unitId:(NSString *)unitId {
    if(!bidToken || bidToken.length == 0) {
        return nil;
    }
    
    __block MTGCampaignExp *campaign = nil;
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:where(C_BIDTOKEN, OPR_EQUAL, bidToken, DataTypeText).and(where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText))];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            campaign = [MTGCampaignDB campaignWithResult:resultSet];
        }
        [resultSet close];
    }];
    return campaign;
}

+ (NSArray *)searchCampaignsWithBidToken:(NSString *)bidToken unitId:(NSString *)unitId {
    if(!bidToken || bidToken.length == 0) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:where(C_BIDTOKEN, OPR_EQUAL, bidToken, DataTypeText).and(where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText))];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            [array addObject:campaign];
        }
        [resultSet close];
    }];
    return array;
}

+ (NSArray *)queryCampaignsWithTab:(NSInteger)tab
                            unitId:(NSString *)unitId
                               num:(NSInteger)num
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * unitIdEqual = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * tabEqual = where(C_TAB, OPR_EQUAL, @(tab), DataTypeInteger);
        WhereModel * FrameEqual = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereCondition = unitIdEqual.and(tabEqual).and(FrameEqual).limit(num);
        
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:whereCondition];
        
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            [array addObject:campaign];
        }
        [resultSet close];
    }];
    return array;
}

+ (NSArray *)queryCampaignsInPlctWithUnitId:(NSString *)unitId
                                        num:(NSInteger)num
                                fromBidding:(BOOL)fromBidding
                                        age:(double)age {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        
        WhereModel * whereunitID = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * wheretab = where(C_TAB, OPR_EQUAL, @(-1), DataTypeInteger);
        WhereModel * whereadsource = where(C_AD_SOURCE_ID, OPR_EQUAL, @(1), DataTypeInteger);
        WhereModel * whereframe = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereBid = where(C_ISBID, OPR_EQUAL, @(fromBidding), DataTypeInteger);
        // WhereModel * wheretimestap = where(C_TIMESTAMP, OPR_LARGER, @(timeStamp), DataTypeReal);
        
        // double validTimeBegining = [MTGBase timeStampMill] - g_pRewardSetting.cacheAvailableInterval * 1000;
        double current = [MTGBase timeStampMill];
        NSString *str = [NSString stringWithFormat:@"( (plct > 0 AND ts > %lf - plct * 1000) OR (plct = 0 AND ts > %lf - %lf) )", current, current, age];
        WhereModel *wheretimestap = [[WhereModel alloc] initWithString:str];
        WhereModel * whereInfo = whereunitID.and(wheretab).and(whereadsource).and(whereframe).and(whereBid).and(wheretimestap).limit(num);
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:whereInfo];
        
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            [array addObject:campaign];
        }
        [resultSet close];
    }];
    
    return array;
}

+ (NSArray *)queryCampaignsInPlctbWithUnitId:(NSString *)unitId
                                         num:(NSInteger)num
                                 fromBidding:(BOOL)fromBidding
                                         age:(double)age {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        
        WhereModel * whereunitID = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * wheretab = where(C_TAB, OPR_EQUAL, @(-1), DataTypeInteger);
        WhereModel * whereadsource = where(C_AD_SOURCE_ID, OPR_EQUAL, @(1), DataTypeInteger);
        WhereModel * whereframe = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereBid = where(C_ISBID, OPR_EQUAL, @(fromBidding), DataTypeInteger);
        // WhereModel * wheretimestap = where(C_TIMESTAMP, OPR_LARGER, @(timeStamp), DataTypeReal);
        
        // double validTimeBegining = [MTGBase timeStampMill] - g_pRewardSetting.cacheAvailableInterval * 1000;
        double current = [MTGBase timeStampMill];
        NSString *str = [NSString stringWithFormat:@"( (plctb > 0 AND ts > %lf - plctb * 1000) OR (plctb = 0 AND ts > %lf - %lf) )", current, current, age];
        WhereModel *wheretimestap = [[WhereModel alloc] initWithString:str];
        WhereModel * whereInfo = whereunitID.and(wheretab).and(whereadsource).and(whereframe).and(whereBid).and(wheretimestap).limit(num);
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:whereInfo];
        
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            [array addObject:campaign];
        }
        [resultSet close];
    }];
    
    return array;
    
}

+ (NSArray *)queryCampaignsWithUnitId:(NSString *)unitId
                                  num:(NSInteger)num
                          fromBidding:(BOOL)fromBidding {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
//        WhereModel * pid = where(C_PlacementId, OPR_EQUAL, @"123456789", DataTypeText);
        WhereModel * whereunitID = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * wheretab = where(C_TAB, OPR_EQUAL, @(-1), DataTypeInteger);
        WhereModel * whereadsource = where(C_AD_SOURCE_ID, OPR_EQUAL, @(1), DataTypeInteger);
        WhereModel * whereframe = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereBid = where(C_ISBID, OPR_EQUAL, @(fromBidding), DataTypeInteger);
        // WhereModel * wheretimestap = where(C_TIMESTAMP, OPR_LARGER, @(timeStamp), DataTypeReal);
        
        WhereModel * whereInfo = whereunitID.and(wheretab).and(whereadsource).and(whereframe).and(whereBid).limit(num);
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:whereInfo];
        
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            [array addObject:campaign];
        }
        [resultSet close];
    }];
    
    return array;
    
}

+ (NSArray *)queryCampaignWithAdType:(MTG_AD_TYPE)adType exceptForCurrentUnitId:(NSString *)unitId {
    if (unitId.length == 0) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_NOT_EQUAL, unitId, DataTypeText);
        WhereModel * whereAdType = where(C_CAMPAIGN_ADTYPE, OPR_EQUAL, @(adType), DataTypeInteger);
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:whereUnitId.and(whereAdType)];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSMutableDictionary *campaignDic = [[NSMutableDictionary alloc]init];
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            NSString *unit_Id = [resultSet stringForColumn:C_UNIT_ID];
            [MTGBase setObject:campaign forKey:unit_Id forDic:campaignDic];
            [array addObject:campaignDic];
        }
        [resultSet close];
    }];
    return [array copy];
}

+ (NSArray *)queryCampaignWithPlacementId:(NSString *)placementId
                                   adType:(MTG_AD_TYPE)adType
                  exceptForCurrentUnitId:(NSString *)unitId {
    if (placementId.length == 0 || unitId.length == 0) {
        return nil;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_NOT_EQUAL, unitId, DataTypeText);
        WhereModel * wherePlacementId = where(C_PlacementId, OPR_EQUAL, placementId, DataTypeText);
        WhereModel * whereAdType = where(C_CAMPAIGN_ADTYPE, OPR_EQUAL, @(adType), DataTypeInteger);
        WhereModel * whereInfo = whereUnitId.and(wherePlacementId).and(whereAdType);
        NSString *sql = [SQLAdaptor queryLinesWithColumns:nil inTable:TABLE_NAME where:whereInfo];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSMutableDictionary *campaignDic = [[NSMutableDictionary alloc]init];
            MTGCampaignExp *campaign = [self campaignWithResult:resultSet];
            NSString *unit_Id = [resultSet stringForColumn:C_UNIT_ID];
            [MTGBase setObject:campaign forKey:unit_Id forDic:campaignDic];
            [array addObject:campaignDic];
        }
        [resultSet close];
    }];
    return [array copy];
}

+ (NSArray *)queryAdsNumberWithUnitId:(NSString *)unitId
                          fromBidding:(BOOL)fromBidding
                               ascend:(BOOL)ascend{

    if (!notEmpty(unitId)) {
        return nil;
    }

    NSMutableArray *array = [[NSMutableArray alloc]init];
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        //SELECT rid,Count(*) AS adsCount FROM campaign where unitid='146892' AND bid_flag=1 group BY rid order by ls_time ASC
        NSString *sql = [NSString stringWithFormat:@"SELECT %@,Count(*) AS adsCount FROM %@ where unitid='%@' AND bid_flag=%d group BY %@ order by %@ %@",C_REQUESTID,TABLE_NAME,unitId,fromBidding,C_REQUESTID,C_TIMESTAMP,ascend?@"ASC":@"DESC"];
        MTGFMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
            NSString *rid = [ resultSet stringForColumn:C_REQUESTID];
            NSInteger count = [resultSet intForColumn:@"adsCount"];
            [MTGBase setObject:@(count) forKey:@"adsCount" forDic:mutDic];
            [MTGBase setObject:rid forKey:C_REQUESTID forDic:mutDic];
            if (mutDic.count > 0) {
                [array addObject:mutDic];
            }
        }
        [resultSet close];
    }];
    return array;
}

+ (NSArray *)buildGroupsOfferAccordingToProvidedCampaigns:(NSArray *)providedCampaigns unitId:(NSString *)unitId fromBidding:(BOOL)fromBidding ascend:(BOOL)ascend {
        
    if (providedCampaigns.count == 0 || unitId.length == 0) {
        return nil;
    }
    
    NSArray *adsCountArray = [self queryAdsNumberWithUnitId:unitId fromBidding:fromBidding ascend:ascend];
    
    if (adsCountArray.count == 0) {
        return nil;
    }
    /*
     从数据库中查出相同的requstid的count时，根据count再将offer分组
     将所缓存的offer分组，相同requestId视为一条广告
     结构举例：
      [
        [exp,exp],
        [exp],
        [exp]
      ]
     */
    NSMutableArray *adsGroupArray = [@[]mutableCopy];
    for (NSInteger i = 0; i < adsCountArray.count; i++) {
        NSDictionary *countDic = adsCountArray[i];
        NSString *rid = [countDic objectForKey:C_REQUESTID];
        NSMutableArray *tempArray = [@[]mutableCopy];
        for (MTGCampaignExp *exp in providedCampaigns) {
            if ([exp.requestID isEqualToString:rid]) {
                if (![tempArray containsObject:exp]) {
                    [tempArray addObject:exp];
                }
                //找到相同的requestId的offer后，如果是非大模板，直接结束循环即可，非大模板仅一个offer
                if (exp.superTemplateUrl.length == 0) {
                    break;
                }
            }
        }

        [adsGroupArray addObject:tempArray];
    }

    return [adsGroupArray copy];
}

#pragma mark - Remove Ops

+ (void)cleanExpiredWithTime:(NSInteger)time unitId:(NSString *)unitId{

    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        // WhereModel * whereTimeStamp = where(C_TIMESTAMP, OPR_SMALLER, @(dis), DataTypeReal);
        double current = [MTGBase timeStampMill];
        NSString *str = [NSString stringWithFormat:@"( (plctb > 0 AND %lf - ts > plctb * 1000 ) OR (plctb = 0 AND %lf - ts > %ld * 1000) )", current, current, (long)time];
        WhereModel *whereTimeStamp = [[WhereModel alloc] initWithString:str];
        
        
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * whereFrameId = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        
        //不删除Interactive ads;(不删除adType为AD_TYPE_INTERACTIVE 288)
        WhereModel * whereResourceType = where(C_CAMPAIGN_ADTYPE, OPR_NOT_EQUAL, @(MTG_AD_TYPE_INTERACTIVE), DataTypeInteger);
        
        WhereModel * whereInfo = whereTimeStamp.and(whereUnitId).and(whereFrameId).and(whereResourceType);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];
        
        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignWithUniqueId:(NSString *)adUniqueId
            tab:(NSInteger)tab
            unitId:(NSString *)unitId{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUniqueID = where(C_UNIQUEID, OPR_EQUAL, adUniqueId, DataTypeText);
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * whereTab = where(C_TAB, OPR_EQUAL, @(tab), DataTypeInteger);
        WhereModel * whereFrameId = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereInfo = whereUniqueID.and(whereUnitId).and(whereTab).and(whereFrameId);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignWithRequestId:(NSString *)requestId
                           uniqueId:(NSString *)adUniqueId
                         tab:(NSInteger)tab
                             unitId:(NSString *)unitId {
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereRequestId = where(C_REQUESTID, OPR_EQUAL, requestId, DataTypeText);
        WhereModel * whereUniqueID = where(C_UNIQUEID, OPR_EQUAL, adUniqueId, DataTypeText);
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * whereTab = where(C_TAB, OPR_EQUAL, @(tab), DataTypeInteger);
        WhereModel * whereFrameId = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereInfo = whereUniqueID.and(whereUnitId).and(whereTab).and(whereFrameId).and(whereRequestId);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];
        [db executeUpdate:sql];
    }];
    
}
+ (void)deleteCampaignsWithTab:(NSInteger)tab unitId:(NSString *)unitId{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText).and(where(C_TAB, OPR_EQUAL, @(tab), DataTypeInteger).and(where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText)))];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignsWithUnitId:(NSString *)unitId fromBidding:(BOOL)fromBidding {
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText).and(where(C_ISBID, OPR_EQUAL, @(fromBidding), DataTypeInteger).and(where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText)))];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignsWithTab:(NSInteger)tab
            unitId:(NSString *)unitId
            adSourceType:(MTGAdSourceType)type{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel *whereUnitID = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel *whereTab = where(C_TAB, OPR_EQUAL, @(tab), DataTypeInteger);
        WhereModel *whereAdSource = where(C_AD_SOURCE_ID, OPR_EQUAL, @(type), DataTypeInteger);
        WhereModel *whereFrame = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        // should not delete bid offer.
        WhereModel *whereFromBidding = where(C_ISBID, OPR_EQUAL, @(0), DataTypeInteger);
        WhereModel *whereCombined = whereUnitID.and(whereTab).and(whereAdSource).and(whereFromBidding).and(whereFrame);
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereCombined];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteAppWallCampaignsWithUnitId:(NSString *)unitId{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText).and(where(C_TAB, OPR_LARGER_OR_EQUAL, @(0), DataTypeInteger).and(where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText)))];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteFrameWithId:(NSString *)frameId
       unitId:(NSString*)unitId{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUnitID = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * whereFrameId = where(C_FRAME_ID, OPR_EQUAL, frameId, DataTypeText);
        WhereModel * whereInfo = whereUnitID.and(whereFrameId);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];

        [db executeUpdate:sql];
    }];
}

+ (void)deleteFramesWithUnitId:(NSString *)unitId{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_EQUAL, unitId, DataTypeText);
        WhereModel * whereFrameId = where(C_FRAME_ID, OPR_NOT_EQUAL, @"", DataTypeText);
        WhereModel * whereInfo = whereUnitId.and(whereFrameId);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];

        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignWithVideoUrlEncode:(NSString *)videoUrlEncode{
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereVideoUrl = where(C_VIDEO_URL_ENCODE, OPR_EQUAL, videoUrlEncode, DataTypeText);
        WhereModel * whereFrameId = where(C_FRAME_ID, OPR_EQUAL, @"", DataTypeText);
        WhereModel * whereInfo = whereVideoUrl.and(whereFrameId);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];

        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignWithAdType:(MTG_AD_TYPE)adType exceptForCurrentUnitId:(NSString *)unitId {
    if (unitId.length == 0) {
        return;
    }
    
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_NOT_EQUAL, unitId, DataTypeText);
        WhereModel * whereAdType = where(C_CAMPAIGN_ADTYPE, OPR_EQUAL, @(adType), DataTypeInteger);
        
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereUnitId.and(whereAdType)];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignWithPlacementId:(NSString *)placementId adType:(MTG_AD_TYPE)adType exceptForCurrentUnitId:(NSString *)unitId {
    if (placementId.length == 0 || unitId.length == 0) {
        return;
    }
    
    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        WhereModel * whereUnitId = where(C_UNIT_ID, OPR_NOT_EQUAL, unitId, DataTypeText);
        WhereModel * wherePlacementId = where(C_PlacementId, OPR_EQUAL, placementId, DataTypeText);
        WhereModel * whereAdType = where(C_CAMPAIGN_ADTYPE, OPR_EQUAL, @(adType), DataTypeInteger);
        WhereModel * whereInfo = whereUnitId.and(wherePlacementId).and(whereAdType);
        NSString *sql = [SQLAdaptor deleteRowsInTable:TABLE_NAME Where:whereInfo];
        [db executeUpdate:sql];
    }];
}

+ (void)deleteCampaignWithUnitId:(NSString *)unitId
                requestIds:(NSArray *)requestIds
                     fromBidding:(BOOL)fromBidding{
    if (![requestIds isKindOfClass:[NSArray class]] && requestIds.count == 0) {
        return;
    }
    
    NSMutableArray *mutArray = [[NSMutableArray alloc]init];
    for (NSString *requestId in requestIds) {
        NSString *rid = [NSString stringWithFormat:@"'%@'",requestId];
        if (notEmpty(rid)) {
            if (![mutArray containsObject:rid]) {
                [mutArray addObject:rid];
            }else{}

        }else{}
    }
    
    NSString *rids = @"";
    if (mutArray.count == 0) {
        return;
    }else{
        rids = [mutArray componentsJoinedByString:@","];
    }
    

    [g_pDataManager runQueryInBlock:^(MTGFMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE unitid='%@' AND rid IN (%@) AND bid_flag=%d",TABLE_NAME,unitId,rids,fromBidding];
        [db executeUpdate:sql];
    }];
    
}


#pragma mark - Util
+ (MTGCampaign *)setCampaignOtherFieldInfos:(MTGCampaignExp*)campaign dic:(NSDictionary *)dic{
    
    campaign.endcardURL = [MTGBase clearNoneString:[dic objectForKey:OTHER_ENDCARDURL]];
    campaign.videoEndType = [dic objectForKey:OTHER_VIDEOENDTYPE] ? [[MTGBase clearNoneString:[dic objectForKey:OTHER_VIDEOENDTYPE]] integerValue] : 2;
    campaign.adsWithoutVideo = [dic objectForKey:OTHER_ADSWITHOUTVIDE] ? [[MTGBase clearNoneString:[dic objectForKey:OTHER_ADSWITHOUTVIDE]] integerValue] : 1;
    campaign.videoTemplateId = [dic objectForKey:OTHER_VIDEOTEMPATEID]?[[MTGBase clearNoneString:[dic objectForKey:OTHER_VIDEOTEMPATEID]] integerValue]:0;
    campaign.templateUrl = [MTGBase clearNoneString:[dic objectForKey:OTHER_TEMPLATE_URL]];
    campaign.orientation = [dic objectForKey:OTHER_ORENTATION]?[[MTGBase clearNoneString:[dic objectForKey:OTHER_ORENTATION]] integerValue]:0;
    campaign.pausedUrl = [MTGBase clearNoneString:[dic objectForKey:OTHER_PAUSEDURL]];
    
    if([dic objectForKey:OTHER_IMAGEDICTIONARY]&&[[dic objectForKey:OTHER_IMAGEDICTIONARY] isKindOfClass:[NSDictionary class]]){
        campaign.imageDictionary = [dic objectForKey:OTHER_IMAGEDICTIONARY];
    }
    //280 chark add END
    
    return campaign;
}
+ (NSMutableDictionary *)getCampaignOtherFieldInfosDic:(MTGCampaignExp*)campaign{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue: @(campaign.videoEndType) forKey:OTHER_VIDEOENDTYPE];
    [dic setValue: campaign.endcardURL forKey:OTHER_ENDCARDURL];
    [dic setValue: @(campaign.adsWithoutVideo) forKey:OTHER_ADSWITHOUTVIDE];
    
    //280 chark add
    [dic setValue: @(campaign.videoTemplateId) forKey:OTHER_VIDEOTEMPATEID];
    [dic setValue: campaign.templateUrl forKey:OTHER_TEMPLATE_URL];
    [dic setValue: @(campaign.orientation) forKey:OTHER_ORENTATION];
    [dic setValue: campaign.pausedUrl forKey:OTHER_PAUSEDURL];
    [dic setValue: campaign.imageDictionary forKey:OTHER_IMAGEDICTIONARY];
    //280 chark add END
    
    return dic;
}

+ (MTGCampaignExp *)campaignWithResult:(MTGFMResultSet *)resultSet
{
    MTGCampaignExp *campaign    = [[MTGCampaignExp alloc] init];
    campaign.adId              = [resultSet stringForColumn:C_ID];
    campaign.tab               = [resultSet intForColumn:C_TAB];
    campaign.packageName       = [resultSet stringForColumn:C_PKG_NAME];
    campaign.appName           = [resultSet stringForColumn:C_NAME];
    campaign.appDesc           = [resultSet stringForColumn:C_DESC];
    campaign.appSize           = [resultSet stringForColumn:C_SIZE];
    campaign.imageSize         = [resultSet stringForColumn:C_IMAGE_SIZE];
    campaign.iconUrl           = [resultSet stringForColumn:C_ICON_URL];
    campaign.imageUrl          = [resultSet stringForColumn:C_IMAGE_URL];
    campaign.impressionURL     = [resultSet stringForColumn:C_IMPRESSION_URL];
    campaign.noticeUrl         = [resultSet stringForColumn:C_NOTICE_URL];
    campaign.clickURL          = [resultSet stringForColumn:C_CLICK_URL];
    campaign.onlyImpressionURL = [resultSet stringForColumn:C_ONLY_IMPRESSION_URL];
    campaign.templation        = [resultSet intForColumn:C_TEMPLATE];
    campaign.dataTemplate      = [resultSet intForColumn:C_DATA_TEMPLATE];
    campaign.landingType       = [resultSet stringForColumn:C_LANDING_TYPE];
    campaign.clickMode         = [resultSet stringForColumn:C_CLICK_MODE];
    campaign.star              = [resultSet doubleForColumn:C_STAR];
    campaign.numberRating      = [resultSet intForColumn:C_NUMBERRATING];
    campaign.timestamp         = [resultSet doubleForColumn:C_TIMESTAMP];
    campaign.clickTimeout      = [resultSet intForColumn:C_CLICK_TIMEOUT];
    campaign.type              = [resultSet intForColumn:C_AD_SOURCE_ID];
    campaign.fca               = [resultSet intForColumn:C_FCA];
    campaign.fcb               = [resultSet intForColumn:C_FCB];
    campaign.adUrlList         = [MTGBase objWithJsonString:[resultSet stringForColumn:C_URL_LIST]];
    campaign.videoUrlEncode    = [resultSet stringForColumn:C_VIDEO_URL_ENCODE];
    campaign.videoLength       = [resultSet intForColumn:C_VIDEO_LENGTH];
    campaign.videoSize         = [resultSet doubleForColumn:C_VIDEO_SIZE];
    campaign.videoResolution   = [resultSet stringForColumn:C_VIDEO_RESOLUTION];
    

    campaign.offerCostType     = [resultSet intForColumn:C_OFFER_COST_TYPE];
    campaign.link_type         = [resultSet intForColumn:C_LINK_TYPE];
    campaign.adCall            = [resultSet stringForColumn:C_ADCALL];
    campaign.guideLines        = [resultSet stringForColumn:C_GUIDE_LINES];
    campaign.rewardAmount      = [resultSet intForColumn:C_REWARD_AMOUNT];
    campaign.rewardName        = [resultSet stringForColumn:C_REWARD_NAME];
    campaign.htmlUrl           = [resultSet stringForColumn:C_HTML_URL];
    campaign.endScreenUrl      = [resultSet stringForColumn:C_END_SCREEN_URL];
    campaign.advImp            = [MTGBase objWithJsonString:[resultSet stringForColumn:C_ADV_IMP]];
    if ([resultSet stringForColumn:C_TRACKING_INFO].length >0) {
        campaign.trackingInfo  = [MTGVideoTrackingInfo trackingWithDictionary: [MTGBase objWithJsonString:[resultSet stringForColumn:C_TRACKING_INFO]]];
    }

    if ([resultSet stringForColumn:C_SKAD_INFO].length >0) {
        campaign.skItem  = [MTGSKAdItem skAdItemWithDictionary:[MTGBase objWithJsonString:[resultSet stringForColumn:C_SKAD_INFO]] withPackageName:[resultSet stringForColumn:C_PKG_NAME]];
    }

    if ([resultSet stringForColumn:C_SKADIMP_INFO].length >0) {
        campaign.skAdImpressionDescInfo = [MTGSKAdImpressionDescribeInfo skAdImpressionDescribeInfoWithDictionary:[MTGBase objWithJsonString:[resultSet stringForColumn:C_SKADIMP_INFO]]];
    }
    
    if ([resultSet stringForColumn:C_PCM_INFO].length >0) {
        campaign.pcmEventAttributionInfo = [MTGPCMEventAttributionInfo pcmEventAttributionInfoWithDictionary:[MTGBase objWithJsonString:[resultSet stringForColumn:C_PCM_INFO]]];
    }
    
    
    campaign.endcardURL = [resultSet stringForColumn:C_ENDCARDURL];
    campaign.videoEndType = [resultSet intForColumn:C_VIDEOENDTYPE];
    campaign.adsWithoutVideo = [resultSet intForColumn:C_ADSWITHOUTVIDE];
    
    campaign.videoTemplateId = [resultSet intForColumn:C_VIDEOTEMPATEID];
    campaign.templateUrl = [resultSet stringForColumn:C_TEMPLATE_URL];
    campaign.orientation = [resultSet intForColumn:C_ORENTATION];
    campaign.pausedUrl = [MTGBase clearNoneString:[resultSet stringForColumn:C_PAUSEDURL]];
    
    campaign.imageDictionary = [MTGBase objWithJsonString:[resultSet stringForColumn:C_IMAGEDICTIONARY]];
    
    campaign.storekit = [resultSet intForColumn:C_STOREKIT];
    campaign.md5_file = [resultSet stringForColumn:C_MD5FILE];
    
    campaign.nativeVideoSecondJumpTemplate = [resultSet intForColumn:C_NATIVEVIDEOSECONDJUMPTEMPLATE];
    campaign.nativeVideoGifUrl = [resultSet stringForColumn:C_NATIVEVIDEOGIFURL];
    
    campaign.impressionUA = [resultSet intForColumn:C_IMPRESSIONUA];
    campaign.clickUA = [resultSet intForColumn:C_CLICKUA];
    campaign.storeKitLoadTime = [resultSet intForColumn:C_STOREKIT_LOAD_TIME];
    campaign.noticeAndClickTriggeredTimeInterval = [resultSet doubleForColumn:C_NOTICE_AND_CLICK_TRIGGERED_TIME_INTERVAL];
//    campaign.ext1 = [resultSet stringForColumn:C_CAMPAIGN_EXTENSION_PARA_1];
//    campaign.ext2 = [resultSet stringForColumn:C_CAMPAIGN_EXTENSION_PARA_2];
    campaign.ext1 = [MTGBase objWithJsonString:[resultSet stringForColumn:C_CAMPAIGN_EXTENSION_PARA_1]];
    campaign.ext2 = [MTGBase objWithJsonString:[resultSet stringForColumn:C_CAMPAIGN_EXTENSION_PARA_2]];

    campaign.InteractiveEntranceIcon = [resultSet stringForColumn:C_INTERACTIVEENTRANCEICON];
    campaign.InteractiveResourceType = [resultSet intForColumn:C_INTERACTIVERESOURCETYPE];
    campaign.InteractiveTemplateUrl = [resultSet stringForColumn:C_INTERACTIVETEMPLATEURL];
    campaign.interactiveAdsOrientation = [resultSet intForColumn:C_INTERACTIVEADSORIENTATION];
//    campaign.CampaignUnitExt1 = [resultSet stringForColumn:C_CAMPAIG_UNIT_EXTENSION_PARA_1];
//    campaign.CampaignUnitExt2 = [resultSet stringForColumn:C_CAMPAIG_UNIT_EXTENSION_PARA_2];
    campaign.CampaignUnitExt1 = [MTGBase objWithJsonString:[resultSet stringForColumn:C_CAMPAIG_UNIT_EXTENSION_PARA_1]];
    campaign.CampaignUnitExt2 = [MTGBase objWithJsonString:[resultSet stringForColumn:C_CAMPAIG_UNIT_EXTENSION_PARA_2]];

    campaign.adType = [resultSet intForColumn:C_CAMPAIGN_ADTYPE];
    campaign.deeplinkUrlString = [resultSet stringForColumn:C_CAMPAIGN_DEEPLINK];
    // v490 added, begin,
    campaign.adchoiceIcon = [resultSet stringForColumn:C_ADCHOICEICON];
    campaign.adchoiceSize = [resultSet stringForColumn:C_ADCHOICESIZE];
    campaign.adchoiceLink = [resultSet stringForColumn:C_ADCHOICELINK];
    campaign.platformName = [resultSet stringForColumn:C_PLATFORMNAME];
    campaign.platformLogo = [resultSet stringForColumn:C_PLATFORMLOGO];
    campaign.advName = [resultSet stringForColumn:C_ADCHOICEADVNAME];
    campaign.advLogo = [resultSet stringForColumn:C_ADCHOICEADVLOGO];
    campaign.advLink = [resultSet stringForColumn:C_ADCHOICEADVLINK];
    // v490 added, end.
    
    // v520 added, begin
    campaign.cacheAvailableInterval = [resultSet intForColumn:C_CACHEAVAILABLEINTERVAL];
    campaign.cacheReserveInterval = [resultSet intForColumn:C_CACHERESERVEINTERVAL];
    // v520 added, end
    campaign.fromBidding = [resultSet boolForColumn:C_ISBID];
    campaign.bidToken = [resultSet stringForColumn:C_BIDTOKEN];
    campaign.uniqueId = [resultSet stringForColumn:C_UNIQUEID];

    NSString *mraid_file_name = [resultSet stringForColumn:C_LocalMraidFileName];
    if (notEmpty(mraid_file_name)) {
        campaign.mraidLocalFileName = mraid_file_name;
    }

    //580 omsdk add
    campaign.originalOmidDataArray = [MTGBase objWithJsonString:[resultSet stringForColumn:C_OMID]];
    if (campaign.originalOmidDataArray.count > 0) {
        campaign.isNeedToOMVerify = YES;
    }else{
        campaign.isNeedToOMVerify = NO;
    }
    //580 omsdk end
    
    // 590
    campaign.superTemplateUrl = [resultSet stringForColumn:C_SUPERTEMPLATEURL];
    campaign.superTemplateID = [resultSet stringForColumn:C_SUPERTEMPLATEID];
    
    campaign.extraData = [MTGBase objWithJsonString:[resultSet stringForColumn:C_EXTRADATA]];
    campaign.unitExtraData = [MTGBase objWithJsonString:[resultSet stringForColumn:C_UNITEXTRADATA]];
    campaign.waitForAllOffers = [resultSet boolForColumn:C_WAITALLOFFERS];
    campaign.readyRate = [resultSet intForColumn:C_READYRATE];
    campaign.pvUrls    = [MTGBase objWithJsonString:[resultSet stringForColumn:C_PVURLS]];
    // 600
    campaign.webviewTemplateURL = [resultSet stringForColumn:C_WebviewTemplateUrl];
    NSString *templateHtmlLocalPath = [resultSet stringForColumn:C_WebviewTemplateHtmlPath];
    if (notEmpty(templateHtmlLocalPath)) {
        campaign.webviewTemplateHtmlLocalPath = templateHtmlLocalPath;
    }

    campaign.placementId = [resultSet stringForColumn:C_PlacementId];

    if ([resultSet stringForColumn:C_RewardPL].length >0) {
        campaign.rewardInfoHandler = [[MTGRewardInfoHandler alloc]initWithDictionary:[MTGBase objWithJsonString:[resultSet stringForColumn:C_RewardPL]]];
    }
    
    campaign.flb = [resultSet intForColumn:C_Flb];
    campaign.flbSkiptime = [resultSet intForColumn:C_FlbSkiptime];
    campaign.maxCacheNumber =  [resultSet intForColumn:C_VCN];
    return campaign;
}



@end
