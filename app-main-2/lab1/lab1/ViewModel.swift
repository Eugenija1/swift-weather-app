//
//  ViewModel.swift
//  lab1
//
//  Created by AppleLab on 19/05/2021.
//

import Foundation
import Combine


//class ViewModel: ObservableObject{
  //  @Published var woeId: String = "2487956"
    //@Published var message: String = "()"
    
    //private var cancellables: Set<AnyCancellable> = []
    
    //private var fetcher: MetaWeatherFeatcher
    
  //  func fetchWeather(forId woeId: String){
//        fetcher.forecast(forId: woeId)
//            .sink(receiveCompletion: {completion in
 //               print(completion)
 //           }, receiveValue: {value in
//                print(value)
 //           })
 //           .store(in: &cancellables)
 //   }
    
 //  init(){
 //       fetcher = MetaWeatherFeatcher()
        
//        $woeId
//            .debounce(for: 0.5, scheduler: RunLoop.main)
//            .map({value in
//                print(value)
//                return value
//            })
//            .sink(receiveValue: fetchWeather(forId:))
 //           .store(in: &cancellables)
 //       print("This is cancelables \(cancellables)")
        //print(cancellables)
 //   }
    
//}
