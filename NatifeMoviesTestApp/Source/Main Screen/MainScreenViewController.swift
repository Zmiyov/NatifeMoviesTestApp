//
//  MainScreenViewController.swift
//  NatifeMoviesTestApp
//
//  Created by Volodymyr Pysarenko on 21.06.2024.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    
    override func loadView() {
        super.loadView()

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    private func loadData() {

        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkYzE2MzY0NWUzMTk5ZmFiZTNmNjA3MzZhNDY4ZiIsInN1YiI6IjY2NzVhZjg2N2Q2NDUzMTU1YTZjNzZkNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0y2vslnW6CqKlLPIoxXY-6C-AWvvdHRpTsh7IlyLgC0"
        ]

        Task {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
        }
    }
}
