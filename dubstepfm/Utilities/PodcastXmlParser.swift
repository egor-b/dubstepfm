//
//  PodcastXmlParser.swift
//  dubstepfm
//
//  Created by Egor Bryzgalov on 9/30/22.
//

import Foundation

class PodcastXmlParser: NSObject, XMLParserDelegate {
    
    private(set) var podcasts: [Podcast] = []
    
    private var currentElement = String()
    
    private var currentAuthor: String = "" {
        didSet {
            currentAuthor = currentAuthor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentAlbum: String = "" {
        didSet {
            currentAlbum = currentAlbum.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentSeason: String = "" {
        didSet {
            currentSeason = currentSeason.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentGuid: String = "" {
        didSet {
            currentGuid = currentGuid.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseFeed(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // we assign the name of the element to currentElement, if the item tag is found, we reset the temporary variables of title, description and pubdate for later use
        currentElement = elementName
        if currentElement == "item" {
            currentAuthor = ""
            currentAlbum = ""
            currentSeason = ""
            currentPubDate = ""
            currentDescription = ""
            currentGuid = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "itunes:author": currentAuthor += string
        case "itunes:album" : currentAlbum += string
        case "itunes:season": currentSeason += string
        case "pubDate": currentPubDate += string
        case "description": currentDescription += string
        case "guid": currentGuid += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            var descrip = String()
            if currentDescription != "" {
                let dstart = currentDescription.index(currentDescription.startIndex, offsetBy: 34)
                let dend = currentDescription.index(currentDescription.endIndex, offsetBy: 0)
                let drange = dstart..<dend
                descrip = String(currentDescription[drange])
                let podcast = Podcast(author: currentAuthor, album: currentAlbum, season: currentSeason, pubDate: currentPubDate, description: descrip, fullDescription: currentDescription, link: currentGuid, cover: "https://www.dubstep.fm/images/dsfm_cover.jpg")
                podcasts.append(podcast)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        print("on:", parser.lineNumber, "at:", parser.columnNumber)
    }
    
}
