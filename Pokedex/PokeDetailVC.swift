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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
