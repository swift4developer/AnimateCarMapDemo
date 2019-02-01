//
//  MapPath.swift
//  MapDemoTest
//
//  Created by Ashwinee on 02/01/19.
//  Copyright © 2018 Magneto It Solutions. All rights reserved.
//

import Foundation

class MapPath {
    
    var lat : Double?
    var lon : Double?
    var angle : Double?
    
    init() {}
    init(lat : Double?,lon : Double?,angle : Double?) {
        self.lat = lat
        self.lon = lon
        self.angle = angle
    }
}
