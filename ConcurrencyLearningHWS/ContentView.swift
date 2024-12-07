//
//  ContentView.swift
//  StateSample
//
//  Created by Martin Poulsen on 2024-12-01.
//

import SwiftUI

/// View protocol is on the @MainActor (and Maintread).
/// More context: [url](https://gist.github.com/takasurazeem/8f78283553ea1b74424aa90f7b4b38dd)
struct ContentView: View {
    // A @State variable that holds the text displayed in the interface
    @State private var text = "Waiting..."
    
    var body: some View {
        VStack(spacing: 20) {
            Text(text)
                .padding()
            
            Button("Start Background Task") {
                Task {
                    // After 'await', we continue on the MainActor (main thread), so updating 'text' is safe and keeps UI updates smooth. As HWS mentions, '@State' can be updated from any thread, but doing so on the MainActor is good practice.
                    text = await startBackgroundTask()
                    //  Even though @State properties are thread-safe and can be updated from any thread (as per the HWS tip), updating them on the MainActor ensures that your UI remains responsive and free from threading issues.
                }
            }
        }
    }
    
    // Call the nonisolated function on a background thread
    // What nonisolated does is stop any actor inference and ensure that there will not be any isolation for a function. No isolation means no MainActor and that means background thread.
    nonisolated func startBackgroundTask() async -> String {
        // Simulate network delay
        // You can set a breakpoint here, to check the tread
        try? await Task.sleep(for: .seconds(2))
        return "Updated from background task"
    }
}

#Preview {
    ContentView()
}
