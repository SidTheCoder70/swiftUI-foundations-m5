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
    
    //var for parsing the style.html file it's an optional because the first time it will be nil
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
    }
    
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
            
            self.styleData = styleData
        }
        catch {
            // log error
            print("couldn't parse style data")
        }
    }
    
}
