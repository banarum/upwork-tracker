//
//  ComplicationController.swift
//  Upwork Monitor WatchKit Extension
//
//  Created by Sergei Zorko on 03/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    let startDate = Date()
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(startDate)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeInterval: 60*20, since: startDate))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        switch complication.family {
            case .graphicCircular:
                // Infograph Modular, Infographのみ
                            // circularTemplateの実装
                            // gaugeProvider, centerTextProvider が必要
                            let circularClosedGaugeTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText()
                
                let accessToken = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_TOKEN)
                let accessTokenSecret = DBHelper.shared.getString(forKey: DBHelper.UPWORK_ACCESS_SECRET)
                
                // If oauth tokens present, proceed to Dashboard
                if accessToken != nil, accessTokenSecret != nil {
                    print("YESTOKEN))")
                    // Setup network Service
                    APIService.shared.setTokens(accessToken: accessToken!, accessTokenSecret: accessTokenSecret!)
                    var income = Income(charge: 0, time: 0)
                    let week_start_timestamp = String(Int(Date().startOfWeek().timeIntervalSince1970))
                    let week_end_timestamp = String(Int(Date().endOfWeek().timeIntervalSince1970))
                    APIService.shared.getUser(callback: {userResponse -> Void in
                        if userResponse.status == APIService.API_OK {
                            APIService.shared.getIncome(from: week_start_timestamp, till: week_end_timestamp, provider_id: userResponse.result!.profile_key) { (response) in
                                if response.status == APIService.API_OK {
                                    income = response.result!
                                    // centerTextProviderの実装
                                    let centerText = CLKSimpleTextProvider(text: income.getCharge(showNumberOnly: true))
                        
                        
                        
                                    centerText.tintColor = .white
                                    
                                    let circularClosedGaugeTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText()
                        
                                    circularClosedGaugeTemplate.centerTextProvider = centerText

                                    // gaugeProviderの実装
                                    var gaugeColor = UIColor.red
                                    
                                    let fillFraction = min(income.charge / 750, 1)
                                    
                                    if income.charge >= 380 {
                                        gaugeColor = UIColor.yellow
                                    } else if income.charge > 570 {
                                        gaugeColor = UIColor.green
                                    }
                                    
                                    let gaugeProvider =
                                        CLKSimpleGaugeProvider(style: .ring,
                                                               gaugeColor: gaugeColor,
                                                               fillFraction:fillFraction)
                                    circularClosedGaugeTemplate.gaugeProvider = gaugeProvider
                                    // 用意したTemplateをセット
                                    let entry = CLKComplicationTimelineEntry(date: Date(),
                                                                             complicationTemplate: circularClosedGaugeTemplate)
                                    handler(entry)
                                } else {
                                    print(response.message!)
                                    handler(nil)
                                }
                            }
                            
                        } else {
                            print(userResponse.message!)
                            handler(nil)
                        }
                    })
                } else {
                    print("NOTOKEN((")
                    handler(nil)
                }
                
                
                   
                            
            default:
                handler(nil)
        }
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
