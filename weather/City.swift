//
//  City.swift
//  weather
//
//  Created by macuser on 2/21/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import UIKit
import Alamofire

class City {
    
    private var _name:String!
    private var _ws:String!
    private var _wd:String!
    private var _temp:String!
    private var _hum:String!
    private var _wxDescr:String!
    private var _wxUrl:String!
    private var _wxIcon:String!
    private var _cities = [String]()
    private var _colorSchemes = [[String:UIColor]]()
    private var _colorScheme = [String:UIColor]()
    
    var name:String {
        return _name
    }
    
    var ws:String {
        if _ws == nil {
            _ws = ""
        }
        return _ws
    }
    
    var wd:String {
        if _wd == nil {
            _wd = ""
        }
        return _wd
    }
    
    var temp:String {
        if _temp == nil {
            _temp = ""
        }
        return _temp
    }
    
    var hum:String {
        if _hum == nil {
            _hum = ""
        }
        return _hum
    }
    
    var wxDescr:String {
        if _wxDescr == nil {
            _wxDescr = ""
        }
        return _wxDescr
    }
    
    var wxUrl:String {
        return _wxUrl
    }
    
    var wxIcon:String {
        if _wxIcon == nil {
            _wxIcon = ""
        }
        return _wxIcon
    }
    
    var colorScheme:[String:UIColor] {
        return _colorScheme
    }
    
    init() {
        
        parseCitiesCSV()
        
        let cityNo = arc4random_uniform(UInt32(_cities.count))
        
        self._name = _cities[Int(cityNo)].uppercaseString
        self._wxUrl = "\(URL_BASE)\(name.lowercaseString)&appid=\(API_KEY)&units=\(API_UNITS)"
        
        populateColorSchemes()
        
        let schemeNo = arc4random_uniform(UInt32(_colorSchemes.count))
        
        self._colorScheme = self._colorSchemes[Int(schemeNo)]
        
        
    }
    
    
    private func populateColorSchemes() {
        self._colorSchemes.append(["background":UIColor.yellowColor(), "detail":UIColor.darkGrayColor()])
        self._colorSchemes.append(["background":UIColor.purpleColor(), "detail":UIColor.whiteColor()])
        self._colorSchemes.append(["background":UIColor.whiteColor(), "detail":UIColor.darkGrayColor()])
    }
    
    private func parseCitiesCSV() {
        let path = NSBundle.mainBundle().pathForResource("cities", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let city = row["cities"]!
                self._cities.append(city)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
   
    func downloadWeatherDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _wxUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        Alamofire.request(.GET, url).responseJSON {
            response in let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let wind = dict["wind"] as? Dictionary<String, AnyObject> where wind.count > 0 {
                    
                    if let wDir = wind["deg"] as? Double {
                        
                        self._wd = self.cardinalWindDirection(wDir)
                        
                    }
                    
                    if let wSpeed = wind["speed"] as? Double {
                        
                        self._ws = "\(Int(wSpeed)) mph"
                        
                    }
                    
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> where main.count > 0 {
                    
                    if let temp = main["temp"] as? Double {
                        self._temp = "\(Int(temp)) \u{00B0}F"
                    }
                    
                    if let hum = main["humidity"] as? Double {
                        self._hum = "\(Int(hum))%"
                    }

                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] where weather.count > 0 {
                    
                    if let descr = weather[0]["description"] as? String {
                        self._wxDescr = descr.capitalizedString
                    }
                    
                    if let iconic = weather[0]["icon"] as? String {
                        self._wxIcon = iconic
                    }
                    
                }
                
                
                completed()
            }
        }
    }
        
    private func cardinalWindDirection(wDirIn:Double) -> String {
            
            let wDir = Int(wDirIn) % 360
            
            if wDir >= 337 {
                return "NNW"
            }
            
            if wDir >= 315 {
                return "NW"
            }
            
            if wDir >= 293 {
                return "WNW"
            }
            
            if wDir >= 270 {
                return "W"
            }
            
            if wDir >= 247 {
                return "WSW"
            }
            
            if wDir >= 225 {
                return "SW"
            }
            
            if wDir >= 203 {
                return "SSW"
            }
            
            if wDir >= 180 {
                return "S"
            }
            
            if wDir >= 158 {
                return "SSE"
            }
            
            if wDir >= 135 {
                return "SE"
            }
            
            if wDir >= 113 {
                return "ESE"
            }
            
            if wDir >= 90 {
                return "E"
            }
            
            if wDir >= 68 {
                return "ENE"
            }
            
            if wDir >= 45 {
                return "NE"
            }
            
            if wDir >= 23 {
                return "NNE"
            }
            
            return "N"
        }
}
