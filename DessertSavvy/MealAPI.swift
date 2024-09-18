//
//  MealAPI.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/18/24.
//

import Foundation

enum APIError: Error {
    case client, server, basicResponse, mealListQuery, mealDetailQuery
}

struct MealList: Codable {
    let meals: [MealListItem]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
}

struct MealListItem: Identifiable, Codable {
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

struct MealDetailList: Codable {
    let meals: [MealDetailItem]
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
}

struct MealDetailItem: Identifiable, Codable {
    let id: String
    let name: String
//    let instructions: String?
//    let thumbnail: String?
//    let videoLink: String?
//    
//    // TODO: Look into a better way to decode into an array
//    let ingredientName1: String?
//    let ingredientName2: String?
//    let ingredientName3: String?
//    let ingredientName4: String?
//    let ingredientName5: String?
//    let ingredientName6: String?
//    let ingredientName7: String?
//    let ingredientName8: String?
//    let ingredientName9: String?
//    let ingredientName10: String?
//    let ingredientName11: String?
//    let ingredientName12: String?
//    let ingredientName13: String?
//    let ingredientName14: String?
//    let ingredientName15: String?
//    let ingredientName16: String?
//    let ingredientName17: String?
//    let ingredientName18: String?
//    let ingredientName19: String?
//    let ingredientName20: String?
//    
//    let ingredientMeasure1: String?
//    let ingredientMeasure2: String?
//    let ingredientMeasure3: String?
//    let ingredientMeasure4: String?
//    let ingredientMeasure5: String?
//    let ingredientMeasure6: String?
//    let ingredientMeasure7: String?
//    let ingredientMeasure8: String?
//    let ingredientMeasure9: String?
//    let ingredientMeasure10: String?
//    let ingredientMeasure11: String?
//    let ingredientMeasure12: String?
//    let ingredientMeasure13: String?
//    let ingredientMeasure14: String?
//    let ingredientMeasure15: String?
//    let ingredientMeasure16: String?
//    let ingredientMeasure17: String?
//    let ingredientMeasure18: String?
//    let ingredientMeasure19: String?
//    let ingredientMeasure20: String?
//    
//    let recipeSource: String?
//    let imageSource: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
//        case instructions = "strInstructions"
//        case thumbnail = "strMealThumb"
//        case videoLink = "strYoutube"
//        
//        case ingredientName1 = "strIngredient1"
//        case ingredientName2 = "strIngredient2"
//        case ingredientName3 = "strIngredient3"
//        case ingredientName4 = "strIngredient4"
//        case ingredientName5 = "strIngredient5"
//        case ingredientName6 = "strIngredient6"
//        case ingredientName7 = "strIngredient7"
//        case ingredientName8 = "strIngredient8"
//        case ingredientName9 = "strIngredient9"
//        case ingredientName10 = "strIngredient10"
//        case ingredientName11 = "strIngredient11"
//        case ingredientName12 = "strIngredient12"
//        case ingredientName13 = "strIngredient13"
//        case ingredientName14 = "strIngredient14"
//        case ingredientName15 = "strIngredient15"
//        case ingredientName16 = "strIngredient16"
//        case ingredientName17 = "strIngredient17"
//        case ingredientName18 = "strIngredient18"
//        case ingredientName19 = "strIngredient19"
//        case ingredientName20 = "strIngredient20"
//        
//        case ingredientMeasure1 = "strMeasure1"
//        case ingredientMeasure2 = "strMeasure2"
//        case ingredientMeasure3 = "strMeasure3"
//        case ingredientMeasure4 = "strMeasure4"
//        case ingredientMeasure5 = "strMeasure5"
//        case ingredientMeasure6 = "strMeasure6"
//        case ingredientMeasure7 = "strMeasure7"
//        case ingredientMeasure8 = "strMeasure8"
//        case ingredientMeasure9 = "strMeasure9"
//        case ingredientMeasure10 = "strMeasure10"
//        case ingredientMeasure11 = "strMeasure11"
//        case ingredientMeasure12 = "strMeasure12"
//        case ingredientMeasure13 = "strMeasure13"
//        case ingredientMeasure14 = "strMeasure14"
//        case ingredientMeasure15 = "strMeasure15"
//        case ingredientMeasure16 = "strMeasure16"
//        case ingredientMeasure17 = "strMeasure17"
//        case ingredientMeasure18 = "strMeasure18"
//        case ingredientMeasure19 = "strMeasure19"
//        case ingredientMeasure20 = "strMeasure20"
//        
//        case recipeSource = "strSource"
//        case imageSource = "strImageSource"
    }
}

class MealDetailQuery: Hashable {
    
    // TODO: If we ever change this to take in multiple meal IDs, make sure to also change MealAPI.perform(mealDetailQuery:) to match
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
    func perform(mealListQuery: MealListQuery) async throws -> (String, MealList?) {
        let urlString = endpointRoot + "filter.php?c=\(mealListQuery.category)"
        do {
            let searchResults: MealList = try await perform(urlString)
            // Success:
            return ("Got \(searchResults.meals.count) results!", searchResults)
        } catch {
            print("Failed to perform meal list query: \(error)")
            throw APIError.mealListQuery
        }
    }
    
    func perform(mealDetailQuery: MealDetailQuery) async throws -> (MealDetailItem) {
        let urlString = endpointRoot + "lookup.php?i=\(mealDetailQuery.mealID)"
        do {
            let fetchResult: MealDetailList = try await perform(urlString)
            // Success:
            let singleMealDetail = fetchResult.meals.first // We only support single meal queries right now
            if let meal = singleMealDetail {
                return meal
            } else {
                print("Failed to fetch meal details for meal with ID = \(mealDetailQuery.mealID)")
                throw APIError.mealDetailQuery
            }
        } catch {
            print("Failed to fetch meal details for meal with ID = \(mealDetailQuery.mealID)")
            throw APIError.mealDetailQuery
        }
    }
    
    private func perform<T: Codable>(_ urlString: String) async throws -> (T) {
        let fullURL = URL(string:urlString)!
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
