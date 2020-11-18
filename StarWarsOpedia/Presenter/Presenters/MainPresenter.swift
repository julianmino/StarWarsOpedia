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
  
  func getDatasource() {
    delegate?.onStartService()
    MainManager.sharedInstance.fetchFilms(delegate: self)
    delegate?.onFinishedService()
  }
  
  func getDataFromSearch(with string:String) {
    delegate?.onStartService()
    MainManager.sharedInstance.searchStarships(for: string, delegate: self)
    delegate?.onFinishedService()
  }
}

//MARK: - MainManagerDelegate

extension MainPresenter: MainManagerDelegate {
  func onStartService() {
    
  }
  
  func onFinishedService() {
    
  }
  
  func onError(message: String) {
    print(message)
  }
  
  func onFetchFilms(films: [Film]?) {
    _datasource = films ?? []
    delegate?.getMainData()
  }
  
  func onSearchStarships(starships: [Starship]?) {
    _datasource = starships ?? []
    delegate?.getMainData()
  }
  
}
