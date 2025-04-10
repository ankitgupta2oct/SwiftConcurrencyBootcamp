//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 10/04/25.
//

import SwiftUI

struct TaskGroupBootcamp: View {
    @State var images: [UIImage] = []
    let gridItems: [GridItem] = [.init(.flexible()), .init(.flexible())]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .task {
            try? await fetchedImages()
        }
    }
    
    func fetchedImages() async throws {
        try await withThrowingTaskGroup(of: UIImage?.self) { group in
            for _ in 0..<30 {
                group.addTask {
                    try await self.downloadImageAsync()
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
        }
    }
    
    func downloadImageAsync() async throws -> UIImage? {
        let url = URL(string: "https://picsum.photos/200")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        return handleResponse(data: data, response: response)
    }
    
    private func handleResponse(data: Data, response: URLResponse) -> UIImage? {
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300,
            let image = UIImage(data: data) else {
                return nil
            }
        
        return image
    }
}

#Preview {
    TaskGroupBootcamp()
}
