//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 13/04/25.
//

import SwiftUI

final class AsyncPublisherBootcampDataManager {
    @Published var userNames: [String] = []
    
    func fetchData() {
        Task {
            userNames.append("One")
            try? await Task.sleep(for: .seconds(2))
            userNames.append("Two")
            try? await Task.sleep(for: .seconds(2))
            userNames.append("Three")
            try? await Task.sleep(for: .seconds(2))
            userNames.append("Four")
        }
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    @MainActor @Published var data: [String] = []
    
    let dataManager = AsyncPublisherBootcampDataManager()
    
    func fetchData() async {
        dataManager.fetchData()
        
        for await userNames in dataManager.$userNames.values {
            await MainActor.run {
                data = userNames
            }
        }
    }
}

struct AsyncPublisherBootcamp: View {
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        VStack {
            ForEach(viewModel.data, id: \.self) {
                Text($0)
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
