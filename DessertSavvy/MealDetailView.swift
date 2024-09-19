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
                ValidMealView(meal: meal)
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

struct ValidMealView: View {
    let meal: MealDetailItem
    
    let thumbnailSize = 300.0
    private var thumbnailRadius: CGFloat {
        return thumbnailSize * 0.10
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // -- Header section
                VStack(alignment: .center) {
                    //Text(meal.id)
                    Text(meal.name)
                        .font(.custom("Cochin", size: 40))
                        .multilineTextAlignment(.center)
                    
                    // Big image and associated views
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            if let thumbnail = meal.thumbnail {
                                AsyncImage(url: URL(string: thumbnail)) { phase in
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
                                .clipShape(.rect(cornerRadius: thumbnailRadius))
                                .shadow(radius: thumbnailSize * 0.10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: thumbnailRadius)
                                        .stroke(Color.black, lineWidth: 3.0)
                                )
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                            }
                            
                            // LEGAL: When present, cite the image source under the image
                            HStack {
                                Spacer()
                                Text(imageSourceCopy)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                    }
                }
                
                // -- Ingredients section
                SectionHeader(systemImageName: "carrot.fill", text: "Ingredients")
                IngredientsTableView(meal: meal)
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                
                // -- Instructions section
                if let instructions = meal.instructions {
                    SectionHeader(systemImageName: "fork.knife", text: "Instructions")
                    Text(instructions)
                        .padding(EdgeInsets(top: 5, leading: 40, bottom: 0, trailing: 0))
                        .font(.custom("American Typewriter", size: 14, relativeTo: .body))
                }
                
                // -- Video section
                if let videoLink = meal.videoLink, !videoLink.isEmpty {
                    SectionHeader(systemImageName: "movieclapper", text: "Video Link")
                    Link("Watch Video", destination: URL(string: videoLink)!)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                }
                
                // -- Attribution section
                if let recipeSource = meal.recipeSource, !recipeSource.isEmpty {
                    SectionHeader(systemImageName: "note.text", text: "Source")
                    Link("View Original Source", destination: URL(string: recipeSource)!)
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                }
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 400, trailing: 0))
    }
    
    var imageSourceCopy: String {
        if let imageSource = meal.imageSource {
            return "(\(imageSource))"
        } else {
            return "(Image Source Unknown)"
        }
    }
}

struct SectionHeader: View {
    
    let systemImageName: String?
    let text: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            if let systemImageName = systemImageName {
                Image(systemName: systemImageName)
            }
            Text(verbatim: text)
        }
        .font(.title2)
        .underline(true, pattern: .solid, color: .black)
        .imageScale(.small)
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
}

// "Table" of ingredients in left colum and corresponding quantities in the right column
struct IngredientsTableView: View {
    
    let meal: MealDetailItem
    
    let columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 2)
    
    private struct IngredientRow: Identifiable {
        let name: String
        let measurement: String
        private let uniqueID = UUID().uuidString
        var id: String { name + measurement + uniqueID}
    }
    
    private var gridItems: [IngredientRow] {
        var items: [IngredientRow] = Array()
        
        // TODO: There must be a better way to do this
        if let i = meal.ingredientName1, let m = meal.ingredientMeasure1, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName2, let m = meal.ingredientMeasure2, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName3, let m = meal.ingredientMeasure3, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName4, let m = meal.ingredientMeasure4, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName5, let m = meal.ingredientMeasure5, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName6, let m = meal.ingredientMeasure6, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName7, let m = meal.ingredientMeasure7, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName8, let m = meal.ingredientMeasure8, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName9, let m = meal.ingredientMeasure9, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName10, let m = meal.ingredientMeasure10, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName11, let m = meal.ingredientMeasure11, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName12, let m = meal.ingredientMeasure12, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName13, let m = meal.ingredientMeasure13, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName14, let m = meal.ingredientMeasure14, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName15, let m = meal.ingredientMeasure15, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName16, let m = meal.ingredientMeasure16, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName17, let m = meal.ingredientMeasure17, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName18, let m = meal.ingredientMeasure18, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName19, let m = meal.ingredientMeasure19, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        if let i = meal.ingredientName20, let m = meal.ingredientMeasure20, !i.isEmpty && !m.isEmpty {
            items.append(IngredientRow(name: i, measurement: m))
        }
        return items
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .listRowSeparatorLeading) {
            ForEach(gridItems) { item in
                Text(item.name)
                Text(item.measurement)
            }
            .font(.custom("American Typewriter", size: 14.0))
        }
    }
}


