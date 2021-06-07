//
//  lab1App.swift
//  lab1
//
//  Created by AppleLab on 05/05/2021.
//

import SwiftUI

@main
struct lab1App: App {
    var viewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
