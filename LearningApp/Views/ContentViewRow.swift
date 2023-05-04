//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/3/23.
//

import SwiftUI

struct ContentViewRow: View {
    // this view needs access to the ContentModel dataset
    @EnvironmentObject var model: ContentModel
    // needed to create the index var
    var index: Int
    
    var body: some View {
        // get the current lesson that is being used in the view
        let lesson = model.currentModule!.content.lessons[index]
     // Lesson Card
        ZStack(alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack(spacing: 30) {
                
                Text(String(index+1))
                    .bold()
                
                VStack(alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                    
                }
            }
            .padding()
        }
        .padding(.bottom, 5)
    }
}

// removed preview because current module won't be set
