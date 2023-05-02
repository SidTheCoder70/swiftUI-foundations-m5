//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/2/23.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
