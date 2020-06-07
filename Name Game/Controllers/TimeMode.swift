//
//  TimeMode.swift
//  Name Game
//
//  Created by Michal Hus on 5/18/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import UIKit
import CoreData

class TimeMode: UIViewController, NSFetchedResultsControllerDelegate {

    var cellViewSize: CGFloat = 0
    var imageSize: CGSize = CGSize(width: 0, height: 0)
    var timer:Timer?
    var timeLeft = 60
    
    var fetchedResultsController: NSFetchedResultsController<Pokemon>!
    var imageReset: Bool = false


    var pokemons: [Pokemon] = []
    var randomTargetIndex: Int = 0
    var score: Int = 0

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)

    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeTitle: UIBarButtonItem!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        targetName.isHidden = true
        loadData()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timeTitle.title = "\(timeLeft)s"
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            deleteAllData()
            self.errorAlertMessage(title: "Game Over!", message: "Scored: \(score)", isGameOver: true)
        }
    }
    
    // MARK: Data Loading
    func loadData() {
        if let picFromCoreData = reloadSavedData() {
            pokemons = picFromCoreData
            if (pokemons.isEmpty) {
                getPokemonsRandomSet()
            } else {
                getTargetPokemonName()
            }
        }
    }
    
    func getTargetPokemonName() {
        for (id, pokemon) in pokemons.enumerated() {
            if pokemon.targetPokemon {
                self.randomTargetIndex = id
                self.targetName.text = pokemon.pokemonName
                self.targetName.isHidden = false
            }
        }
        self.collectionView.reloadData()
    }
    
    // MARK: Core Data Fetching

     fileprivate func reloadSavedData() -> [Pokemon]? {
         self.imageReset = false
         var photos: [Pokemon] = []
             let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
             let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
             fetchRequest.sortDescriptors = [sortDescriptor]

             fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
             fetchedResultsController.delegate = self

         do {
             try fetchedResultsController.performFetch()
             let photoCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)

             for index in 0..<photoCount {
                 photos.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)))
             }
             return photos

         } catch {
             print("error performing fetch")
             return nil
         }
     }

    // MARK: CORE DATA AND COLLECTION VIEW'S ARRAY CLEAN UP
    func deleteAllData() {
        for pokemon in pokemons {
            DataController.shared.viewContext.delete(pokemon)
            DataController.shared.saveContext()
        }
        pokemons.removeAll()
        self.imageReset = true
    }
    
    // MARK: Fetching API Responses
    func getPokemonsRandomSet() {
        _ = Networking.getPokemons { (response, error) in
             guard let response = response, error == nil else {
                 self.errorAlertMessage(title: "Network Error", message: error ?? "Please Try Again Later")
                 return
            }

            self.randomTargetIndex = Int.random(in: 0 ..< response.count)
        
            for (id, pokemon) in response.enumerated() {
                var array = pokemon.url.components(separatedBy: "/")
                array.removeLast()
                
                let photoCoreData = Pokemon(context: DataController.shared.viewContext)
                
                photoCoreData.pokemonName = pokemon.name
                if let id = array.last {
                    photoCoreData.pokemonURL = "https://pokeres.bastionbot.org/images/pokemon/\(id).png"
                }
                if (id == self.randomTargetIndex) {
                    photoCoreData.targetPokemon = true
                } else {
                    photoCoreData.targetPokemon = false
                }

                photoCoreData.creationDate = Date()
                self.pokemons.append(photoCoreData)
                DataController.shared.saveContext()
            }
            
             DispatchQueue.main.async {
                self.getTargetPokemonName()
             }
         }
    }
}

extension TimeMode: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TreeCell
        let pokemon = pokemons[(indexPath as NSIndexPath).row]
       
        cell.isLoading(true)

        if imageReset {
            cell.treeImage.image = nil
        }
                
        if let imageURL = pokemon.pokemonURL, let url = URL(string: imageURL) {
            cell.downloadImage(from: url, imageSize: imageSize)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TreeCell
        if ( (indexPath as NSIndexPath).row == randomTargetIndex) {

            cell.updateImageGuess(imageSize: imageSize)
            score += 1
            
            deleteAllData()
            getPokemonsRandomSet()
            
        } else {
            cell.updateImageGuess(imageSize: imageSize, correctGuess: false)
        }
    }
}

extension TimeMode: UICollectionViewDelegateFlowLayout  {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + self.sectionInsets.left + self.sectionInsets.right
        cellViewSize = (collectionView.frame.size.width - space) / 2.0
        imageSize = CGSize(width: cellViewSize, height: cellViewSize)
        return imageSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
