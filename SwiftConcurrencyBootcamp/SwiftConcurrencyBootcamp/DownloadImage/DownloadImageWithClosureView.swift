//
//  DownloadImageWithClosure.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 09/04/25.
//

import SwiftUI

class DownloadImageWithClosureDataManager {
    func downloadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300,
                let data = data,
                let image = UIImage(data: data) else {
                    completion(.failure(error!))
                    return
                }
            
            completion(.success(image))
        }.resume()
    }
}

class DownloadImageWithClosureViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    let dataManager = DownloadImageWithClosureDataManager()
    
    func fethcImage() {
        dataManager.downloadImage(url: "https://picsum.photos/200") { result in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                case .failure(let error):
                    print("Error downloading image: \(error)")
            }
        }
    }
}


struct DownloadImageWithClosureView: View {
    @StateObject var viewModel = DownloadImageWithClosureViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
            }
        }
        .onAppear {
            viewModel.fethcImage()
        }
    }
}

#Preview {
    DownloadImageWithClosureView()
}
