//
//  ContentView.swift
//  ClevelandFESCenter
//
//  Created by FES Center on 1/6/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Cleveland Fes Center")
                    .font(.largeTitle)
                    .bold()
                
                Text("Welcome! Choose where to go.")
                    .foregroundStyle(.secondary)
                
                NavigationLink("Events", destination: EventView())
                NavigationLink("Investigators", destination: InvestigatorView())
                NavigationLink("Press Release", destination: PressReleaseView())
                NavigationLink("Center Resource", destination: CenterResourceView())
                // Investigators, Press Releases, Center Resources, Events
            }
        }
    }

    
}

#Preview {
    ContentView()
        .modelContainer(
            for: [
                EventModel.self,
                InvestigatorModel.self,
                PressReleaseModel.self,
                CenterResourceModel.self
            ],
            inMemory: true
        )
}

