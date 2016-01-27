//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nick on 1/23/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseattack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _finalEvolutionId: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
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
    
    var baseattack: String {
        if _baseattack == nil {
            _baseattack = ""
        }
        return _baseattack
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
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var finalEvolutionId: String {
        if _finalEvolutionId == nil {
            _finalEvolutionId = ""
        }
        return _finalEvolutionId
    }
    
    
    init(name: String, pokedexId: Int) {
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._baseattack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description

                                }
                            }
                            
                            completed()
                        }
                    }
                    
                } else {
                    self._description = ""
                }

                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.rangeOfString("mega") == nil {
                            // Ignore "mega" evolutions
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString(URL_POKEMON, withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                let nsurl = NSURL(string: "\(URL_BASE)\(uri)")!
                                Alamofire.request(.GET, nsurl).responseJSON { response in
                                    
                                    let res = response.result
                                    if let finalForm = res.value as? Dictionary<String, AnyObject> {
                                        print(finalForm.debugDescription)
                                        if let finalEvolutions = finalForm["evolutions"] as? [Dictionary<String, AnyObject>] where finalEvolutions.count > 0 {
                                            if let finalTo = finalEvolutions[0]["to"] as? String {
                                                if finalTo.rangeOfString("mega") == nil {
                                                    if let finalUri = finalEvolutions[0]["resource_uri"] as? String {
                                                        let newFinalStr = finalUri.stringByReplacingOccurrencesOfString(URL_POKEMON, withString: "")
                                                        let finalNum = newFinalStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                                        self._finalEvolutionId = finalNum
                                                    }
                                                }
                                            }

                                        }
                                    }
                                    
                                    
                                    completed()
                                    
                                }
                            }
                        }
                    }
                }
                
                completed()
            }
        }
        
    }
}