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
  private var _datasource = [Displayable]()
  var datasource: [Displayable] {
    return _datasource
  }
  
  func fetchFilms(completion: @escaping ([Film]?) -> Void) {
    AF.request("https://swapi.dev/api/films").validate().responseDecodable(of: FilmsViewModel.self) { (response) in
      completion(response.value?.all)
    }
  }
  
  func searchStarships(for name: String, completion: @escaping ([Starship]?) -> Void) {
    let url = "https://swapi.dev/api/starships"
    let parameters: [String: String] = ["search": name]
    AF.request(url, parameters: parameters).validate().responseDecodable(of: Starships.self) { response in
      completion(response.value?.all)
    }
  }
  
  func getDatasource() {
    delegate?.onStartService()
    fetchFilms(completion: { (results) in
      self._datasource = results ?? []
      self.delegate?.getMainData()
    })
    delegate?.onFinishedService()
  }
  
  func getDataFromSearch(with string:String) {
    delegate?.onStartService()
    searchStarships(for: string) { (starships) in
      self._datasource = starships ?? []
      self.delegate?.getMainData()
    }
    delegate?.onFinishedService()
  }
}
