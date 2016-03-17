//
//  pokemonDetailVC.swift
//  pokedex-by-TC
//
//  Created by Lê Thanh Tùng on 3/17/16.
//  Copyright © 2016 Lê Thanh Tùng. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var lblNameDetails: UILabel!
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var imgCurrentEvo: UIImageView!
    @IBOutlet weak var imgNextEvo: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblAttack: UILabel!
    @IBOutlet weak var lblEvoCaption: UILabel!
    
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNameDetails.text = pokemon.name
        
        var img = UIImage(named: "\(pokemon.pokedexId)")
        imgMain.image = img
        imgCurrentEvo.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            //this will be called afted download is done
            self.updateUI()
        }
    }
    
    func updateUI() {
        lblHeight.text = pokemon.height
        lblDescription.text = pokemon.description
        lblType.text = pokemon.type
        lblDefense.text = pokemon.defense
        lblHeight.text = pokemon.height
        lblAttack.text = pokemon.attack
        lblPokedexId.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionId == "" {
            lblEvoCaption.text = "No Evolutions"
            imgNextEvo.hidden = true
        } else {
            imgNextEvo.hidden = false
            imgNextEvo.image = UIImage(named: pokemon.nextEvolutionId)
            
            var str = "Next Evolution \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLv != "" {
                str += " - LVL \(pokemon.nextEvolutionLv)"
            }
            
            lblEvoCaption.text = str
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseDetailsVC(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
