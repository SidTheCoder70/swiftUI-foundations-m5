//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/3/23.
//

import SwiftUI
//import the AVKit framework we added to the project in the project details file at the top of the app
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            // only show video if we get a valid URL
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // Description
            CodeTextView()
            
            // Next Lesson Button (show only if there is a next lesson)
            if model.hasNextLesson() {
                Button(action: {
                    // advance the lesson
                    model.nextLesson()
                    
                }, label: {
                    
                    ZStack {
                       
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                    
                })
            }
            // if there is no next lesson, then show the 'complete' button to take the user back out to homeview
            else {
                // show the 'complete' button
                Button(action: {
                    // take the user back to the homeview
                    model.currentContentSelected = nil
                    
                }, label: {
                    
                    ZStack {
                       
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                    
                })
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}

/*struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}*/
