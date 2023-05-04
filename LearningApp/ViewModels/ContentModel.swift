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
    
    func beginModule( moduleid:Int) {
        
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
    
    
    
}
