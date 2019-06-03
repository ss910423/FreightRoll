//
//  AccountViewModel.swift
//  FreightrollMobile
//
//  Created by Yevgeniy Motov on 4/18/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//

import Foundation

final class AccountViewModel {
    
    enum Cell {
        case field(label: String, value: String?)
        case available(isAvailable: Bool)
        case spacing
        case editAccount(label: String)
        case changePassword(label: String)
        case logout(label: String)
        case about(label: String)
        case privacy(label: String)
        case contact(label: String)
        case map
        case heading(label: String)
        
        var cellHeight: Double {
            switch self {
            case .spacing:
                return 20
            case .field, .available, .editAccount, .changePassword,
                 .logout, .about, .privacy, .contact:
                return 50
            case .map:
                return 230.0
            case .heading:
                return 40
            }
        }
    }
    
    private var user: User?
    
    var didFetchUserHandler: () -> () = {}
    
    var cells: [Cell] = []
    
    var numberOfCells: Int {
        return cells.count
    }
    
    func cellHeight(at index: Int) -> Double {
        return cells[index].cellHeight
    }
    
    func loadData() {
        getAPI().getUser(delegate: self)
    }
    
    func getCells() -> [Cell] {
        var cells: [Cell] = []
        
        cells.append(Cell.map)
        //cells.append(Cell.available(isAvailable: toggle))
        cells.append(Cell.spacing)
        
        // cells.append(Cell.heading(label: "Account"))
        // cells.append(Cell.editAccount(label: "Edit account info"))
        // cells.append(Cell.changePassword(label: "Change password"))
        // cells.append(Cell.spacing)
        
        cells.append(Cell.heading(label: "Freightroll"))
        cells.append(Cell.about(label: "About"))
        cells.append(Cell.privacy(label: "Privacy Policy"))
        cells.append(Cell.contact(label: "Contact Us"))
        
        cells.append(Cell.heading(label: ""))
        cells.append(Cell.logout(label: "Log out"))
        cells.append(Cell.spacing)

        return cells
    }
}

// MARK: - User Data
extension AccountViewModel {
    var userFirstName: String {
        return user?.firstName ?? ""
    }
    
    var userLastName: String {
        return user?.lastName ?? ""
    }
    
    var userFullName: String {
        return "\(userFirstName) \(userLastName)"
    }
    
    var userCompanyName: String {
        return user?.personalInfo?.companyName ?? ""
    }
    
    var userBillingInfoCompanyName: String {
        return user?.billingInfo?.companyName ?? ""
    }
    
    var userImageUrl: URL? {
        return user?.image
    }
}

// MARK: - GetUser API Delegate
extension AccountViewModel: GetUserDelegate {
    func getUserSuccess(user: User) {
        self.user = user
        cells = getCells()
        
        didFetchUserHandler()
    }
}

extension AccountViewModel: APIErrorDelegate {
    func apiError(code: Int?, message: String) {
        
    }
}
