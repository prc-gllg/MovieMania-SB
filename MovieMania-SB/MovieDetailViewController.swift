//
//  MovieDetailViewController.swift
//  MovieMania-SB
//
//  Created by Pierce Gallego on 10/5/23.
//

import UIKit

protocol FavoriteButtonDelegate: AnyObject {
    func didChangeFavoriteStatus(isFavorite: Bool)
}

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    var movie: MovieDetail?
    var isFavorite: Bool = false
    
    weak var favoriteButtonDelegate: FavoriteButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movie?.movie.trackName
        moviePoster.downloaded(from: movie?.movie.artworkUrl100 ?? "")
        movieGenre.text = movie?.movie.primaryGenreName
        movieDescription.text = movie?.movie.longDescription
        self.isFavorite = ((movie?.isFavorite) != nil)
        self.iconChange(isFavoriteButton)
        
        // Do any additional setup after loading the view.
    }

    func iconChange(_ sender: UIButton) {
        let buttonIcon = isFavorite ? "star.fill" : "star"
        self.movie?.isFavorite = self.isFavorite
        sender.setImage(UIImage(systemName: buttonIcon), for: .normal)
    }
    
    @IBAction func onPress(_ sender: UIButton) {
        self.isFavorite.toggle()
        self.iconChange(sender)
        favoriteButtonDelegate?.didChangeFavoriteStatus(isFavorite: isFavorite)
    }
}

extension MovieDetailViewController: FavoriteButtonDelegate {
    func didChangeFavoriteStatus(isFavorite: Bool) {
        self.isFavorite = isFavorite
        self.iconChange(isFavoriteButton)
        favoriteButtonDelegate?.didChangeFavoriteStatus(isFavorite: isFavorite)
    }
}
