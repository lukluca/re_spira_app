//
//  CreditsTableViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 12/09/21.
//

import UIKit

final class CreditsTableViewController: UITableViewController {
    
    var viewModel: CreditsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.section == 0 && indexPath.row == 0, let viewModel = viewModel {
            cell.textLabel?.text = viewModel.title
            cell.detailTextLabel?.text = viewModel.subtitle
        }
        
        return cell
    }
}
