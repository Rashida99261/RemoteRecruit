//
//  RemoteRecruitApp.swift
//  RemoteRecruit
//
//  Created by Rashida on 6/06/26.
//

import SwiftUI

@main
struct RemoteRecruitApp: App {
    var body: some Scene {
        WindowGroup {
            JobListView(viewModel: DIContainer.shared.makeJobListViewModel())
        }
    }
}
