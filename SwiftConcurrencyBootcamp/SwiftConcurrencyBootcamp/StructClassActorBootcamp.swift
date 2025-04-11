//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 11/04/25.
//

import SwiftUI

// Immutable Struct
struct MyStruct {
    private(set) var title: String
    
    mutating func changeTitle(_ newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func changeTitle(_ newTitle: String) {
        title = newTitle
    }
}


struct StructClassActorBootcamp: View {
    var body: some View {
        ZStack {
            Text("Hello, World!")
        }
        .onAppear {
            performTask()
        }
    }
    
    private func performTask() {
        
//        var object1 = MyStruct(title: "Hello")
//        object1.changeTitle("World")
//        print(object1.title)

        Task {
            let actor1 = MyActor(title: "Hello")
            await actor1.changeTitle("World")
            await print(actor1.title)
        }
    }
}
