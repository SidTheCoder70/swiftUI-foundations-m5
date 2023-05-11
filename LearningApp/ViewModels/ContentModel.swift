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
    
    // Current Question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    //current lesson explanation
    @Published var codeText = NSAttributedString()
    //var for parsing the style.html file it's an optional because the first time it will be nil
    var styleData: Data?
    
    // current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    init() {
        //this starts the parsing of the local JSON file
        getLocalData()
        
        // this starts the parsing of the remote hosted JSON file (on GitHub pages)
        getRemoteData()
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
    
    func getRemoteData() {
        
        // String path to remote JSON file on GitHub
        let urlString = "https://sidthecoder70.github.io/learningapp-data/data2.json"
        
        // Create a URL object from the URL string above
        let  url = URL(string: urlString)
        
        // the code above could generate a nil response, so guard against it:
        guard url != nil else {
            // couldn't create url
            return
        }
        
        // create URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if there's an error
            guard error == nil else {
                // there was an error
                return
            }
            
            do {
                // Create JSON decoder
                let decoder = JSONDecoder()
                
                // Decode the JSON
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into modules property
                self.modules += modules
            }
            catch {
                // Couldn't parse remote JSON
            }
            
        }
        
        // Kick off the dataTask
        dataTask.resume()
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
        codeText = addStyling(currentLesson!.explanation)
        
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
            codeText = addStyling(currentLesson!.explanation)
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
    
    func beginTest(_ moduleId:Int) {
        
        // set the current module
        beginModule(moduleId)
        
        // set the current question
        currentQuestionIndex = 0
        
        // if there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the Question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        
        // advance the question index
        currentQuestionIndex += 1
        
        // check that its within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // set the current queston
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            // if not, then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
       
        
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
