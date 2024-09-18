//
//  MealAPI.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/18/24.
//

import Foundation

enum APIError: Error {
    case client, server
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

// TODO : like QueryInputs
class MealQuery: Hashable {
    
    static func == (lhs: MealQuery, rhs: MealQuery) -> Bool {
        return (
            lhs.category == rhs.category
            // && lhs.propertyX == rhs.propertyX etc for any newly added properties
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(category)
        //hasher.combine(propertyX) etc for any newly added properties
    }
    
    // For now, we only ever look for desserts. In the future we can flesh this out with other options and a convenience enum type, etc.
    var category: String = "Dessert"
}

// https://themealdb.com/api.php
struct MealRequest {
       
    var queryInputs: MealQuery
    
    // TODO: Using test key for now. Use of a real key would need to be properly hidden to prevent public leaks.
    private let applicationKey = "1"
    
    func perform() async throws -> (String, MealSearchResults?) {
        
        var urlString = "https://themealdb.com/api/json/v1/1/"
        urlString += "filter.php?c=\(queryInputs.category)"
        let fullURL = URL(string: urlString)!
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
                return ("Failed to get basic response into a string!", nil)
            }
            
            // Decoding results
            do {
                let searchResults = try JSONDecoder().decode(MealSearchResults.self, from: data)
                
                return ("Got \(searchResults.meals.count) results!", searchResults)
                
            } catch {
                print(error)
                return ("Failed JSON decoding! Error: \n\(error)", nil)
            }
            
        } catch {
            // E.g. ran into this before adding info key NSAppTransportSecurity > NSAllowsArbitraryLoads = YES
            return ("Unexpected error: \(error).", nil)
        }
    }
    
}
