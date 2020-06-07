//
//  GenerationOnePokemons.swift
//  Name Game
//
//  Created by Michal Hus on 6/7/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

struct GenerationOnePokemons: Codable {
    let pokemon_species: [Poke]
}

struct Poke: Codable {
    let name: String
    let url: String
}

struct PokemonTypes: Codable {
    let types: [PokemonType]
}

struct PokemonType: Codable {
    let name: String
    let url: String
}
