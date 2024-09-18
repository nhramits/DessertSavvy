//
//  RecipesListView.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/18/24.
//

import SwiftUI
import WebKit

struct RecipesListView: View {
    
    var queryInputs: MealQuery
    @State var queryResultString: String = "Loading..."
    @State var queryResults: MealSearchResults? = nil
    
    var body: some View {
        VStack(alignment: .center, content: {
            Text(queryResultString)
            if let queryResults {
                if queryResults.meals.count > 0 {
                    NavigationView {
                        List(queryResults.meals, id: \.id) { meal in
//                            NavigationLink(destination: JobDetailView(job: job)) {
//                                Text(job.title)
//                            }
                            Text(meal.name + " " + meal.thumbnail + " " + meal.id) // TODO replace
                        }
                        .navigationBarTitle("Dessert Search Results")
                    }
                }
            }
        })
        .padding()
        .task {
            do {
                (queryResultString, queryResults) =  try await MealRequest(queryInputs: queryInputs).perform()
                
                print("Did the thing here...")
            } catch {
                queryResultString = "Failed :("
            }
        }
    }
}

#Preview {
    RecipesListView(queryInputs: MealQuery())
}
