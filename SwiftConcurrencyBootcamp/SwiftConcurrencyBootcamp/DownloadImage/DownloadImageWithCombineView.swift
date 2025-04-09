//
//  DownloadImageWithCombineView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 09/04/25.
//

import SwiftUI
import Combine

class DownloadImageWithCombineDataManager {
    func downloadImage(url: String) -> AnyPublisher<UIImage?, Error> {
        let url = URL(string: url)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
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

class DownloadImageWithCombineViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let dataManager = DownloadImageWithCombineDataManager()
    
    func fethcImage() {
        dataManager.downloadImage(url: "https://picsum.photos/200")
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
}


struct DownloadImageWithCombineView: View {
    @StateObject var viewModel = DownloadImageWithCombineViewModel()
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
    DownloadImageWithCombineView()
}
