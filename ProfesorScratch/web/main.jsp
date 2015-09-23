<%-- 
    Document   : main.jsp
    Created on : Sept 3, 2015
    Author     : Edgar Perez Ferrando
--%>

<%@page import="Entities.Input"%>
<%@page import="Entities.Pieza"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Entities.Problema"%>
<%@page import="Entities.Profesor"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Drag and Drop - Build Your Question!</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0,user-scalable=no">
        <!-- Librerias jQuery online
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script> -->

        <script type="text/javascript" src="libs/jquery-2.1.4/jquery-2.1.4.min.js"></script>
        <script type="text/javascript" src="libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>
        <script type="text/javascript" src="libs/bootstrap-filestyle/bootstrap-filestyle.min.js"></script>
        <!-- <script type="text/javascript" src="libs/jquery-ui-contextmenu/jquery.ui-contextmenu.min.js"></script> -->
        <script type="text/javascript" src="libs/main.js"></script>

        <!-- Bootstrap -->
        <link href="libs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <script src="libs/bootstrap/js/bootstrap.min.js"></script>

        <!-- Hojas de estilo -->
        <link rel="stylesheet" type="text/css" href="styles.css"/>
        
    </head>
    <body>
        <% 
            HttpSession sesion = request.getSession(false);
            Profesor p = (Profesor)sesion.getAttribute("usuario");
            
            if(p == null){
                sesion.invalidate();
                RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                dispatcher.forward(request, response);
            }
            
        %>
        
        <%@include file="navegacion.jsp" %>
        
        <div class="container">
            
            <%@include file="header.jsp" %>

            <div id="alert_placeholder"></div>

            <div class="row">
                <div class="col-md-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Enunciado</h3>
                        </div>

                        <div id="question-panel" class="panel-body">
                            <textarea class="form-control" rows="3" id="enunciado"></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">

                <div class="col-md-9">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Builder panel</h3>
                        </div>

                        <div id="content-panel" class="panel-body grid">
                            <ul id="sortable">
                            </ul>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-4 col-xs-4 col-lg-4 col-sm-4 col-md-offset-4 col-sm-offset-4 col-lg-offset-4 col-xs-offset-4">
                            <button id="finalizar" type="button" class="btn btn-success button-send">Finalizar</button>
                        </div>
                    </div>

                </div>

                <div class="col-md-3" >
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Asignatura</h3>
                        </div>
                                                
                        <div id="pieces-panel-content" class="panel-body row">
                            <div id="input-file" class="col-md-6 col-sm-6 col-lg-6 col-xs-6 col-xs-offset-3 col-md-offset-3 col-sm-offset-3 col-lg-offset-3">
                                <!-- <input type="select" id="files" class="filestyle" data-input="false" data-badge="false" name="files" >
                                    <option>Option</option>
                                </input> -->
                                <select class="form-control">
                                    <option>-------</option>
                                    <option>Mustard</option>
                                    <option>Ketchup</option>
                                    <option>Relish</option>
                                </select>
                            </div>
                            <div id="pieces-panel" class="col-md-10 col-sm-10 col-lg-10 col-xs-10 col-xs-offset-1 col-md-offset-1 col-sm-offset-1 col-lg-offset-1"></div>
                        </div>
                    </div>
                    
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Pieces panel</h3>
                        </div>
                                                
                        <div id="pieces-panel-content" class="panel-body row">
                            <div id="input-file" class="col-md-6 col-sm-6 col-lg-6 col-xs-6 col-xs-offset-3 col-md-offset-3 col-sm-offset-3 col-lg-offset-3">
                                <input type="file" id="files" class="filestyle" data-input="false" data-badge="false" name="files" />
                            </div>
                            <div id="pieces-panel" class="col-md-10 col-sm-10 col-lg-10 col-xs-10 col-xs-offset-1 col-md-offset-1 col-sm-offset-1 col-lg-offset-1"></div>
                        </div>
                    </div>
                    
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Bin</h3>
                        </div>

                        <div id="bin-panel" class="panel-body">
                            <img id="bin-image" class="img-responsive img-thumbnail" src="images/bin-original.png"/>
                        </div>
                    </div>

                </div>

            </div>
        </div>
<!--        
        <script type="text/javascript">
            $(function(){
                $("#nav").load("navegacion.jsp"); 
            });
        </script>
-->        
        <%
            Problema t = (Problema)request.getAttribute("problema");
            if(t != null){
        %>
                <script type="text/javascript">
                    $(function(){
                        $("#enunciado").val("<%= t.enunciado %>");
                    });
                </script>
        <%
                    List<Pieza> piezas = new ArrayList<Pieza>();
                    piezas = t.piezas;
                    String json = "";
                    
                    for( Pieza pieza : piezas ){
                        List<Input> inputs = new ArrayList<Input>();
                        inputs = pieza.inputs;
                        for( Input tag : inputs){
                            json += tag.generarJSON() + ",";
                        }
                    }
            } 
        %>
    </body>
</html>
