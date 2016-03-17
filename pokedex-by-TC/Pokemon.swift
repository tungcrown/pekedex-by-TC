//
//  Pokemon.swift
//  pokedex-by-TC
//
//  Created by Lê Thanh Tùng on 3/16/16.
//  Copyright © 2016 Lê Thanh Tùng. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    private var _type: String!
    private var _description: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLv: String!
    
    private var _pokemonURL: String!
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }

        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLv: String {
        if _nextEvolutionLv == nil {
            _nextEvolutionLv = ""
        }

        return _nextEvolutionLv
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(BASE_URL)\(URL_POKE)\(_pokedexId)/"
    }
    
    func downloadPokemonDetails(complete: DownloadComplete) {
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization

            //print(response.result.value)     // server data
            
            if let json = response.result.value {
                
                if let weight = json["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = json["height"] as? String {
                    self._height = height
                }
                
                if let attack = json["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = json["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                //xac dinh phan tu ben trong la mot array nua
                if let types = json["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    
                    if types.count > 1 { //when error more than an alement
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = json["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsUrl = NSURL(string: "\(BASE_URL)\(url)")!

                        Alamofire.request(.GET, nsUrl).responseJSON { response in

                            if let json = response.result.value as? Dictionary<String, AnyObject> {
                                if let desc = json["description"] as? String {
                                    self._description = desc
                                }
                            }
                            
                            complete()
                            
                            print(self._description)
                        }
                    }
                } else {
                    self._description = ""
                }
                
                //evolutions
                if let evolutions = json["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        //can't support Mega right now, but api still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newUri = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let id = newUri.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionTxt = to
                                self._nextEvolutionId = id
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLv = "\(level)"
                                }
                                
                                print(self._nextEvolutionLv)
                                
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
    }
}