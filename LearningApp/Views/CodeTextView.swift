//
//  CodeTextView.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/4/23.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable {
    
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView  {
        let textView = UITextView()
        textView.isEditable = false
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        
        // set the attributed text for the lesson
        textView.attributedText = model.lessonDescription
        // Scroll back to the top
        // making animation true for this causes issues as does setting width and height to 0 so use the parameters set below
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
