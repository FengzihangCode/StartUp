//
//  ContentView.swift
//  StartUp
//
//  Created by 冯子航 on 6/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var apps: [AppInfo] = []
    @State private var page: Int = 0
    var body: some View {
        ZStack {
            BlurredWallpaperView()
            AppGridView(apps: $apps, page: $page)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            apps = AppListProvider.fetchApplications()
        }
    }
}

#Preview {
    ContentView()
}
