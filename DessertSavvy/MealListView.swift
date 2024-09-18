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
            .shadow(radius: thumbnailSize * 0.10)
            .overlay(
                RoundedRectangle(cornerRadius: thumbnailSize * 0.30)
                    .stroke(Color.gray, lineWidth: 1.0)
            )
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            VStack(alignment: .leading) {
                Text(meal.name)
                Text(meal.id)
            }
            .font(.custom("Cochin", size: 23))
        }
    }
}

struct MealListView: View {
    
    var queryInputs: MealListQuery
    @State var queryResultString: String = "Loading..."
    @State var queryResults: MealSearchResults? = nil
    
    var body: some View {
        VStack(alignment: .center, content: {
            Text(queryResultString)
            if let queryResults, queryResults.meals.count > 0 {
                NavigationView {
                    List(queryResults.meals, id: \.id) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            RecipeRow(meal: meal)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Capsule()
                                .fill(Color(white:1, opacity: 0.8))
                                .padding(2)
                        )
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
    MealListView(queryInputs: MealListQuery())
}
