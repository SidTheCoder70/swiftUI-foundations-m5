//
//  RectangleCard.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/8/23.
//

import SwiftUI

struct RectangleCard: View {
    
    // since the buttons will not always be one color make that property dynamic:
    var color = Color.white
    
    var body: some View {
        
        Rectangle()
         // frame height will be specified at each use of the view
            .foregroundColor(color)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}
