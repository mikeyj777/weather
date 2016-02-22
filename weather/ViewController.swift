//
//  ViewController.swift
//  weather
//
//  Created by macuser on 2/21/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var clrBackground = UIColor.whiteColor()
    var clrDetail = UIColor.darkGrayColor()
    
    @IBOutlet var lblWxDescr: MarqueeLabel!
    @IBOutlet var lblCityName: UILabel!
    @IBOutlet var wxIcon: UIImageView!
    @IBOutlet var wxView: UIView!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblWD: UILabel!
    @IBOutlet var lblWS: UILabel!
    @IBOutlet var lblHum: UILabel!
    @IBOutlet var imgRaindrop: UIImageView!
    
    
    var shouldSetImagesManually = true
    var city:City!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startThings()
        
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        startThings()
    }
    
    func startThings() {
        initializeUI()
        
        city = City()
        
        clrBackground = city.colorScheme["background"]!
        clrDetail = city.colorScheme["detail"]!
        
        
        self.city.downloadWeatherDetails { () -> () in
            //called when download is done
            
            self.updateUI()
            
        }
    }
    
    func initializeUI() {
        
        self.applyColors()
        self.lblWxDescr.text = ""
        self.lblCityName.text = ""
        self.wxIcon.image = UIImage(named:"01d")
        self.lblTemp.text = ""
        self.lblWD.text = ""
        self.lblWS.text = ""
        self.lblHum.text = ""
        
    }
    
    func updateUI() {
        self.applyColors()
        
        self.lblWxDescr.text = city.wxDescr
        self.lblCityName.text = city.name
        self.wxIcon.image = UIImage(named:city.wxIcon)
        self.lblTemp.text = city.temp
        self.lblWD.text = city.wd
        self.lblWS.text = city.ws
        self.lblHum.text = city.hum
        
    }
    
    func applyColors() {
        
        self.wxView.backgroundColor = self.clrBackground
        self.lblWxDescr.textColor = self.clrDetail
        self.lblCityName.textColor = self.clrDetail
        self.lblTemp.textColor = self.clrDetail
        self.lblWD.textColor = self.clrDetail
        self.lblWS.textColor = self.clrDetail
        self.lblHum.textColor = self.clrDetail

    }
    
}

