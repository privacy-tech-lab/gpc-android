//
//  RandomTest.swift
//  HelloWorldTest
//
//  Created by Rafael Goldstein on 2/19/20.
//  Copyright © 2020 Rafael Goldstein. All rights reserved.
//

import Foundation

public class RandomTest {
    public static func string() -> String {
        return UUID().uuidString
    }
    
    public static func integer() -> Int {
        return Int(arc4random())
    }
    
}
