//
//  RecipesListView.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/18/24.
//

import SwiftUI
import WebKit

struct RecipeRow: View {
    
    let meal: Meal
    
    private let thumbnailSize = 80.0
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: meal.thumbnail)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                default:
                    ProgressView()
                }
            }
            .frame(width: thumbnailSize, height: thumbnailSize)
            .clipShape(.rect(cornerRadius: thumbnailSize * 0.30))
            VStack(alignment: .leading) {
                Text(meal.name)
                Text(meal.id)
            }
        }
    }
}

struct RecipesListView: View {
    
    var queryInputs: MealListQuery
    @State var queryResultString: String = "Loading..."
    @State var queryResults: MealSearchResults? = nil
    
    var body: some View {
        VStack(alignment: .center, content: {
            Text(queryResultString)
            if let queryResults, queryResults.meals.count > 0 {
                NavigationView {
                    List(queryResults.meals, id: \.id) { meal in
//                        NavigationLink(destination: JobDetailView(job: job)) {
//                            Text(job.title)
//                        }
//                        Text(meal.name + " " + meal.thumbnail + " " + meal.id) // TODO replace
                        RecipeRow(meal: meal)
                    }
                    .navigationBarTitle("Dessert Search Results")
                }
            }
        })
        .padding()
        .task {
            do {
                (queryResultString, queryResults) =  try await MealAPI().perform(mealListQuery: queryInputs)
                print("Successfully performed meal query.")
            } catch {
                // TODO: Implement better UI and retry mechanics
                switch error {
                case APIError.mealListQuery:
                    queryResultString = "Failed to get list of Desserts! Please try again later."
                default:
                    queryResultString = "Unexpected error! Please try again later."
                }
            }
        }
    }
}

#Preview {
    RecipesListView(queryInputs: MealListQuery())
}
