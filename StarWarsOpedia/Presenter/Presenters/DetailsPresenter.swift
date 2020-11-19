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

protocol DetailsPresenterDelegate {
  func onStartService()
  func onFinishedService()
  func getDetailsData()
}
class DetailsPresenter {

  private var delegate: DetailsPresenterDelegate?
  var selectedValue: Displayable?
  init() {
    
  }
  
  func setDelegate(_ delegate: DetailsPresenterDelegate?) {
    self.delegate = delegate
  }
  private var _datasource = [Displayable]()
  var datasource: [Displayable] {
    return _datasource
  }
  
  func getDatasource() {
    
    delegate?.onStartService()

    if let selectedValue = selectedValue {
      switch selectedValue {
      case is Film:
        DetailsManager.sharedInstance.fetch(selectedValue.listItems, of: Starship.self, delegate: self)
      case is Starship:
        DetailsManager.sharedInstance.fetch(selectedValue.listItems, of: Film.self, delegate: self)
      default:
        print("Unknown type: ", String(describing: type(of: selectedValue)))
      }
      
    }
    
    delegate?.onFinishedService()
  }
}

extension DetailsPresenter: DetailsManagerDelegate {
  func onFetchStarships(items: [Displayable]?) {
    _datasource = items ?? []
    delegate?.getDetailsData()
    
  }
  
  func onStartService() {
    delegate?.onStartService()
  }
  
  func onFinishedService() {
    delegate?.onFinishedService()
  }
  
  func onError(message: String) {
    print(message)
  }
  
  
}
