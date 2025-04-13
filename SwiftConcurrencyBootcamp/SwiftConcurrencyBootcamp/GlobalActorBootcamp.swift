//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 13/04/25.
//

import SwiftUI

@globalActor
final class MyGlobalDataManagerActor: GlobalActor {
    static var shared = GlobalActorBootcampImp()
}

actor GlobalActorBootcampImp {
    func fetchData() -> [String] {
        ["Hello", "World2"]
    }
}

class GlobalActorBootcampViewModel: ObservableObject {
    @Published var data:[String] = []
    
    let dataManager = MyGlobalDataManagerActor.shared
    
    func fetchData() async {
        data = await dataManager.fetchData()
    }
}

struct GlobalActorBootcamp: View {
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
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
    GlobalActorBootcamp()
}
