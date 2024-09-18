//
//  ContentView.swift
//  DessertSavvy
//
//  Created by Nathan Hramits on 9/17/24.
//

import SwiftUI

struct IntroView: View {
    
    private var queryInputs = MealListQuery()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundStyle(.red)
                Text("Dessert Savvy")
                NavigationLink {
                    RecipesListView(queryInputs: queryInputs)
                } label: {
                    Label("See Desserts List", systemImage: "heart.fill")
                }
            }
            .padding()
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    IntroView()
}
