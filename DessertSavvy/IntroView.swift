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
            VStack(alignment: .center) {
                Spacer()
                Text("Dessert")
                    .font(.custom("Savoye Let", size: 90))
                Text("Savvy")
                    .font(.custom("Savoye Let", size: 90))
                Text("(A SwiftUI app by Nathan Hramits)")
                    .font(.caption2)
                Spacer()
                NavigationLink {
                    MealListView(queryInputs: queryInputs)
                } label: {
                    Label("Show Me Desserts!", systemImage: "birthday.cake.fill")
                        .font(.title3)
                }
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .backgroundStyle(.green)
                )
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    IntroView()
}
