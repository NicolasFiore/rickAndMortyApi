//
//  ViewController.swift
//  Rick and Morty
//
//  Created by Nicolás Fiore on 28/02/2024.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var barraDeBusqueda: UISearchBar!
    
    var arrayPersonajes: [Result] = []
    var personajesFiltrados: [Result] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        barraDeBusqueda.delegate = self
        
        tableVIew.dataSource = self
        tableVIew.register(UINib(nibName: "PersonajesCardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardPersonajes")

    }


}

extension ViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        personajesFiltrados = []
        
        if barraDeBusqueda.text == "" {
            personajesFiltrados = arrayPersonajes
        }
        else {
            for personaje in arrayPersonajes {
                if personaje.name.lowercased().contains((barraDeBusqueda.text?.lowercased())!){
                    personajesFiltrados.append(personaje)
                }
            }
        }
        
        self.tableVIew.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVIew.dequeueReusableCell(withIdentifier: "cardPersonajes", for: indexPath) as? PersonajesCardTableViewCell
        
        let request = AF.request("https://rickandmortyapi.com/api/character")
        request.responseDecodable(of: RickAndMortyModelo.self){ (respuesta) in
            cell?.nombre.text = respuesta.value?.results[indexPath.row].name
            
            switch respuesta.value?.results[indexPath.row].species{
            case .alien:
                cell?.especie.text = "👽 \(respuesta.value?.results[indexPath.row].species.rawValue ?? "ERROR")"
            case .human:
                cell?.especie.text = "🫀 \(respuesta.value?.results[indexPath.row].species.rawValue ?? "ERROR")"
            case .none:
                cell?.especie.text = "ERROR"
            }
            
            switch respuesta.value?.results[indexPath.row].gender{
            case .female:
                cell?.genero.text = "Genero: 👩🏼"
            case .male:
                cell?.genero.text = "Genero: 👨🏻"
            case .unknown:
                cell?.genero.text = "Genero: ❓"
            case .none:
                cell?.genero.text = "Genero: Error"
            }
            
            switch respuesta.value?.results[indexPath.row].status{
            case .alive:
                cell?.status.text = "Estatus: 😁"
            case .dead:
                cell?.status.text = "Estatus: ☠️"
            case .unknown:
                cell?.status.text = "Estatus: ❓"
            case .none:
                cell?.status.text = "Estatus: Error"
            }
            
            let urlNoImage = "https://programacion.net/files/article/20161110041116_image-not-found.png"
            guard let url = URL(string: respuesta.value?.results[indexPath.row].image ?? urlNoImage ) else{return}
            cell?.imagen.kf.setImage(with: url)
            
        }
        return cell!
    }
    
    
}
