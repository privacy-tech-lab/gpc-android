//
//  ContentView.swift
//  AccessFrameworkProject
//
//  Created by Rafael Goldstein on 2/19/20.
//  Copyright © 2020 Rafael Goldstein. All rights reserved.
//

import SwiftUI
import HelloWorld

struct ContentView: View {
    
    
    let randomString = RandomTest.string()
    let randomInt = RandomTest.integer()
    
    var body: some View {
        Text(randomString)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
