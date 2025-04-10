//
//  CheckedContinuation.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 10/04/25.
//

import SwiftUI

class CheckedContinuationBootcampDataManager {
    func downloadImageAsync(url: String) async throws -> UIImage? {
        let url = URL(string: url)!

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let image = UIImage(data: data)!
                    continuation.resume(returning: image)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }.resume()
        }
    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let dataManager = CheckedContinuationBootcampDataManager()
    
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


struct CheckedContinuationBootcamp: View {
    @StateObject var viewModel = CheckedContinuationBootcampViewModel()
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
    CheckedContinuationBootcamp()
}
