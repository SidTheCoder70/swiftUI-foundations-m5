//
//  ContentModel.swift
//  LearningApp
//
//  Created by Eric Ruston on 5/2/23.
//

import Foundation

class ContentModel: ObservableObject {
    //initialize into an empty array of Module
    @Published var modules = [Module]()
    
    //current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    //current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    //current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    
    // current selected content and test
    @Published var currentContentSelected:Int?
    
    //var for parsing the style.html file it's an optional because the first time it will be nil
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
    }
    
    //MARK: - data methods
    
    func getLocalData() {
        
        //get a url to the local JSON file
        
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            //read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl! )
            
            //try to decode the JSON into an array of modules
            let jsonDecoder = JSONDecoder()
            
            do {
                let modules = try jsonDecoder.decode([Module].self, from: jsonData)
                
                //assign parsed modules to modules property
                self.modules = modules
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
            
      } catch {
            // TODO Log error
            print("Couldn't parse local data")
        }
        
        //parse the style data
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            //read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            // not going to parse as JSON as this file is for html
            self.styleData = styleData
        }
        catch {
            // log error
            print("couldn't parse style data")
        }
    }
    
    //MARK: - Module navigation methods
    
    func beginModule(_ moduleid:Int) {
        
        //find the index for this module id
        // loop through the modules until the id we have matches
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
                
                //found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        //set the current module
        currentModule = modules[currentModuleIndex]
        
        
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        // check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }

        // set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        // we also set the lesson description (see addStyling method below)
        lessonDescription = addStyling(currentLesson!.explanation)
        
    }
    
    // function to allow the "Next Lesson" button to work in the ContentDetailView
    func nextLesson() {
        
        // advance the lesson index
        currentLessonIndex += 1
        
        // check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            // also set the next lesson description
            lessonDescription = addStyling(currentLesson!.explanation)
        } else {
            // reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    // function to determine if there is in fact a next lesson in the ContentDetailView (for the "Next Lesson" button)
    func hasNextLesson() -> Bool {
       
       /* if currentLessonIndex + 1 < currentModule!.content.lessons.count {
            return true
        } else {
            return false
        }*/
        
        // all of the above code can be simplified to this:
        return(currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
    //code styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        //need data object
        var data = Data()
        
        // add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        // add the html data
        data.append(Data(htmlString.utf8))
        
        // convert to attributed string
        
        //Technique 1 (doesn't give a chance to handle errors, the code will simply be skipped if nil comes up
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        //Technique 2 (allows you to handle any error that comes up, so you can do something about it)
        // not going to use it because we don't really care if the code works or not, there is nothing we would do if it failed: pass an error to the user, etc.
                    /*do {
                        let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                            
                            resultString = attributedString
                        
                    }
                    catch {
                        print("Couldn't turn html into an attributed string")
                    }*/

        return resultString
    }
    
}
