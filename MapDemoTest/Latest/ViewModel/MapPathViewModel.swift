//
//  MapPathViewModel.swift
//  MapDemoTest
//
//  Created by Ashwinee on 02/01/19.
//  Copyright © 2018 Magneto It Solutions. All rights reserved.
//

import UIKit

protocol MapPathViewModelDelegate {
    func isSucessReadJson()
    func isFailReadJson(msg : String)
}
class MapPathViewModel {
    
    var delegate : MapPathViewModelDelegate?
    var arrayMapPath : [MapPath] = []
    
    //Json File data get
    func jsonDataRead() {
        do {
            if let file = Bundle.main.url(forResource: "LocationData", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    parseJson(json: object)
                } else {
                    print("JSON is invalid")
                    delegate?.isFailReadJson(msg: "JSON is invalid")
                }
            } else {
                print("no file")
                delegate?.isFailReadJson(msg: "No File found")
            }
        } catch {
            print(error.localizedDescription)
            delegate?.isFailReadJson(msg: error.localizedDescription)
        }
    }
    
    //Pars json from array
    func parseJson(json : [String: Any])  {
        //print(json)
        let pathArray = json["Locations"] as! NSArray
        for data in pathArray
        {
            let dic = data as! NSDictionary
            //print(dic)
            guard let lat = dic.value(forKey: "lat") as? String else {
                return
            }
            guard let lon:String = dic.value(forKey: "long") as? String else {
                return
            }
            guard let angle:String = dic.value(forKey: "angle") as? String else {
                return
            }
            
            arrayMapPath.append(MapPath(lat: Double(lat), lon: Double(lon), angle: Double(angle)))
        }
        
        if arrayMapPath.count > 0
        {
            delegate?.isSucessReadJson()
        }
    }
    
}

