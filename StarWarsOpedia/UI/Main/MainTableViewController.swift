/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import SVProgressHUD

class MainTableViewController: UITableViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  
  private var presenter = MainPresenter()

  override func viewDidLoad() {
    super.viewDidLoad()
    SVProgressHUD.setBackgroundColor(.black)
    SVProgressHUD.setForegroundColor(.white)
    searchBar.delegate = self
    presenter.setDelegate(self)
    presenter.getDatasource()
  }
  
  //MARK: - UITableViewDelegate, UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.datasource.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FilmsTableViewCell", for: indexPath) as? FilmsTableViewCell {
      let item = presenter.datasource[indexPath.row]
      cell.setup(displayable: item)
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = presenter.datasource[indexPath.row]
    performSegue(withIdentifier: "showDetail", sender: item)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationVC = segue.destination as? DetailViewController, let item = sender as? Displayable {
      destinationVC.data = item
    }
  }
  
}

// MARK: - UISearchBarDelegate
extension MainTableViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let shipName = searchBar.text else { return }
    presenter.getDataFromSearch(with: shipName)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.resignFirstResponder()
    presenter.getDatasource()
  }
}

//MARK: - MainPresenterDelegate

extension MainTableViewController: MainPresenterDelegate {
  
  func onStartService() {
    SVProgressHUD.show()
  }
  
  func onFinishedService() {
    SVProgressHUD.dismiss()
  }
  
  func getMainData() {
    tableView.reloadData()
  }
  
}
