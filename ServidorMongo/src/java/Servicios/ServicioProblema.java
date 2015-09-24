/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servicios;

import Entities.Problema;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import org.bson.Document;

/**
 *
 * @author FranciscoJesús
 */
@Path("Problema")
public class ServicioProblema {

    /**
     * Método que inserta un problema en la base de datos
     *
     * @param n
     * @return
     */
    @POST
    @Path("insertarProblema")
    @Consumes({"application/xml", "application/json"})
    @Produces("application/json")
    public Problema insertar(Problema n) {

        try {
            MongoDB.insert(n, "Problemas");
        } catch (Exception e) {
            return null;
        }
        return n;
    }

    /**
     * Servicio el cual a partir de un id se devuelve un problema específico
     *
     * @param id
     * @return
     */
    @GET
    @Path("buscarProblema")
    @Produces("application/json")
    public Problema leerProblema(@QueryParam("id") String id) {

        Document res = MongoDB.findById(id, "Problemas");
        return res!=null?new Problema(res):null;
    }
}