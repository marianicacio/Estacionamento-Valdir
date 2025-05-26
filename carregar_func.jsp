<%@page import = "java.sql.Connection"%>
<%@page import = "java.sql.DriverManager"%>
<%@page import = "java.sql.*"%>
<%@page import = "java.sql.ResultSet" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
       <%
       //recebe o código do produto a ser alterado e 
       // na variavel.
       String email;
       email = request.getParameter("email");
       Connection  conecta;
       PreparedStatement st;
       Class.forName("com.mysql.cj.jdbc.Driver");
       String url="jdbc:mysql://localhost:3306/estacionamento_administrador";
       String user="root";
       String password="root";
       
       conecta=DriverManager.getConnection(url,user,password);
       //Buscar o produto pelo código recebido
       String sql = ("SELECT * FROM usuario WHERE email = ?");
       st = conecta.prepareStatement(sql);
       //ResultSet serve para guardar aquilo que é trazido pelo BD
       st.setString(1, email);
       ResultSet resultado = st.executeQuery();
       //Verifica se o produto de codigo informado foi encontrado
       if (!resultado.next()){
           out.print("Este funcionario não foi localizado");
            }else{ // se encontrou o produto na tabela
                    //carrega estes dados dentro de um formulario
            %>
            <form method="post" action="editarfunc.jsp">
                
                <p>
                    <input type="hidden" name="emailAntigo" value="<%= resultado.getString("email") %>">
                    <label for="nome" >Nome do usuario :</label>
                    <input type="text" name="email" id="email" value="<%= resultado.getString ("email")%>" required>
                  
               </p>    
               <p>
                   
                <label for="senha" >Senha: </label>
                <input type="password" name="senha" id="marca" value="<%= resultado.getString("senha")%>" required>
               </p>
              <p>
                         <label for="Cargo">Ensira qual sera o cargo do funcionario:</label>
                        <select name="cargo" id="cargo" required>
                        <option value="" disabled>Selecione um cargo</option>
                        <option value="Administrador" <%= resultado.getString("cargo").equals("Administrador") ? "selected" : "" %>>Administrador</option>
                        <option value="Operador" <%= resultado.getString("cargo").equals("Operador") ? "selected" : "" %>>Operador</option>
                        </select>

               </p>
               <p>
               <input type="submit" value= "Salvar Alterações">
               </p>
            </form>
                <%
                    }
                %>
    </body>
</html>
