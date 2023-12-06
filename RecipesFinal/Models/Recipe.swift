//
//  Recipe.swift
//  RecipeVault
//

import SwiftUI

struct Recipe: Identifiable, Codable {
    var id: Int
    var title: String
    var rating: Int
    var prepTime: Int   
    var cookTime: Int   
    var servings: String
    var ingredients: String
    var directions: String
    var isFavorite: Bool
    var collections: [String]
    fileprivate var addedOn: Date? = Date.now
    fileprivate var imageNames: [String]
}

extension Recipe {
    var addedOnDate: Date {
        addedOn ?? Date.now
    }
    
    var subtitle: String {
        var subtitle = "\(self.servings) servings | "
        
        let now = Date.now
        let later = now + TimeInterval(prepTime + cookTime)
        subtitle += (now..<later).formatted(.components(style: .condensedAbbreviated))
        
        return subtitle
    }
    
    var thumbnailImage: Image {
        let name = imageNames.last ?? "placeholder"
        return ImageStore.shared.image(name: name)
    }
    var smallImage: Image {
        guard imageNames.count >= 2 else { return thumbnailImage }
        
        let name = imageNames[1]
        return ImageStore.shared.image(name: name)
    }
    
    var fullImage: Image {
        let name = imageNames.first ?? "placeholder"
        return ImageStore.shared.image(name: name)
    }
    
    var prepTimeAsText: String {
        get { prepTime == 0 ? "" : "\(prepTime)" }
        set { prepTime = Int(newValue) ?? 0 }
    }

    var cookTimeAsText: String {
        get { cookTime == 0 ? "" : "\(cookTime)" }
        set { cookTime = Int(newValue) ?? 0 }
    }
    
    var collectionAsText: String {
        get { collections.joined(separator: ",") }
        set { collections = newValue.replacingOccurrences(of: ", ", with: ",").components(separatedBy: ",") }
    }

    private static let newRecipeId: Recipe.ID = -1
    var isNew: Bool {
        id == Recipe.newRecipeId
    }
}

extension Recipe {
    static func emptyRecipe() -> Recipe {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let json = """
            {
                "id": \(Recipe.newRecipeId),
                "title": "",
                "rating": 0,
                "prepTime": 0,
                "cookTime": 0,
                "servings": "",
                "ingredients": "",
                "directions": "",
                "isFavorite": false,
                "collections": [],
                "imageNames": []
            }
        """
        let data = Data(json.utf8)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Recipe.self, from: data)
        } catch {
            fatalError("Invalid recipe JSON")
        }
    }
}
