<nav role="navigation" class="navbar navbar-default navbar-static-top">
  <div class="container">
    
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="index.jsp">Drag & Build</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

      <ul class="nav navbar-nav navbar-right">
                <li><a href="main.jsp">Nuevo Problema</a></li>
                <li><a href="ListaProblemasServlet">Problemas</a></li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><%= p.nombre + " " + p.apellidos %><span class="caret"></span></a>
                    <ul role="menu" class="dropdown-menu">
                        <li><a href="LogoutServlet">Cerrar sesi�n</a></li>
                    </ul>
                </li>
            </ul>
    </div>
  </div>
</nav>