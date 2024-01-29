//
//  Store.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 1/25/24.
//

import Foundation
import StoreKit

@Observable
class Store {
    private var productIDs = ["stone"]
    var products = [Product]()
    
    init() {
        Task {
            await requestProducts()
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print(error)
        }
    }
}

