//
//  APICaller.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import Foundation

struct Constants {
    static let API_KEY = "4dcc0cb5bbad7fb3209bd65aca372efe"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping(Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(results)
                
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
//                print(results.results[0].original_title)
                completion(.success(results.results))
            } catch {
                print("getTrendingMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
    func getTrendingTvs(completion: @escaping(Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("getTrendingMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping(Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("getPopularMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping(Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("getUpcomingMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping(Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("getTopRatedMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func discoverMovies(completion: @escaping(Result<[Show], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("getTopRatedMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
    func searchShow(with query: String, completion: @escaping(Result<[Show], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(ShowsResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print("getTopRatedMovies: \(error.localizedDescription)")
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
}
