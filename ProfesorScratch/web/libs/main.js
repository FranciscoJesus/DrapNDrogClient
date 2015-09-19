/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function(){
    var counts = [0];
    var jsonPiezas = "";
    var estilo_piezas = ["#CEEF72", "#FFFDA8", "#F0F8FF", "#FF9E9E"];
    var index = 0;
    
    $(".dragIn").draggable({
        helper:'clone',
        start: function(){ 
            counts[0]++;
        }
    });
    
    /**
     * Funcion que convierte un elementos como arrastable
     * 
     * @param {type} element
     * @returns {undefined}
     */
    function make_draggable(element){
        element.draggable({
            helper:'clone'
        });
    }
    
    $("#content-panel").droppable({
        accept: ".dragIn, .dragOut",
        drop: function(ev, ui) {
            if (!ui.draggable.hasClass("dragOut")) {
                var droppedItem = $(ui.draggable).clone();
                droppedItem.addClass("item-" + counts[0]);
                droppedItem.addClass("dragOut");
                droppedItem.removeClass("dragIn");
                $("#sortable").append(droppedItem);
            }
        }
    });
     
    $("#bin-panel").droppable({
        accept: ".dragOut",
        drop: function(ev, ui) {
            $(ui.draggable).remove();
        }
    });
    
    $("#sortable").sortable();
    
    function cleanPieces(f){
        index = 0;
        $(".piece").remove();
    }
    
    /**
     * 
     * @param {type} f
     * @returns {f.value|String|jQuery}
     */
    function buildPieceField(f){

        //$.content = "";
        
        // Comprobamos que tenemos un tipo de pieza para poder identificarlo
        if(f.type === undefined ){
            throw_alert("warning","No se encuentra el tipo de componente en una pieza");
            return ;
        }
        
        switch(f.type){
            
            case "label":
                $.content = $('<p/>');
                $.content.text(f.value);
                break;
                
            case "text":
                /**
                 * $.wrapper = $('<div/>');
                 * $.wrapper.addClass("col-md-5");
                 */
                $.content = $('<input/>').attr({ type: 'text'});
                $.content.addClass("form-control");
                $.content.addClass("input-text-piece");
                
                //$.content = $.wrapper.append($.content);
                break;
                
            case "select":
                $.content = $('<select/>');
                f.value.forEach(function(option) {
                    $.content.append("<option>" + option + "</option>");
                });
                break;
            
            default: 
                $.content = "";
                break;
        }
        
        //console.log($.content);
        return $.content;
    }
    
    /**
     * Función para construir las piezas en HTML
     * @param {type} f
     * @returns {undefined}
     */
    function buildPieces(f){
        jsonPiezas = f;
        var o = JSON.parse( f );
        
        cleanPieces(f);
        
        //Comprobamos que tenemos un array
        if(o.length === undefined || o.length <= 0){
            throw_alert("warning","No se encuentran piezas en el fichero");
            return;
        }
        
        o.forEach(function(pieces) {
            
            // Comprobamos que tenemos inputs
            if (pieces.inputs !== undefined){
                
                var pieza = $('<div/>', {
                    //id: 'div',
                    title: 'Piece',
                    class: "row piece dragIn ui-draggable ui-draggable-handle"
                });

                pieces.inputs.forEach(function(entry) {
                    $.input = buildPieceField(entry);

                    //$.input.addClass("col-md-" + calcular_ancho_pieza(pieces.inputs.length));
                    pieza.append($.input);
                });

                make_draggable(pieza);
                pieza.css({"background-color": color_piezas()});
                $("#pieces-panel").append(pieza, null);
                
            } else {
                throw_alert("warning","No se encuentran piezas en el fichero");
                return;
            }
            
        });
    }
    
    /**
     * Funcion que procesa un fichero en tiempo de ejecución para generar las piezas
     * @param {type} evt
     * @returns {undefined}
     */
    function leerFichero(evt) {
        var f = evt.target.files[0];
        
        if (f.type.match('text.*')) {
            var reader = new FileReader();

            reader.onload = (function(theFile) {
                return function(e) {
                    var json = e.target.result;
                    
                    if( isValidJson(json)) buildPieces(json);   //Construir piezas
                    else throw_alert("danger","El fichero <strong>" + f.name + "</strong> introducido no tiene un formato válido.");
                };
            })(f);
            reader.readAsText(f);
        }else throw_alert("danger","El fichero <strong>" + f.name + "</strong> introducido no es un fichero válido");
    }

    document.getElementById('files').addEventListener('change', leerFichero, false);
    
    /**
     * Función que recoge el enunciado y devuelve el contenido.
     * @returns {jQuery}
     */
    function getEnunciado(){
        return $('#enunciado').val();
    }
    
    /**
     * Función que controla el botón de finalizar
     * Se encarga de recoger el enunciado, las piezas utilizadas y la solución planteada para enviarlas al servidor.
     */
    $("#finalizar").click(function(ev, ui) {
        
        var json;
        var enunciado = getEnunciado(); //Obtenemos el enunciado
        var solucion = getSolucion();   //Obtemenos la solución planteada
        
        /* @todo - Control de errores */
        json = '{\"enunciado\":\"' + enunciado + '", \"piezas\":' + jsonPiezas + ", \"solucion\":" + solucion + "}";
        //var ob = JSON.parse(json);
        console.log(json);
        
        $.ajax({
            type: 'POST',
            url: "http://localhost:8080/ServidorMongo/API/Problema/insertarProblema",
            data: json,
            contentType: "application/json",
            dataType: 'jsonp',
            success: function(data, textStatus, jqXHR){
                console.log(data);
            }
        });
         
    });

    function getSolucion() {
        var list = $("#sortable").find(".piece ");
        //var piezas = "[";
        var piezas = "[";
        
        if (list != null) {
            for (var i = 0, len = list.length; i < len; i++) {
                piezas += "{\"inputs\":[";

                for (var r = 0, tam = list[i].children.length; r < tam; r++) {

                    if (list[i].children[r].nodeName == "P") {
                        piezas += "{\"type\":\"label\",\"value\":\"" + list[i].children[r].innerHTML + "\"}";
                    } else if (list[i].children[r].nodeName == "INPUT") {
                        piezas += "{\"type\":\"text\",\"value\": \"" + list[i].children[r].value + "\"}";
                    } else if (list[i].children[r].nodeName == "SELECT") {
                        piezas += "{\"type\":\"select\",\"value\":\"" + list[i].children[r].value + "\"}";
                    }

                    if (r + 1 < tam) piezas += ",";
                }

                piezas += "]}";
                if (i + 1 < len) piezas += ",";
                
            }
        }
       piezas = piezas + "]";
        return piezas;
    }
    
    /**
     * 
     * @param {type} numInputs
     * @returns {Number}
     */
    function calcular_ancho_pieza(numInputs){
        var width = 0;
        var max = 11;
        
        width = Math.floor(max / numInputs);
        
        return width;
    }
    
    function throw_alert(type, message){
        var span = "";
        
        switch(type){
            case "warning": span = "<strong>Warning!</strong>";
            break;
            
            case "danger": span = "<strong>Danger!</strong>";
            break;
            
            case "success": span = "<strong>Success!</strong>";
            break;
            
            case "info": span = "<strong>Info!</strong>";
            break;
        }
        
        $.alert = $("<div/>");
        $.alert.addClass('alert alert-' + type);
        $.alert.append("<a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a>");
        $.alert.append( span +  " " + message );
        
        $("#alert_placeholder").append($.alert);
        
        /*
        $("#alert_placeholder").html("\n\
            <div class='alert alert-" + type + "'>\n\
                <a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a>\n\
                " + span +  " " + message + ".\n\
            </div>");        
                            */
                           
                           
    }
    
    /**
     * 
     * @returns {String}
     */
    function color_piezas(){
        index = (index + 1)%4;
        return estilo_piezas[index];
    }
    
    function isValidJson(json) {
        try {
            JSON.parse(json);
            return true;
        } catch (e) {
            return false;
        }
    }
    
});
