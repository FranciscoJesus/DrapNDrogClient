<%-- 
    Document   : listadoProblemas
    Author     : Edgar Pérez Ferrando
--%>

<%@page import="java.util.List"%>
<%@page import="Entities.Problema"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entities.Profesor"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <script type="text/javascript" src="libs/jquery-2.1.4/jquery-2.1.4.min.js"></script>
        <script type="text/javascript" src="libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>
        <script type="text/javascript" src="libs/bootstrap-filestyle/bootstrap-filestyle.min.js"> </script>
        <script type="text/javascript" src="libs/alerts.js"></script>
        
        <!-- Bootstrap -->
        <link href="libs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <script src="libs/bootstrap/js/bootstrap.min.js"></script>
        
        <!-- Hojas de estilo -->
        <link rel="stylesheet" type="text/css" href="styles.css"/>

        <title>Drag and Build - Build Your Question!</title>
        
    </head>
    <body>
        <% 
            HttpSession sesion = request.getSession(false);
            Profesor p = (Profesor)sesion.getAttribute("usuario");
            List<Problema> list = new ArrayList<Problema>();
            int num = 1;
            
            if(p == null){
                sesion.invalidate();
                RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                dispatcher.forward(request, response);
            }else{
                list = (ArrayList<Problema>)request.getAttribute("problemas");                
            }
        %>
        
        <%@include file="navegacion.jsp" %>
        
        <div class="container">

            <%@include file="header.jsp" %>

            <div id="alert_placeholder"></div>
            
            <% if(list.size() > 0 ){ %>
            
                <table class="table table-striped">
                    <thead>
                        <th>#</th>
                        <th>Titulo</th>
                        <th>Asignatura</th>
                        <th>Enunciado</th>
                        <th></th>
                    </thead>
                <% for(Problema t : list ){ %>
                    <tr>
                        <td><%= num %></td>
                        <td><%= t.titulo %></td>
                        <td><%= t.nombreAsignatura %></td>
                        <td><%= t.enunciado %></td>
                        <td>
                            <div class="btn-group btn-group-md btn-group-justified botonera" role="group" aria-label="...">
                                <a href="SolucionServlet?id=<%= t.id%>" class="btn btn-default btn-sm">Soluciones</a>
                                <a href="EditarProblemaServlet?id=<%= t.id%>" class="btn btn-default btn-sm">
                                    <span class="glyphicon glyphicon-pencil"></span> Editar 
                                </a>
                                    <a href="EliminarProblemaServlet?id=<%= t.id %>" class="btn btn-default btn-sm">
                                    <span class="glyphicon glyphicon-trash"></span> Eliminar
                                </a>
                            </div>
                        </td>
                    </tr>

                <% num++; %>
                <% } %>

                </table>
                
            <% }else{ %>
                <script type="text/javascript">
                    throw_alert("warning","No hay problemas propuestos");
                </script>
            <% } %>
        </div>
        
        <% 
            String respuesta = (String)request.getAttribute("estado");
            if(respuesta != null){
                Integer alerta = Integer.parseInt(respuesta);
                if( alerta > 0 ){
                    %><script type="text/javascript">throw_alert("success","Problema eliminado correctamente")</script><%
                }else if( alerta < 0 ){
                    %><script type="text/javascript">throw_alert("error","No se ha podido eliminar el problema")</script><%
                }
            }
        %>
        
    </body>
</html>
