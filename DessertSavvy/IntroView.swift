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
            ZStack() {
                Image("marbleCountertop")
                    .resizable()
                    .ignoresSafeArea()
                VStack(alignment: .center) {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 350, height: 350)
                        Circle()
                            .foregroundStyle(.gray.gradient)
                            .frame(width: 340, height: 340)
                        VStack(alignment: .center) {
                            Text("Dessert")
                                .font(.custom("Savoye Let", size: 90))
                            Text("Savvy")
                                .font(.custom("Savoye Let", size: 90))
                        }
                    }
                    Text("(A SwiftUI app by Nathan Hramits)")
                        .font(.caption)
                        .underline(pattern: .dot)
                    Spacer()
                    NavigationLink(destination: MealListView(queryInputs: queryInputs)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25.0)
                                .foregroundStyle(.blue.gradient)
                            Text("Show Me Desserts!")
                                .font(.title3)
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(width: 200, height: 50)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    IntroView()
}
