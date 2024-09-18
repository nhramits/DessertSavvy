//
//  MealDetailView.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/18/24.
//

import SwiftUI

struct MealDetailView: View {
    
    let mealListItem: MealListItem
    
    @State var meal: MealDetailItem?
    @State var errorString: String?
    
    var body: some View {
        VStack {
            
            if let errorString = errorString {
                // TODO: Implement better error UI
                Text(errorString)
            } else if let meal = meal {
                VStack {
                    Text(meal.id)
                    Text(meal.name)
//                    if let imageSource = meal.imageSource {
//                        Text(imageSource)
//                    }
                }
            } else { // Still loading.
                VStack {
                    Text("Loading...")
                    ProgressView()
                }
            }
            
        }
        .padding()
        .task {
            do {
                meal = try await MealAPI().perform(mealDetailQuery: MealDetailQuery(mealID: mealListItem.id))
            } catch {
                // TODO: Implement better UI and retry mechanics
                switch error {
                case APIError.mealDetailQuery:
                    errorString = "Failed to get details of dessert! Please try again later."
                default:
                    errorString = "Unexpected error! Please try again later."
                }
            }
        }
    }
}
