//
//  Networking.swift
//  Name Game
//
//  Created by Michal Hus on 5/16/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import Foundation

class Networking {

    class func getPokemons(completion: @escaping ([Poke]?, String?) -> ()){
        let urlString = "https://pokeapi.co/api/v2/generation/1"
        let url = URL(string: urlString)
        
        _ = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise
                    DispatchQueue.main.async {
                        completion(nil, error!.localizedDescription)
                    }
                    return
            }
            
            let decoder = JSONDecoder()
            let endpointResponse = try! decoder.decode(GenerationOnePokemons.self, from: data)
            DispatchQueue.main.async {
                let randomPokemonsSubSet = Array(endpointResponse.pokemon_species.shuffled().prefix(6))
                completion(randomPokemonsSubSet, nil)
            }
        }.resume()
    }
}
