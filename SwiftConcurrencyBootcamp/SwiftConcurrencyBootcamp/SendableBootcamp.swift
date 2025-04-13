//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 13/04/25.
//

import SwiftUI

final class User: @unchecked Sendable {
    private(set) var name: String
    
    func updateUser(name newName: String) {
        let lock = DispatchQueue(label: "lock.queue")
        lock.async { [weak self] in
            self?.name = newName
        }
    }
    
    init(name: String) {
        self.name = name
    }
}

actor SendableBootcampDataManager {
    func fetchData(user: User) -> [String] {
        ["Hello", user.name]
    }
}

class SendableBootcampViewModel: ObservableObject {
    @Published var data:[String] = []
    
    let dataManager = SendableBootcampDataManager()
    
    func fetchData() async {
        let user = User(name: "World!!!")
        data = await dataManager.fetchData(user: user)
    }
}

struct SendableBootcamp: View {
    @StateObject private var viewModel = SendableBootcampViewModel()
    
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
    SendableBootcamp()
}
