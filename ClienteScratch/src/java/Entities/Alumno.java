/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entities;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Javier Ordoñez Martín
 */
@XmlRootElement
public class Alumno {

    public String id;
    public String nombre;
    public String apellidos;
    public String dni;
    public String idUsuario;
    public List<String> idAsignaturas = new ArrayList<>();

    public Alumno() {

    }

}
