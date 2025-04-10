//
//  DownloadImageWithAyncView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 09/04/25.
//

import SwiftUI

class DownloadImageWithAyncDataManager {
    func downloadImageAsync(url: String) async throws -> UIImage? {
        let url = URL(string: url)!
        
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

class DownloadImageWithAyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let dataManager = DownloadImageWithAyncDataManager()
    
    func fetchImageAsync() async {
        do {
            let downloadImage = try await dataManager.downloadImageAsync(url: "https://picsum.photos/200")
            await MainActor.run {
                self.image = downloadImage
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


struct DownloadImageWithAyncView: View {
    @StateObject var viewModel = DownloadImageWithAyncViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
            }
        }
        .task {
            await viewModel.fetchImageAsync()
        }
    }
}

#Preview {
    DownloadImageWithAyncView()
}
