//
//  DoTryCatchThrows.swift
//  SwiftConcurrencyBootcamp
//
//  Created by z0042k3y on 08/04/25.
//

import SwiftUI

extension DoTryCatchThrowsError {
    var errorDescription: String? {
        switch self {
            case .invalidValue:
                return "My Invalid Value"
            @unknown default:
                return nil
        }
    }
    
}

enum DoTryCatchThrowsError: LocalizedError {
    case invalidValue
}

class DoTryCatchThrowsDataManager {
    func fetchValue() throws -> String {
        //"New Data"
        throw DoTryCatchThrowsError.invalidValue
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {
    @Published var value: String = "Fetch Value"
    
    let dataManager = DoTryCatchThrowsDataManager()
    
    func fetchValue() {
        do {
            value = try dataManager.fetchValue()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DoTryCatchThrows: View {
    
    @StateObject var viewModel = DoTryCatchThrowsViewModel()
    
    var body: some View {
        Button(viewModel.value) {
            viewModel.fetchValue()
        }
    }
}

#Preview {
    DoTryCatchThrows()
}
