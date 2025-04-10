//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 10/04/25.
//

import SwiftUI

struct TaskBootcamp: View {
    var body: some View {
        ZStack {
            NavigationStack {
                NavigationLink("Next page") {
                    TaskBootcampNextPage()
                }
            }
        }
        .onAppear() {
//            Task(priority: .high) {
//                await Task.yield()
//                print("high: \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                await Task.yield()
//                print("userInitiated: \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("medium: \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("low: \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility: \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("background: \(Task.currentPriority)")
//            }
        }
    }
}


struct TaskBootcampNextPage: View {
    
    @State var fetchedTask: Task<Void, Never>? = nil
    
    var body: some View {
        ZStack {
            Text("Task Next Page")
        }
        .task {
            self.fetchedTask = Task {
                try? await Task.sleep(for: .seconds(5))
                
                do {
                    try await URLSession.shared.data(from: URL(string: "https://www.google.com")!)
                    print("Fetched data successfully!")
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        .onDisappear {
            fetchedTask?.cancel()
        }
    }
    
}

#Preview {
    TaskBootcamp()
}
