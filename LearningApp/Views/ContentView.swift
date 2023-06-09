//
//  ContentView.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            
            LazyVStack {
                
                // confirm that currentModule is set
                if model.currentModule != nil {
                    
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                      
                        NavigationLink(destination:
                                                    ContentDetailView()
                                        .onAppear(perform: {
                                            model.beginLesson(index)
                                        }),
                                       label: {
                                        ContentViewRow(index: index)
                                    })
                        
                    }
                }
                    
                }
            .accentColor(.black)
            .padding()
            //add title but currentModule is an optional, so use the nil coalescing operator ?? and put up a blank string if no currentModule is found
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "")")
            }
        }
    }


/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ContentModel()
        ContentView()
    }
}*/
