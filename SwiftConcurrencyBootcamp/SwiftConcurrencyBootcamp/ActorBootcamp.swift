//
//  ActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 11/04/25.
//

import SwiftUI

actor ActorDataManager {
    static let shared = ActorDataManager()
    private init() {}
    
    var data: [String] = []
    
    func getData() -> String? {
        print("\(Thread.current)")
        data.append(UUID().uuidString)
        return data.randomElement()
    }
    
    nonisolated func getStaticData() -> String {
        "Hello"
    }
}

struct ActorSubview1: View {
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common, options: nil).autoconnect()
    let dataManager = ActorDataManager.shared
    var body: some View {
        ZStack {
            Text(text)
        }
        .onReceive(timer) { _ in
            DispatchQueue.global(qos: .background).async {
                Task {
                    if let data = await dataManager.getData() {
                        await MainActor.run {
                            text = data
                        }
                    }
                }
            }
        }
    }
}

struct ActorSubview2: View {
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common, options: nil).autoconnect()
    let dataManager = ActorDataManager.shared
    var body: some View {
        ZStack {
            Text(text)
        }
        .onReceive(timer) { _ in
            DispatchQueue.global(qos: .default).async {
                Task {
                    if let data = await dataManager.getData() {
                        await MainActor.run {
                            text = data
                        }
                    }
                }
            }
        }
    }
}

struct ActorBootcamp: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                ActorSubview1()
            }
            
            Tab("Profile", systemImage: "person") {
                ActorSubview2()
            }
        }
    }
}

#Preview {
    ActorBootcamp()
}
