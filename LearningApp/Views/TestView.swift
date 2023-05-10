//
//  TestView.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/9/23.
//

import SwiftUI

struct TestView: View {
    // How to know what quiz has been selected?  Our environmentObject will dictate that:
    @EnvironmentObject var model:ContentModel
    // state var to track the answer the user selected, initially will be nil because of the situation whereby if the user has submitted an answer with the submit button, the submit button will then be disabled because selectedAnswerIndex has been set to 1,2,3, or 4
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    // state var to determine if answer was submitted (should not be able to change your answer)
    @State var submitted = false
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack(alignment: .leading) {
                // Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                 
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                // Answers
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) { index in
                        
                                Button {
                                    // Track the selected index
                                    selectedAnswerIndex = index
                                } label: {
                                    ZStack{
                                        
                                        if submitted == false {
                                            RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)}
                                        else {
                                            // answer has been submitted
                                            if index == selectedAnswerIndex &&
                                                index == model.currentQuestion!.correctIndex {
                                                
                                                // user has selected the right answer
                                                // show a green button if selection is correct
                                                RectangleCard(color: .green)
                                                    .frame(height: 48)
                                            }
                                            else if index == selectedAnswerIndex &&
                                                        index != model.currentQuestion!.correctIndex {
                                                // user has selected the wrong answer
                                                // show a red background
                                                RectangleCard(color: Color.red)
                                                    .frame(height: 48)
                                            }
                                            else if index == model.currentQuestion!.correctIndex {
                                                // this button is the correct answer
                                                // show a green background
                                                RectangleCard(color: .green)
                                                    .frame(height: 48)
                                            }
                                            else {
                                                RectangleCard(color: .white)
                                                .frame(height: 48)
                                            }
                                            
                                        }
                                        
                                        Text(model.currentQuestion!.answers[index])
                                    }
                                }
                            //once the user submits an answer, they should not be able to change it, this modifier will change to true (is submitted) when the user submits their answer
                                .disabled(submitted)
                        }
                    }
                    .padding()
                    .accentColor(.black)
                }
                
                // Submit Button
                
                Button {
                    // change submitted state to true (so user can't change the answer after it is submitted
                    submitted = true
                    // check the answer, update the state property numCorrect, increment the counter if correct
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text("Submit")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
                // this modifier makes it so the submit button cannot be used until an answer has been chosen
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else {
            // Test hasn't loaded yet
            ProgressView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
