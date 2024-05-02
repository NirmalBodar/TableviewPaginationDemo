//
//  ViewController.swift
//  Tableviewdemo
//
//  Created by Bodar Nirmal on 02/05/24.
//

import UIKit

class customtablecell: UITableViewCell {
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblbody: UILabel!
    
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var items: PostRes? = []
    var currentPage = 1
    var isFetching = false 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }
    
    func fetchData() {
        guard !isFetching else { return }
        isFetching = true
        
        let apiUrl = "https://jsonplaceholder.typicode.com/posts?page=\(currentPage)&limit=10"
        print("URL",apiUrl)
        guard let url = URL(string: apiUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                   let postRes = try? JSONDecoder().decode(PostRes.self, from: data)

                // Append the new data to your items array
                self.items?.append(contentsOf: postRes ?? [])
                // Convert to a string and print
                if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                    print("Response",JSONString)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.currentPage += 1
                    self.isFetching = false
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customtablecell", for: indexPath) as! customtablecell
        let item = items?[indexPath.row]
        cell.lbltitle?.text = item?.title
        cell.lblbody?.text = item?.body
        return cell
    }
    
    // UITableViewDelegate method for pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            fetchData() // Load more data when reaching the bottom of the table view
        }
    }
}

