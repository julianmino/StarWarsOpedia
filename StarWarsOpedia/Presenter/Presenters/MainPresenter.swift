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

import Foundation
import Alamofire

protocol MainPresenterDelegate {
  func onStartService()
  func onFinishedService()
  func getMainData()
}
class MainPresenter {

  private var delegate: MainPresenterDelegate?
  
  init() {
    
  }
  
  func setDelegate(_ delegate: MainPresenterDelegate?) {
    self.delegate = delegate
  }
  private var _datasource = [Displayable]() {
    didSet {
      delegate?.getMainData()
    }
  }
  var datasource: [Displayable]? {
    return _datasource
  }
  
  func fetchFilms(completion: @escaping ([Film]?) -> Void) {
    var results: [Film]?
    AF.request("https://swapi.dev/api/films").validate().responseDecodable(of: FilmsViewModel.self) { (response) in
      guard let films = response.value else {
        return
      }
      results = films.all
      completion(results)
    }
  }
  
  func searchStarships(for name: String, completion: @escaping ([Starship]?) -> Void) {
    // 1
    let url = "https://swapi.dev/api/starships"
    // 2
    let parameters: [String: String] = ["search": name]
    // 3
    AF.request(url, parameters: parameters).validate().responseDecodable(of: Starships.self) { response in
        // 4
        guard let starships = response.value else { return }
        
      completion(starships.all)
    }
  }
  
  func getDatasource() {
    delegate?.onStartService()
    
    //Set DataSource
    fetchFilms(completion: { (results) in
      if let safeResults = results {
        self._datasource = safeResults
      }
    })
    
    
    delegate?.onFinishedService()
    
  }
  
  func getDataFromSearch(with string:String) {
    
    delegate?.onStartService()
    //Set Search Datasource
    
    searchStarships(for: string) { (starships) in
      if let safeStarships = starships {
        self._datasource = safeStarships
      }
    }
    
    delegate?.onFinishedService()
  }
}
