//
//  ContentView.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/2/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach (model.modules) { module in
                            
                            VStack(spacing: 20) {
                                
                                //this navigationLink passes the module to ContentView
                                NavigationLink(destination: ContentView()
                                    .onAppear(perform: {
                                        model.beginModule(module.id)
                                    }),
                                               tag: module.id,
                                               selection: $model.currentContentSelected,
                                               
                                               label: {
                                    
                                    // Learning Card now the label of a navigationLink
                                    
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    
                                })
                                
                                NavigationLink(
                                    destination: TestView()
                                        .onAppear(perform: {
                                        model.beginTest(module.id)
                                    }),
                                    tag: module.id, selection: $model.currentTestSelected,
                                    label: {
                                    // Test Card
                                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                                })
                                
                                
                            }
                            .padding(.bottom, 12)
                        }
                    }
                    //padding for the white card (modifier on LazyVStack)
                    .padding()
                    // set the text to black after the navigationView made it blue
                    .accentColor(.black)
                }
                
            }
            .navigationTitle("Get Started")
        }
        //must indicate navigation view style in xCode 13+
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
