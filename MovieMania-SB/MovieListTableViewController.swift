//
//  MovieListTableViewController.swift
//  MovieMania-SB
//
//  Created by Pierce Gallego on 10/5/23.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    @IBOutlet var movieListTableView: UITableView!
    var listOfFruits = ["Apple", "Mango", "Grapes", "Pineapple", "Orange", "Banana"]
    var movieList: [MovieDetail] = [MovieDetail]()
    
    var favoriteButtonDelegate: FavoriteButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchMovies()
        self.movieListTableView.register(MovieListItemTableViewCell.nib, forCellReuseIdentifier: MovieListItemTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListItemTableViewCell.identifier, for: indexPath) as! MovieListItemTableViewCell

        // Configure the cell...
        let movie = movieList[indexPath.row]
        cell.configure(with: movie)
        cell.delegate = self
        print("ForRowAt: \(movie.isFavorite) \(movie.movie.trackName) \(cell.isFavorite)")
//        cell.movie = movie

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController()
        movieDetailViewController.movie = movieList[indexPath.row]
        movieDetailViewController.favoriteButtonDelegate = self
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }

}

extension MovieListTableViewController: FavoriteButtonDelegate {
    func didChangeFavoriteStatus(isFavorite: Bool) {
        if let selectedIndexPath =  self.movieListTableView.indexPathForSelectedRow {
            var selectedMovie = movieList[selectedIndexPath.row]
            selectedMovie.isFavorite = isFavorite
            self.movieListTableView.reloadData()
        }
    }
}

extension MovieListTableViewController: MovieListItemTableViewCellDelegate {
    func favoriteButtonPressed(for cell: MovieListItemTableViewCell) {
        if let indexPath = movieListTableView.indexPath(for: cell) {
            var movie = movieList[indexPath.row]
            movie.isFavorite = cell.isFavorite
            movieList[indexPath.row] = movie
            movieListTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension MovieListTableViewController {
    
    func fetchMovies() {
        MovieListRequest().fetchMovieListRequest { [self] result in
            switch result {
            case .success(let fetchResults):
                DispatchQueue.main.async {
                    self.movieList = []
                    if let results = fetchResults.results {
                        self.movieList = results.map({ result in
                            return MovieDetail(movie: result, isFavorite: false)
                        })
                    }
                    self.movieListTableView.reloadData()
                }
            case .failure(let error):
                print("Error in fetching: \(error)")
            }
        }
    }
}


//extension MovieListTableViewController: MovieDetailViewControllerDelegate {
//    func movieDetailViewController(_ viewController: MovieDetailViewController, didChangeFavoriteStatus isFavorite: Bool) {
//        if let indexPath = self.tableView.indexPathForSelectedRow {
//            if let cell = self.tableView.cellForRow(at: indexPath) as? MovieListItemTableViewCell {
//                cell.isFavorite = isFavorite
//                cell.iconChange(cell.favoriteButton)
//            }
//        }
//    }
//}
