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

protocol MainManagerDelegate: BaseManagerDelegate {
  func onFetchFilms(films: [Film]?)
  func onSearchStarships(starships: [Starship]?)
}
class MainManager: BaseManager {
  class var sharedInstance: MainManager {
    struct Static {
      static let instance = MainManager()
    }
    return Static.instance
  }
  
//  func fetchFilms(completion: @escaping ([Film]?) -> Void) {
//    AF.request("https://swapi.dev/api/films").validate().responseDecodable(of: FilmsViewModel.self) { (response) in
//      completion(response.value?.all)
//    }
//  }
  
  func fetchFilms(delegate: MainManagerDelegate) {
    delegate.onStartService()
    AF.request("https://swapi.dev/api/films").validate().responseDecodable(of: FilmsViewModel.self) { (response) in
      if let error = response.error {
        delegate.onError(message: error.localizedDescription)
      }
      else {
        delegate.onFetchFilms(films: response.value?.all)
      }
      delegate.onFinishedService()
    }
  }
  
//  func searchStarships(for name: String, completion: @escaping ([Starship]?) -> Void) {
//    let url = "https://swapi.dev/api/starships"
//    let parameters: [String: String] = ["search": name]
//    AF.request(url, parameters: parameters).validate().responseDecodable(of: Starships.self) { response in
//      completion(response.value?.all)
//    }
//  }
  
  func searchStarships(for name: String, delegate: MainManagerDelegate) {
    delegate.onStartService()
    
    let url = "https://swapi.dev/api/starships"
    let parameters: [String: String] = ["search": name]
    AF.request(url, parameters: parameters).validate().responseDecodable(of: Starships.self) { response in
      
      if let error = response.error {
        delegate.onError(message: error.localizedDescription)
      }
      else {
        delegate.onSearchStarships(starships: response.value?.all)
      }
      delegate.onFinishedService()
    }
  }
  
  
}

