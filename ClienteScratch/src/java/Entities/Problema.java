/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Entities;


import java.util.ArrayList;


public class Problema {

    public String id;
    public String idProfesor;
    public String enunciado;
    public ArrayList<Pieza> piezas = new ArrayList<>();
    public ArrayList<Pieza> solucion = new ArrayList<>();

    public Problema() {
    }
  
}
