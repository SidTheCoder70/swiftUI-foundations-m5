//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/3/23.
//

import SwiftUI

struct HomeViewRow: View {
    //because no access to environmentObject, add some var's:
    var image:String
    var title:String
    var description:String
    //used to be: "\(module.content.lessons.count) Lessons"
    var count:String
    //used to be: "module.content.time"
    var time:String
    
    var body: some View {
        
        ZStack {
            //set up the basic white card
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            
            HStack {
                
                //image
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116)
                    //make the image fit into a circle
                    .clipShape(Circle())
                
                Spacer()
                
                //text
                VStack(alignment: .leading, spacing: 10) {
                    // headline
                    Text(title)
                        .bold()
                    
                    // description
                    Text(description)
                        .padding(.bottom, 20)
                        .font(Font.system(size:10))
                    
                    // Icons
                    HStack {
                        
                        //number of lessons/questions
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(count)
                            .font(Font.system(size: 10))
                        
                         Spacer()
                        
                        //time
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width:15, height:15)
                        Text(time)
                            .font(Font.system(size: 10))

                    }
                    
                }
                .padding(.leading, 20)
                
            }
            .padding(.horizontal, 20)
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "some description", count: "10 Lessons", time: "2 hours")
    }
}
