//
//  Person.swift
//  Project10
//
//  Created by Hyeongchae Son on 7/25/24.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image 
    }
}
