//
//  MTGCampaignDB.h
//  MTGSDK
//
//  Created by Tony on 15/10/28.
//

#import <Foundation/Foundation.h>
#import "MTGDatebaseHelper.h"
#import "MTGCampaign.h"
@class MTGCampaignExp;
@class MTGFrame;

@interface MTGCampaignDB : NSObject <MTGDatebaseHelper>

#pragma mark - Store Ops

+ (void)insertOrUpdateWithCampaign:(MTGCampaignExp *)campaign
                            unitId:(NSString *)unitId
                           frameId:(NSString*)frameId;

#pragma mark - Query and Retrieve Ops
/* ia 用，用到了 frameId 字段 */
+ (NSArray *)queryCampaignsWithUnitId:(NSString *)unitId
                                  frameId:(NSString*)frameId;
/* nv / ia 用，查找特定 offer*/
+ (MTGCampaignExp *)searchCampaignWithId:(NSString *)adId unitId:(NSString *)unitId;
/* 查找特定 bidtoken 下 offer */
+ (MTGCampaignExp *)searchCampaignWithBidToken:(NSString *)bidToken unitId:(NSString *)unitId;
/* 查找特定 bidtoken 下 offers (大模板) */
+ (NSArray *)searchCampaignsWithBidToken:(NSString *)bidToken unitId:(NSString *)unitId;


/* tab 字段 主要是 appwall 用，其他场景 tab 传 -1 */
+ (NSArray *)queryCampaignsWithTab:(NSInteger)tab
                   unitId:(NSString *)unitId
                      num:(NSInteger)num;

// fetch campaigns in plct
// age: time(ms) to live
// fromBidding: if YES, only fetch campaigns from bidding.
// tab default to be -1, sourceId default to be 1.
+ (NSArray *)queryCampaignsInPlctWithUnitId:(NSString *)unitId
                                        num:(NSInteger)num
                                fromBidding:(BOOL)fromBidding
                                        age:(double)age;
// fetch campaigns in plctb
// age: time(ms) to live
// fromBidding: if YES, only fetch campaigns from bidding.
// tab default to be -1, sourceId default to be 1.
+ (NSArray *)queryCampaignsInPlctbWithUnitId:(NSString *)unitId
                                        num:(NSInteger)num
                                fromBidding:(BOOL)fromBidding
                                        age:(double)age;

// fetch campaigns
// fromBidding: if YES, only fetch campaigns from bidding.
+ (NSArray *)queryCampaignsWithUnitId:(NSString *)unitId
                                  num:(NSInteger)num
                          fromBidding:(BOOL)fromBidding;


//根据传过来的campaigns创建group offer
+ (NSArray *)buildGroupsOfferAccordingToProvidedCampaigns:(NSArray *)previousCampaigns
                                                   unitId:(NSString *)unitId
                                              fromBidding:(BOOL)fromBidding
                                                   ascend:(BOOL) ascend;

//查询同一adType下不同unitId的campaign 630 add
+ (NSArray *)queryCampaignWithAdType:(MTG_AD_TYPE)adType exceptForCurrentUnitId:(NSString *)unitId;

//查询同一placementId下相同adType下不同的unitId的campaign 630 add
+ (NSArray *)queryCampaignWithPlacementId:(NSString *)placementId
                                   adType:(MTG_AD_TYPE)adType
                  exceptForCurrentUnitId:(NSString *)unitId;

#pragma mark - Remove Ops
// 只在 ia 使用
+ (void)deleteFrameWithId:(NSString *)frameId
                     unitId:(NSString*)unitId;
// 计划删除，只在 frame db 中用
+ (void)deleteFramesWithUnitId:(NSString *)unitId;

/**
 *  根据下载地址删除视频数据 (用于视频下载失败的时候删除 campaign)
 *
 *  @param videoUrlEncode campaign.videoUrlEncode
 */
+ (void)deleteCampaignWithVideoUrlEncode:(NSString *)videoUrlEncode;

+ (void)deleteCampaignsWithTab:(NSInteger)tab
                        unitId:(NSString *)unitId;
//删除数据
+ (void)deleteCampaignsWithTab:(NSInteger)tab
                        unitId:(NSString *)unitId
                  adSourceType:(MTGAdSourceType)type;

/* 删除广告位下全部 bid offer */
+ (void)deleteCampaignsWithUnitId:(NSString *)unitId
                      fromBidding:(BOOL)fromBidding;

/* 删除超过 plctb 的 offers */
+ (void)cleanExpiredWithTime:(NSInteger)time unitId:(NSString *)unitId;

/* 删除场景：offer 资源下载失败 / offer 已经播放完成
 * adId: 对于普通 offer 是 adid，对于 bid offer 是 uniqueId
 */
+ (void)deleteCampaignWithUniqueId:(NSString *)adUniqueId
                         tab:(NSInteger)tab
                      unitId:(NSString *)unitId;


+ (void)deleteCampaignWithRequestId:(NSString *)requestId
                           uniqueId:(NSString *)adUniqueId
                         tab:(NSInteger)tab
                      unitId:(NSString *)unitId;

//删除同一adType下不同unitId的campaign
+ (void)deleteCampaignWithAdType:(MTG_AD_TYPE)adType exceptForCurrentUnitId:(NSString *)unitId;

//删除同一placementId下相同adType下不同的unitId的campaign
+ (void)deleteCampaignWithPlacementId:(NSString *)placementId
                               adType:(MTG_AD_TYPE)adType
                               exceptForCurrentUnitId:(NSString *)unitId;

//删除同一requestid下的campaign
+ (void)deleteCampaignWithUnitId:(NSString *)unitId
                requestIds:(NSArray *)requestIds
                     fromBidding:(BOOL)fromBidding;

+ (void)deleteAll:(BOOL)frameOrNot;

@end
