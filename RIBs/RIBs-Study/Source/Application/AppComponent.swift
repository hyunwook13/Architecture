//
//  AppComponent.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/24/25.
//

import Foundation
import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
