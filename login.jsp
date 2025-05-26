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
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    
    if (email == null || senha == null || email.isEmpty() || senha.isEmpty())  { //verifica se os dados estão vazios
    
    } else { //caso o email e senha não sejam nulos ele ira executar  o codigo abaixo
            
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/estacionamento_administrador";
            String user = "root";
            String password = "root"; //SEMPRE COLOCAR O ROOT
            
            Connection connecta;
  
            connecta = DriverManager.getConnection(url, user, password);
            String sql = "SELECT cargo FROM usuario WHERE email = ? AND senha = ?";
            PreparedStatement ps = connecta.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, senha);
            ResultSet rs = ps.executeQuery(); //cria uma variavel do result set

            if (rs.next()) { //procura o usuario
                String cargo = rs.getString("cargo"); //procura "cargo"
                if ("ADMINISTRADOR".equalsIgnoreCase(cargo)) { //compara os valores, se o cargo do usuario for administrador ele envia para a pagina de admin
                    response.sendRedirect("admin.html");
                } else if ("OPERADOR".equalsIgnoreCase(cargo)) {
                    response.sendRedirect("operador.html"); //compara os valores, se o cargo do usuario for operador ele envia para a pagina do operador.
                } else {
                    out.println("Cargo não reconhecido: " + cargo);
                }
            } else {
                response.sendRedirect("index.html");
            }
            ps.close();
            rs.close();
            connecta.close();
        } catch (Exception e) {
            out.println("Erro: " + e.getMessage());
            e.printStackTrace(); //imprime no console (terminal) todos os detalhes do erro que aconteceu dentro do try-catch.
        }
    }
%>
    </body>
</html>
