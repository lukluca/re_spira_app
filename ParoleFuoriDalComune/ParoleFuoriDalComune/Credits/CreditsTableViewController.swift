//
//  CreditsTableViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 12/09/21.
//

import UIKit

final class CreditsTableViewController: UITableViewController {
    
    let viewModel = CreditsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.section == CreditsViewModel.Section.poem.rawValue && indexPath.row == 0,
            let cellVM = viewModel.poem {
            
            var configuration = cell.defaultContentConfiguration()
            configuration.text = cellVM.title
            configuration.secondaryText = cellVM.subtitle
            cell.contentConfiguration = configuration
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.estimatedHeightForRow(at: indexPath)
    }
}
