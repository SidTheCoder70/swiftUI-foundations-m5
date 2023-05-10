//
//  TestResultView.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/10/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    // in order to know how many questions we got correct, this var will be passed in
    var numCorrect:Int
    
    // computed property for the text encouragement at the end of the quiz
    var resultHeading:String {
        
        //protect in the event that currentModule has not been set (and is nil)
        guard model.currentModule != nil else {
            return ""
        }
        // if we get past this, we can safely force unwrap the currentModule in the code below
        // first compute percent right that the user got
        let pct = (Double(numCorrect))/(Double(model.currentModule!.test.questions.count))
        
        if pct > 0.5 {
            return "Awesome!"
        }
        else if pct > 0.2 {
            return "Doing Great!"
        }
        else {
            return "Keep Learning."
        }
        
    }
    var body: some View {
        
        VStack {
            Spacer()
            
            Text(resultHeading)
            
            Spacer()
            
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) Questions")
            
            Spacer()
            
            Button{
                //send the user back to the HomeView
                model.currentTestSelected = nil
                
            } label: {
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            Spacer()
        }
        
    }
}


