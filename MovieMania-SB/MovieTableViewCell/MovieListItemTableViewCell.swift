//
//  MovieListItemTableViewCell.swift
//  MovieMania-SB
//
//  Created by Pierce Gallego on 10/5/23.
//

import UIKit

protocol MovieListItemTableViewCellDelegate: AnyObject {
    func favoriteButtonPressed(for cell: MovieListItemTableViewCell)
}

class MovieListItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var movie: MovieDetail?
    
    static let identifier = "MovieListItem"
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    var isFavorite: Bool = false
    weak var delegate: MovieListItemTableViewCellDelegate?
    
    func configure(with movie: MovieDetail) {
        self.movie = movie
        self.movieTitle?.text = movie.movie.trackName
        self.moviePoster.downloaded(from: movie.movie.artworkUrl100!)
        self.movieGenre?.text = movie.movie.primaryGenreName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isFavorite = ((movie?.isFavorite) != nil)
        self.iconChange(favoriteButton)
        // Initialization code
    }
    
    func iconChange(_ sender: UIButton) {
        let buttonIcon = isFavorite ? "star.fill" : "star"
        self.movie?.isFavorite = self.isFavorite
        sender.setImage(UIImage(systemName: buttonIcon), for: .normal)
    }
    
    
    @IBAction func onPress(_ sender: UIButton) {
        self.isFavorite.toggle()
        self.iconChange(sender)
        
        delegate?.favoriteButtonPressed(for: self)
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
