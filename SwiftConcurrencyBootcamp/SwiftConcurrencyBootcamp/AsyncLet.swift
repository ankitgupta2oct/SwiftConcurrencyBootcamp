//
//  AsyncLet.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 10/04/25.
//

import SwiftUI

struct AsyncLet: View {
    @State var images: [UIImage] = []
    let gridItems: [GridItem] = [.init(.flexible()), .init(.flexible())]
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            
            async let image1Fetch = downloadImageAsync()
            async let image2Fetch = downloadImageAsync()
            async let image3Fetch = downloadImageAsync()
            async let image4Fetch = downloadImageAsync()
            async let image5Fetch = downloadImageAsync()
            
            do {
                let (image1, image2, image3, image4, image5) = await (try image1Fetch, try image2Fetch, try image3Fetch, try image4Fetch, try image5Fetch)
                
                images.append(contentsOf: [image1!, image2!, image3!, image4!, image5!])
            } catch {
                
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
    AsyncLet()
}
