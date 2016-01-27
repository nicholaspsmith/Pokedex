//
//  PokeDetailVC.swift
//  Pokedex
//
//  Created by Nick on 1/26/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseattackLbl: UILabel!
    @IBOutlet weak var nextEvoTxtLbl: UILabel!
    @IBOutlet weak var nextEvoImg1: UIImageView!
    @IBOutlet weak var nextEvoImg2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.capitalizedString
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        
        pokemon.downloadPokemonDetails { () -> () in
            // this is called once the download has finished
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        baseattackLbl.text = pokemon.baseattack
        
        if pokemon.nextEvolutionId == "" {
            nextEvoTxtLbl.text = "No Evolutions"
            nextEvoImg1.hidden = true
        } else {
            nextEvoImg1.hidden = false
            nextEvoImg1.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
            nextEvoTxtLbl.text = str
        }
        
        print(pokemon.nextEvolutionTxt)
        
        if pokemon.finalEvolutionId == "" {
            nextEvoImg2.hidden = true
        } else {
            nextEvoImg2.hidden = false
        }
        
        nextEvoImg1.image = UIImage(named: "\(pokemon.nextEvolutionId)")
        nextEvoImg2.image = UIImage(named: "\(pokemon.finalEvolutionId)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
