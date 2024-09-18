//
//  MealAPI.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/18/24.
//

import Foundation

enum APIError: Error {
    case client, server, basicResponse, mealListQuery
}

struct MealSearchResults: Codable {
    let meals: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
}

struct Meal: Identifiable, Codable {
    let name: String
    let thumbnail: String // TODO URL etc ugh
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
    }
}

class MealListQuery: Hashable {
    
    // For now, we only ever look for desserts. In the future we can flesh this out with other options and a convenience enum type, etc.
    var category: String = "Dessert"
    
    static func == (lhs: MealListQuery, rhs: MealListQuery) -> Bool {
        return (
            lhs.category == rhs.category
            // && lhs.propertyX == rhs.propertyX etc for any newly added properties
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
        //hasher.combine(propertyX) etc for any newly added properties
    }
}

class MealDetailQuery: Hashable {
    
    var mealID: String
    
    init(mealID: String) {
        self.mealID = mealID
    }
    
    static func == (lhs: MealDetailQuery, rhs: MealDetailQuery) -> Bool {
        return (
            lhs.mealID == rhs.mealID
            // && lhs.propertyX == rhs.propertyX etc for any newly added properties
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mealID)
        //hasher.combine(propertyX) etc for any newly added properties
    }
}

// https://themealdb.com/api.php
struct MealAPI {
    
    // TODO: Using test key for now. Use of a real key would need to be properly hidden to prevent public leaks.
    private let applicationKey = "1"
    private let endpointRoot: String = "https://themealdb.com/api/json/v1/1/"
    
    // Primarily throws APIError.mealListQuery up to UI clients
    func perform(mealListQuery: MealListQuery) async throws -> (String, MealSearchResults?) {
        let urlString = endpointRoot + "filter.php?c=\(mealListQuery.category)"
        let fullURL = URL(string: urlString)!
        
        do {
            let searchResults: MealSearchResults = try await perform(fullURL: fullURL)
            // Success:
            return ("Got \(searchResults.meals.count) results!", searchResults)
        } catch {
            print("Failed to perform meal list query: \(error)")
            throw APIError.mealListQuery
        }
    }
    
    private func perform<T: Codable>(fullURL: URL) async throws -> (T) {
        let request = URLRequest(url: fullURL)
        print("Request is: \n\(request.debugDescription)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.server
            }
            switch response.statusCode {
                case 200:
                    // This means success
                break;
                case 400 ..< 500: throw APIError.client
                case 500 ..< 600: throw APIError.server
                default: break
            }
            if let basicResponseJSON = String(data: data, encoding: String.Encoding.utf8) {
                print("Basic response received: \(basicResponseJSON)")
            } else {
                print("Failed to get basic response into a string!")
                throw APIError.basicResponse
            }
            
            // Decoding results
            do {
                let searchResults = try JSONDecoder().decode(T.self, from: data)
                return searchResults
                
            } catch {
                print("JSON decoding error: \(error)")
                throw error
            }
        } catch {
            // E.g. ran into this before adding info key NSAppTransportSecurity > NSAllowsArbitraryLoads = YES
            print("Unexpected error: \(error)")
            throw error
        }
    }
    
}
